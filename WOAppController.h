//
//  WOAppController.h
//  gdiff
//
//  Created by Wincent Colaiuta on 25 September 2007.
//  Copyright 2007 Wincent Colaiuta.

@interface WOAppController : NSObject {

#pragma mark Interface Builder outlets

    IBOutlet NSWindow   *installationWindow;

#pragma mark Other instance variables

    BOOL                installing;

}

#pragma mark -
#pragma mark Interface Builder actions

- (IBAction)installForCurrentUser:(id)sender;
- (IBAction)installForAllUsers:(id)sender;
- (IBAction)showInstallationHelp:(id)sender;

#pragma mark -
#pragma mark Properties

@property(readonly,getter=isInstalling) BOOL installing;

@end
