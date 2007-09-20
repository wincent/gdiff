#import <Foundation/Foundation.h>
#import <string.h> /* strlen() */
#import <stdlib.h> /* EXIT_SUCCESS */

// global variables (single-threaded processing only; eventually encapsulate this in a class
int             line_idx    = 0;
NSMutableArray  *files      = nil;


%%{
  machine diff;

  # machine order here is largely determined by Ragel (no forward references allowed)
  linefeed                  = "\n" @{ line_idx++; };
  sp                        = " " ;
  tab_escape                = "\\t" ;
  linefeed_escape           = "\\n" ;
  quote_escape              = "\\\"" ;
  backslash_escape          = "\\\\" ;
  escape                    = tab_escape | linefeed_escape | quote_escape | backslash_escape ;

  git_diff_header           = "diff --git" sp (any - linefeed)+ linefeed ;

  octal_digit               = "0".."7" ;
  mode                      = octal_digit octal_digit octal_digit octal_digit octal_digit octal_digit ;

  hex_digit                 = "0".."9" | "a".."f" ;
  hash                      = hex_digit hex_digit hex_digit hex_digit hex_digit hex_digit hex_digit ;

  # start with basic set of possible headers seen in samples
  # later support others in git.git/Documentation/diff-format.txt if necessary
  extended_header           = "deleted file mode" sp mode linefeed
                            | "new file mode" sp mode linefeed
                            | "index" sp hash ".." hash (sp mode)? linefeed ;

  dev_null                  = "/dev/null" @{ NSLog(@"/dev/null"); };

  quoted_from_filespec      = '"a/' (escape | [^"\\\n])+ '"' ;
  unquoted_from_filespec    = "a/" (any - linefeed)+ ;
  from_filespec             = quoted_from_filespec | unquoted_from_filespec | dev_null ;

  quoted_to_filespec        = '"b/' (escape | [^"\\\n])+ '"' ;
  unquoted_to_filespec      = "b/" (any - linefeed)+ ;
  to_filespec               = quoted_to_filespec | unquoted_to_filespec | dev_null ;

  from_spec                 = "---" sp from_filespec linefeed @{ NSLog(@"from_spec"); };
  to_spec                   = "+++" sp to_filespec linefeed @{ NSLog(@"to_spec"); };

  from_range                = "-" ;
  to_range                  = "+" ;
  range                     = digit+ ("," digit+)? ;
  range_spec                = "@@" sp from_range range sp to_range range sp "@@" (any - linefeed)* linefeed;

  context_line              = sp (any - linefeed)* linefeed @{ NSLog(@"context line %d", line_idx); };
  deletion_line             = "-" (any - linefeed)* linefeed @{ NSLog(@"deletion %d", line_idx); };
  insertion_line            = "+" (any - linefeed)* linefeed @{ NSLog(@"insertion %d", line_idx);};
  newline_warning           = "\\ No newline at end of file" linefeed @{ NSLog(@"warning %d", line_idx);};

  chunk                     = range_spec
                            . (context_line | deletion_line | insertion_line | newline_warning )+ ;
  file_block                = git_diff_header
                            . extended_header+
                            . from_spec
                            . to_spec
                            . chunk+ ;
  main                      := file_block+ linefeed @{ NSLog(@"main");};

}%%

int main(int argc, char **argv)
{
    int exit_status = EXIT_SUCCESS;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for (int i = 1; i < argc; i++)
    {
        NSError *error;
        NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithUTF8String:argv[i]] options:0 error:&error];
        if (!data)
        {
            fprintf(stderr, "%s\n", [[error localizedDescription] UTF8String]);
            exit_status = EXIT_FAILURE;
            continue;
        }
        
        line_idx    = 0;
        files       = [NSMutableArray array];
        
        // setup Ragel data structures
        int cs;                         // current state; initially diff_start
        char *p = (char *)[data bytes]; // data pointer
        char *pe = p + [data length];   // data end pointer
        %% write data;
        %%{
            write init;
            write exec;
        }%%
    }
    [pool drain];
    return exit_status;
}
