//
// WOFile.m
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

// class header
#import "WOFile.h"

// other headers
#import "WOPublic/WODebugMacros.h"

@implementation WOFile

#pragma mark -
#pragma mark NSObject overrides

- (id)init
{
    if ((self = [super init]))
        self->changes = [NSMutableArray array];
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %#x, %s [%@] -> %s [%@] >: %@",
        NSStringFromClass([self class]), self,
        fromPath ? [fromPath fileSystemRepresentation] : [@"()" UTF8String],
        fromHash ? fromHash : @"?",
        toPath ? [toPath fileSystemRepresentation] : [@"()" UTF8String],
        toHash ? toHash : @"?",
        [changes description]];
}

#pragma mark -
#pragma mark Other methods

+ (WOFile *)file
{
    return [[self alloc] init];
}

- (void)appendChange:(WOChange *)aChange
{
    WOParameterCheck(aChange != nil);
    [changes addObject:aChange];
}

#pragma mark -
#pragma mark Properties

@synthesize fromPath;
@synthesize toPath;
@synthesize fromHash;
@synthesize toHash;
@synthesize fromBlob;
@synthesize toBlob;
@synthesize changes;

@end
