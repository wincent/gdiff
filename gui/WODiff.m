//
// WODiff.m
// gdiff
//
// Created by Wincent Colaiuta on 21 September 2007.
// Copyright 2007 Wincent Colaiuta.

// class header
#import "WODiff.h"

@implementation WODiff

#pragma mark -
#pragma mark NSObject overrides

- (id)init
{
    if ((self = [super init]))
        self->files = [NSMutableArray array];
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %#x>: %@", NSStringFromClass([self class]), self, [files description]];
}

#pragma mark -
#pragma mark Other methods

+ (WODiff *)diff
{
    return [[self alloc] init];
}

- (void)appendFile:(WOFile *)aFile
{
    NSParameterAssert(aFile != nil);
    [files addObject:aFile];
}

@end
