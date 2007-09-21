//
// WODiff.h
// gdiff
//
// Created by Wincent Colaiuta on 21/9/2007.
// Copyright 2007 Wincent Colaiuta.
// $Id$

#import <Cocoa/Cocoa.h>

@interface WODiff : NSObject {

    //! An array of WOFile objects.
    NSArray *files;

}

//! Convenience method which returns a new WODiff instance.
+ (WODiff *)diff;

@end
