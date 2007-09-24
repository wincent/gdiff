//
// WOChange.m
// gdiff
//
// Created by Wincent Colaiuta on 21 September 2007.
// Copyright 2007 Wincent Colaiuta.

// class header
#import "WOChange.h"

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
        NSParameterAssert(aLine == range.location + range.length);
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
        NSParameterAssert(aLine == range.location + range.length);
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
