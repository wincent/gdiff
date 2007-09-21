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
        self->changes = [[NSMutableArray alloc] init];
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %#x>: %@", NSStringFromClass([self class]), self, [changes description]];
}

#pragma mark -
#pragma mark Other methods

+ (WOFile *)fileWithPath:(NSString *)aPath
{
    NSParameterAssert(aPath != nil);
    WOFile *file = [[self alloc] init];
    [file setPath:aPath];
    return file;
}

- (void)appendChange:(WOChange *)aChange
{
    NSParameterAssert(aChange != nil);
    [changes addObject:aChange];
}

#pragma mark -
#pragma mark Properties

- (void)setPath:(NSString *)aPath
{
    path = [aPath copy];
}

@end
