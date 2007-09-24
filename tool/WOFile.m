//
// WOFile.m
// gdiff
//
// Created by Wincent Colaiuta on 21 September 2007.
// Copyright 2007 Wincent Colaiuta.

// class header
#import "WOFile.h"

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
    NSParameterAssert(aChange != nil);
    [changes addObject:aChange];
}

#pragma mark -
#pragma mark Properties

@synthesize fromPath;
@synthesize toPath;
@synthesize fromHash;
@synthesize toHash;
@synthesize changes;

@end
