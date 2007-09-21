// system headers
#import <Foundation/Foundation.h>

// project headers
#import "WODiff.h"
#import "WODiffMachine.h"

int main (int argc, const char *argv[])
{
    int                 exit_status = EXIT_SUCCESS;
    NSAutoreleasePool   *pool       = [[NSAutoreleasePool alloc] init];
    WODiffMachine       *machine    = [WODiffMachine diffMachine];

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

        WODiff *diff = [machine parseDiffData:data];
        if (diff == nil)
            exit_status = EXIT_FAILURE;
    }
    [pool drain];
    return exit_status;
}
