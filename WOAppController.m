//
//  WOAppController.m
//  gdiff
//
//  Created by Wincent Colaiuta on 25 September 2007.
//  Copyright 2007 Wincent Colaiuta.

// class header
#import "WOAppController.h"

// other project headers
#import "gdiff.h"

@interface WOAppController ()

#pragma mark -
#pragma mark Installation methods

//! Presents an error object on the main thread and then calls the installationDidFinishWithStatus: callback method with a negative status.
- (void)presentError:(NSError *)error;

//! Creates and presents an appropriate NSError for an OSStatus-indexed error generated while using the Authorization Services API.
- (void)presentErrorForAuthorizationFailure:(OSStatus)err;

//! Creates and presents an appropriate NSError in the POSIX domain for installation errors (calls to ditto, read etc).
- (void)presentErrorForInstallationFailure:(int)err;

//! Performs actual intallation in a separate thread.
- (void)performInstallationForCurrentUser:(id)ignored;

//! Performs actual installation in a separate thread.
- (void)performInstallationForAllUsers:(NSValue *)refValue;

//! Callback invoked on main thread.
//! \p status is an NSNumber initialized with a BOOL value indicating the outcome of the installation (YES for success, NO for failure).
- (void)installationDidFinishWithStatus:(NSNumber *)status;

#pragma mark -
#pragma mark Property redeclarations

@property(readwrite) BOOL installing;

@end

@implementation WOAppController

#pragma mark -
#pragma mark Interface Builder actions

- (IBAction)installForCurrentUser:(id)sender
{
    NSAssert(self.installing == NO, @"already installing");
    self.installing = YES;
    [NSThread detachNewThreadSelector:@selector(performInstallationForCurrentUser:) toTarget:self withObject:nil];
}

- (IBAction)installForAllUsers:(id)sender
{
    NSAssert(self.installing == NO, @"already installing");
    self.installing             = YES;
    AuthorizationRef    ref;
    OSStatus            err     = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &ref);
    if (err != errAuthorizationSuccess)
    {
        self.installing = NO;
        NSLog(@"error: AuthorizationCreate returned %d", err);
        [self presentErrorForAuthorizationFailure:err];
        return;
    }
    AuthorizationItem   item    = { kAuthorizationRightExecute, 0, NULL, 0 };
    AuthorizationRights rights  = { 1, &item };
    AuthorizationFlags  flags   = kAuthorizationFlagDefaults            |
                                  kAuthorizationFlagInteractionAllowed  |
                                  kAuthorizationFlagPreAuthorize        |
                                  kAuthorizationFlagExtendRights;
    err = AuthorizationCopyRights(ref, &rights, NULL, flags, NULL);
    if (err != errAuthorizationSuccess)
    {
        NSLog(@"error: AuthorizationCopyRights returned %d", err);
        [self presentErrorForAuthorizationFailure:err];
        AuthorizationFree(ref, kAuthorizationFlagDefaults);
    }

    // NOTE: if this doesn't work just pass a pointer or stick the it in an instance variable
    NSValue *valueRef = [NSValue value:&ref withObjCType:@encode(AuthorizationRef)];
    [NSThread detachNewThreadSelector:@selector(performInstallationForAllUsers:) toTarget:self withObject:valueRef];
}

- (IBAction)showInstallationHelp:(id)sender
{

}

#pragma mark -
#pragma mark Installation methods

- (void)presentError:(NSError *)error
{
    [NSApp performSelectorOnMainThread:@selector(presentError:) withObject:error waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(installationDidFinishWithStatus:)
                           withObject:[NSNumber numberWithBool:NO]
                        waitUntilDone:YES];
}

- (void)presentErrorForAuthorizationFailure:(OSStatus)err
{
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                          NSLocalizedString(@"Could not obtain authorization.", @""),
                          NSLocalizedDescriptionKey,
                          NSLocalizedString(@"Try again later.", @""),
                          NSLocalizedRecoverySuggestionErrorKey, nil];
    [self presentError:[NSError errorWithDomain:NSOSStatusErrorDomain code:err userInfo:info]];
}

