//
// WOChange.m
// gdiff
//
// Created by Wincent Colaiuta on 21 September 2007.
// Copyright 2007 Wincent Colaiuta.

// class header
#import "WOChange.h"

@implementation WOChange

#pragma mark -
#pragma mark NSObject overrides

- (id)init
{
    if ((self = [super init]))
    {
        self->deletion  = NSMakeRange(NSNotFound, 0);
        self->insertion = NSMakeRange(NSNotFound, 0);
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %#x>: {deletion: %@, insertion: %@}",
        NSStringFromClass([self class]), self,
        [self hasDeletion] ? NSStringFromRange(deletion) : @"none",
        [self hasInsertion] ? NSStringFromRange(insertion) : @"none"];
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
        NSParameterAssert(aLine == deletion.location + deletion.length);
        deletion.length++;
    }
    else
        deletion = NSMakeRange(aLine, 1);
}

- (void)addInsertionAtLine:(unsigned)aLine
{
    if ([self hasInsertion])
    {
        NSParameterAssert(aLine == insertion.location + insertion.length);
        insertion.length++;
    }
    else
        insertion = NSMakeRange(aLine, 1);
}

#pragma mark -
#pragma mark Properties

- (BOOL)hasDeletion
{
    return (deletion.location != NSNotFound);
}

- (BOOL)hasInsertion
{
    return (insertion.location != NSNotFound);
}

- (NSRange)deletedRange
{
    return deletion;
}

- (NSRange)insertedRange
{
    return insertion;
}


@end
