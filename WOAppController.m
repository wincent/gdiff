//
//  WOAppController.m
//  gdiff
//
//  Created by Wincent Colaiuta on 25 September 2007.
//  Copyright 2007 Wincent Colaiuta.

// class header
#import "WOAppController.h"

@interface WOAppController ()

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
}

- (IBAction)installForAllUsers:(id)sender
{
    NSAssert(self.installing == NO, @"already installing");
    self.installing = YES;
}

- (IBAction)showInstallationHelp:(id)sender
{

}

#pragma mark -
#pragma mark Installation

#pragma mark -
#pragma mark Properties

@synthesize installing;

@end