- (void)presentErrorForInstallationFailure:(int)err
{
    // TODO: possibly add button to open Console?
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                          NSLocalizedString(@"An error occurred during installation.", @""),
                          NSLocalizedDescriptionKey,
                          NSLocalizedString(@"Additional information has been printed to the console (see /Applications/Utilities/Console).", @""),
                          NSLocalizedRecoverySuggestionErrorKey, nil];
    [self presentError:[NSError errorWithDomain:NSPOSIXErrorDomain code:err userInfo:info]];
}

- (void)performInstallationForCurrentUser:(id)ignored
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *gdiff = [bundle pathForAuxiliaryExecutable:@"gdiff"];
    NSString *target = [[NSHomeDirectory() stringByAppendingPathComponent:@"bin"] stringByAppendingPathComponent:@"gdiff"];
    NSArray *arguments = [NSArray arrayWithObjects:gdiff, target, nil];
    NSTask *task = [NSTask launchedTaskWithLaunchPath:[NSString stringWithUTF8String:WO_DITTO] arguments:arguments];
    NSAssert(task != nil, @"no ditto task object");
    [task waitUntilExit];
    int status = [task terminationStatus];
    if (status != EXIT_SUCCESS)
        [self presentErrorForInstallationFailure:status];
    [self performSelectorOnMainThread:@selector(installationDidFinishWithStatus:)
                           withObject:status == EXIT_SUCCESS ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO]
                        waitUntilDone:YES];
    [pool drain];
}

- (void)performInstallationForAllUsers:(NSValue *)refValue
{
    // set-up
    NSParameterAssert(refValue != nil);
    NSAutoreleasePool   *pool           = [[NSAutoreleasePool alloc] init];
    NSBundle            *bundle         = [NSBundle mainBundle];
    NSString            *installer      = [bundle pathForAuxiliaryExecutable:@"installer-tool"];
    NSAssert(installer != nil, @"cannot locate installer-tool");
    const char          *tool           = [installer fileSystemRepresentation];
    NSString            *gdiff          = [bundle pathForAuxiliaryExecutable:@"gdiff"];
    NSAssert(gdiff != nil, @"cannot locate gdiff helper tool");
    char                *arguments[]    = { (char *)[gdiff fileSystemRepresentation], NULL};
    FILE                *pipe           = NULL;
    AuthorizationRef    ref;
    [refValue getValue:&ref];

    // actually execute
    OSStatus err = AuthorizationExecuteWithPrivileges(ref, tool, kAuthorizationFlagDefaults, arguments, &pipe);
    if (err != errAuthorizationSuccess)
    {
        NSLog(@"error: AuthorizationExecuteWithPrivileges returned %d", err);
        [self presentErrorForAuthorizationFailure:err];
    }
    err = AuthorizationFree(ref, kAuthorizationFlagDefaults);
    if (err != errAuthorizationSuccess)
        // don't bother the user with a high-level notification in this case; just log it instead
        NSLog(@"error: AuthorizationFree returned %d", err);

    // read child pid
    pid_t child;
    int bytes_read = read(fileno(pipe), &child, sizeof(child));
    if (bytes_read == -1)
    {
        NSLog(@"error: read returned %d (errno %d)", bytes_read, errno);
        [self presentErrorForInstallationFailure:errno];
    }
    else if (bytes_read != sizeof(child))
    {
        NSLog(@"error: read %d bytes from child process (expected %d)", bytes_read, sizeof(child));
        [self presentErrorForInstallationFailure:EIO]; // don't have a "real" errno here so just use EIO ("An I/O error occurred")
    }

    int status;
    waitpid(child, &status, WNOHANG);
    if (!WIFEXITED(status))
    {
        NSLog(@"error: child process did not exit normally (%d/%d)", errno, status);
        [self presentErrorForInstallationFailure:errno];
    }
    else
    {
        status = WEXITSTATUS(status);
        if (status != EXIT_SUCCESS)
        {
            NSLog(@"error: child exited with non-zero exit status (%d)\n", status);
            [self presentErrorForInstallationFailure:status];
        }
    }
    [self performSelectorOnMainThread:@selector(installationDidFinishWithStatus:)
                           withObject:[NSNumber numberWithBool:YES]
                        waitUntilDone:YES];
    [pool drain];
}

- (void)installationDidFinishWithStatus:(NSNumber *)status
{
    NSParameterAssert(status != nil);
    if ([status boolValue])
        [installationWindow orderOut:self];     // dismiss window only if installation succeeded
    self.installing = NO;
}

#pragma mark -
#pragma mark Properties

@synthesize installing;

@end
