//
// WOPathUtilities.m
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
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

#import "WOPathUtilities.h"

// system headers
#import <sys/sysctl.h>

NSString *get_search_path_from_environment(void)
{
    char *path = getenv("PATH");
    return path ? [NSString stringWithUTF8String:path] : nil;
}

NSString *get_search_path_from_sysctl(void)
{
    char    *path;
    size_t  path_len;
    int     mib[] = { CTL_USER, USER_CS_PATH };

    // get size of path string
    if (sysctl(mib, 2, NULL, &path_len, NULL, 0) != 0)
    {
        perror("error: (sysctl)");
        return nil;
    }

    // allocate space for string
    path = malloc(path_len);
    if (path == NULL)
    {
        perror("error: (malloc)");
        return nil;
    }

    // actually get string
    NSString *searchPath = nil;
    if (sysctl(mib, 2, path, &path_len, NULL, 0) != 0)
        perror("error: (sysctl)");
    else // success
        searchPath = [NSString stringWithUTF8String:path];

    free(path);
    return searchPath;
}

NSString *path_for_tool(NSString *tool)
{
    NSCParameterAssert(tool != nil);
    NSString    *toolPath       = nil;

    // get current search path, expect a string like "/usr/bin:/bin:/usr/sbin:/sbin" or similar
    NSString *searchPaths = get_search_path_from_environment();
    if (!searchPaths)
    {
        fprintf(stderr, "warning: PATH environment variable not set, failing back to sysctl\n");
        searchPaths = get_search_path_from_sysctl();
    }

    if (searchPaths)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        for (NSString *searchPath in [searchPaths componentsSeparatedByString:@":"])
        {
            NSString *checkPath = [searchPath stringByAppendingPathComponent:tool];
            if ([fileManager isExecutableFileAtPath:checkPath])
            {
                toolPath = checkPath;
                break;
            }
        }
    }

    return toolPath;
}
