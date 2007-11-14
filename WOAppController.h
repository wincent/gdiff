//
// WOAppController.h
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
