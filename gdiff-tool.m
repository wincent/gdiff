//
// gdiff.m
// gdiff
//
// Created by Wincent Colaiuta on 21 September 2007.
// Copyright 2007 Wincent Colaiuta.

// system headers
#import <sys/sysctl.h>

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

NSString *git_diff_path(void)
{
    NSString    *gitPath        = nil;
    NSString    *searchPaths    = nil;

    // get current search path, expect a string like "/usr/bin:/bin:/usr/sbin:/sbin" or similar
    char        *path           = getenv("PATH");
    if (path)
    {
        searchPaths = [NSString stringWithUTF8String:path];
        path        = NULL; // avoid double-freeing
    }
    else
    {
        fprintf(stderr, "warning: PATH environment variable not set, failing back to sysctl\n");
        size_t  path_len;
        int     mib[] = { CTL_USER, USER_CS_PATH };

        // get size of path string
        if (sysctl(mib, 2, NULL, &path_len, NULL, 0) != 0)
        {
            perror("error: (sysctl)");
            goto bail;
        }

        // allocate space for string
        path = malloc(path_len);
        if (path == NULL)
        {
            perror("error: (malloc)");
            goto bail;
        }

        // actually get string
        if (sysctl(mib, 2, path, &path_len, NULL, 0) != 0)
        {
            perror("error: (sysctl)");
            goto bail;
        }
        else
            searchPaths = [NSString stringWithUTF8String:path];
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSString *searchPath in [searchPaths componentsSeparatedByString:@":"])
    {
        NSString *checkPath = [searchPath stringByAppendingPathComponent:@"git-diff"];
        if ([fileManager isExecutableFileAtPath:checkPath])
            return checkPath;
    }

bail:
    if (path)
        free(path);
    return gitPath;
}

int process_data(NSData *data)
{
    NSCParameterAssert(data != nil);
    NSString *diff = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"diff text for processing:\n%@", p);
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
        NSString        *gitDiff    = git_diff_path();
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
