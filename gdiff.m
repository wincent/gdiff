//
// gdiff.m
// gdiff
//
// Created by Wincent Colaiuta on 21 September 2007.
// Copyright 2007 Wincent Colaiuta.

// system headers
#import <Foundation/Foundation.h>

// project headers
#import "WODiff.h"
#import "WODiffMachine.h"

void usage(const char *executable)
{
    fprintf(stderr, "usage: %s PATCHFILE...\n", executable);
}

int main(int argc, const char *argv[])
{
    int                 exit_status = EXIT_SUCCESS;
    NSAutoreleasePool   *pool       = [[NSAutoreleasePool alloc] init];
    WODiffMachine       *machine    = [WODiffMachine diffMachine];

    if (argc == 1)
    {
        usage(argv[0]);
        exit_status = EXIT_FAILURE;
    }
    else
    {
        // for now just pre-process the arguments: ultimately will pass these off to the GUI app
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
    }
    [pool drain];
    return exit_status;
}
