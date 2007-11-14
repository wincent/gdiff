//
// installer-tool.m
// gdiff
//
// Created by Wincent Colaiuta on 26 September 2007.
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

// system headers
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

// other project headers
#include "gdiff.h"

//! \file installer-tool.m
//! Installer tool for gdiff helper
//!
//! This separate installer tool is required because AuthorizationExecuteWithPrivileges does not provide an exit status or child process id that could be used to find it out. Determing the exit status of a child process is a critically important capability, especially in an installer, and central to the UNIX process model. In order to find out whether the executed process succeeded you either have wait for any child process (a brittle solution in cases where an application might conceivably have forked multiple child processes) or use a separate wrapper tool as a "middle man" that explicitly communicates its process id back to the parent process. This latter workaround is the one implemented here, seeing as gdiff could very well have multiple child processes due to its multithreaded nature and use of Git tools.
//!
//! Seeing as the installer will run with root privileges it is kept very simple and does one "hard-coded" job with (intentionally) no flexibility:
//!
//!     - check (and require) that we are running with root privileges
//!     - check that we have the correct number of arguments (one: the path to the gdiff tool that will be installed)
//!     - fork and exec "ditto" to copy the gdiff tool to /usr/local/bin/
//!
//! Note that there <em>is</em> a security hole in this approach; namely, that an attacker without root privileges but <em>with</em> write access to the installer tool can replace it with a binary of his or her own construction. But this hole is not unique to this implementation; any application which uses AuthorizationExecuteWithPrivileges is vulnerable to similar attacks where an attacker with write access to the application overwrites the string literals in the executable to change what is executed. In short, any application which obtains eleveted privileges and is simultaneously writeable by non-admin users is vulnerable.
//!
//! An additional degree of security may be afforded by using Leopard's code signing feature and then performing self-verification of the signature, but this is only another layer in a defense-in-depth strategy because an attacker could still replace the entire binary (along with its signature or any signature verification schemes). In general any time you add another check-then-perform layer it will be vulnerable to two possible attack vectors: either seeking the race condition (the window between the "check" and the "perform") or simply replacing the check entirely. As such this is a fundamentally unsolveable problem and one can only rely on the user to not run <em>anything</em> with elevated privileges if it could conceivably have been modified by another user.

#pragma mark -
#pragma mark Functions

int main(int argc, const char *argv[])
{
    // must be run as root or die
    if (geteuid() != 0)
    {
        fprintf(stderr, "error: must be root user to run this tool\n");
        return EXIT_FAILURE;
    }

    // we take the full-path to the gdiff tool as an argument rather than trying to calculate it dynamically
    // (it is significantly less error-prone for the calling application to do this)
    if (argc != 2)
    {
        fprintf(stderr, "error: incorrect argc (%d)\n", argc);
        return EXIT_FAILURE;
    }
    char *gdiff = (char *)argv[1];

    // notify parent process of our pid by writing it to stdout
    // necessary because AuthorizationExecuteWithPrivileges doesn't provide child pids
    // although this may seem incredibily inelegant, it's the way the Apple sample code does this
    pid_t pid = getpid();
    ssize_t count = write(fileno(stdout), &pid, sizeof(pid));
    if (count == -1)
    {
        perror("error: (write)");
        return EXIT_FAILURE;
    }
    else if (count != sizeof(pid))
    {
        fprintf(stderr, "error: write of %ld bytes failed (wrote %lud)\n", sizeof(pid), count);
        return EXIT_FAILURE;
    }

    // now run ditto (use ditto because it is always included in the base install)
    pid_t child = vfork();
    if (child == -1)
        perror("error: (vfork)");
    else if (child == 0)
    {
        // in child
        char *const args[]  =  { WO_DITTO, gdiff, "/usr/local/bin/gdiff", NULL };
        char *const env[]   = { NULL };
        execve(WO_DITTO, args, env);
        perror("error: (execve)");  // should never get to this line
        _exit(EXIT_FAILURE);
    }
    else
    {
        // in parent
        int status;
        if (waitpid(child, &status, 0) == -1)
            perror("error: (waitpid)");
        else if (!WIFEXITED(status))
            fprintf(stderr, "error: ditto did not exit normally (status %d)", status);
        else
        {
            status = WEXITSTATUS(status);
            if (status != EXIT_SUCCESS)
                fprintf(stderr, "error: ditto exited with non-zero exit status (%d)\n", status);
            return status;
        }
    }
    // TODO: consider capturing stderr of child process; otherwise it just disappears
    return EXIT_FAILURE;
}
