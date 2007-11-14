//
// gdiff.m
// gdiff
//
// Created by Wincent Colaiuta on 21 September 2007.
// Copyright 2007 Wincent Colaiuta.
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

// other project headers
#import "WOPathUtilities.h"

void usage(const char *executable)
{
    fprintf(stderr, "Usage:\n"
            "  %s ARGUMENTS\n"
            "    (invokes git-diff with supplied arguments and process the output)\n"
            "  git-diff ARGUMENTS | %s\n"
            "    (reads and processes git-diff output directly from the standard input)\n"
            "  cat PATCHFILES... | %s\n"
            "    (reads and processes Git patches from the standard input)\n", executable, executable, executable);
}

int process_data(NSData *data)
{
    NSCParameterAssert(data != nil);
    NSString *diff = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"diff text for processing:\n%@", diff);
    return EXIT_SUCCESS; // if it worked
}

int main(int argc, const char *argv[])
{
    int                 exit_status = EXIT_SUCCESS;
    NSAutoreleasePool   *pool       = [[NSAutoreleasePool alloc] init];

    if (argc == 1)
        // no arguments supplied: just read from standard input
        exit_status = process_data([[NSFileHandle fileHandleWithStandardInput] readDataToEndOfFile]);
    else if ((argc == 2) && (strcmp(argv[1], "--help") == 0))
    {
        // special case: only one argument and it is "--help"
        usage(argv[0]);
        exit_status = EXIT_FAILURE;
    }
    else
    {
        // all other cases: pack arguments into array and pass them off to "git-diff", capturing the output
        NSMutableArray  *arguments = [NSMutableArray array];
        for (int i = 1, max = argc; i < max; i++)
            [arguments addObject:[NSString stringWithUTF8String:argv[i]]];

        // run git-diff with arguments capture output
        NSPipe          *outPipe    = [NSPipe pipe];
        NSFileHandle    *outHandle  = [outPipe fileHandleForReading];
        NSTask          *task       = [[NSTask alloc] init];
        NSString        *gitDiff    = path_for_tool(@"git-diff");
        if (!gitDiff)
        {
            fprintf(stderr, "error: unable to locate git-diff in the current PATH\n");
            goto bail;
        }

        [task setLaunchPath:gitDiff];
        [task setArguments:arguments];
        [task setStandardOutput:outPipe];
        [task setStandardError:[NSFileHandle fileHandleWithStandardError]];
        @try
        {
            [task launch];
        }
        @catch (NSException *exception)
        {
            fprintf(stderr, "error: exception caught while trying to launch git-diff (%s: %s)\n",
                    [[exception name] UTF8String], [[exception reason] UTF8String]);
            goto bail;
        }
        [task waitUntilExit];
        exit_status = [task terminationStatus];
        if (exit_status != EXIT_SUCCESS)
        {
            fprintf(stderr, "error: git-diff terminated with exit status %d\n", exit_status);
            goto bail;
        }

        // not much sense in doing incremental processing of the data (state machine may break randomly for incomplete input)
        exit_status = process_data([outHandle readDataToEndOfFile]);
    }

bail:
    [pool drain];
    return exit_status;
}
