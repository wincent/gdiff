//
// WOChange.m
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
#import "WOChange.h"

// other headers
#import "WOPublic/WODebugMacros.h"

@interface WOChange ()

#pragma mark -
#pragma mark Property redeclarations

@property NSRange deletedRange;
@property NSRange insertedRange;

@end

@implementation WOChange

#pragma mark -
#pragma mark NSObject overrides

- (id)init
{
    if ((self = [super init]))
    {
        self->deletedRange  = NSMakeRange(NSNotFound, 0);
        self->insertedRange = NSMakeRange(NSNotFound, 0);
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %#x>: {deletion: %@, insertion: %@}",
        NSStringFromClass([self class]), self,
        [self hasDeletion] ? NSStringFromRange(self.deletedRange) : @"none",
        [self hasInsertion] ? NSStringFromRange(self.insertedRange) : @"none"];
}

#pragma mark -
#pragma mark Other methods

+ (WOChange *)changeWithDeletionAtLine:(unsigned)aLine
{
    WOChange *change = [[WOChange alloc] init];
    [change addDeletionAtLine:aLine];
    return change;
}

+ (WOChange *)changeWithInsertionAtLine:(unsigned)aLine
{
    WOChange *change = [[WOChange alloc] init];
    [change addInsertionAtLine:aLine];
    return change;
}

- (void)addDeletionAtLine:(unsigned)aLine
{
    if ([self hasDeletion])
    {
        NSRange range = self.deletedRange;
        WOParameterCheck(aLine == range.location + range.length);
        self.deletedRange = NSMakeRange(range.location, range.length + 1);
    }
    else
        self.deletedRange = NSMakeRange(aLine, 1);
}

- (void)addInsertionAtLine:(unsigned)aLine
{
    if ([self hasInsertion])
    {
        NSRange range = self.insertedRange;
        WOParameterCheck(aLine == range.location + range.length);
        self.insertedRange = NSMakeRange(range.location, range.length + 1);
    }
    else
        self.insertedRange = NSMakeRange(aLine, 1);
}

#pragma mark -
#pragma mark Properties

- (BOOL)hasDeletion
{
    return (self.deletedRange.location != NSNotFound);
}

- (BOOL)hasInsertion
{
    return (self.insertedRange.location != NSNotFound);
}

@synthesize deletedRange;
@synthesize insertedRange;

@end
