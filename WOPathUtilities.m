//
// WOPathUtilities.m
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
// Copyright 2007 Wincent Colaiuta.

#import "WOPathUtilities.h"

NSString *path_for_tool(NSString *tool)
{
    NSCParameterAssert(tool != nil);
    NSString    *toolPath       = nil;
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
        NSString *checkPath = [searchPath stringByAppendingPathComponent:tool];
        if ([fileManager isExecutableFileAtPath:checkPath])
        {
            toolPath = checkPath;
            goto bail;
        }
    }

bail:
    if (path)
        free(path);
    return toolPath;
}
