//
// WOFile.h
// gdiff
//
// Created by Wincent Colaiuta on 21/9/2007.
// Copyright 2007 Wincent Colaiuta.
// $Id$

#import <Cocoa/Cocoa.h>

@interface WOFile : NSObject {
    
    //! Repositary-relative path.
    NSString *path;

    //! An array of WOChange objects.
    NSMutableArray *changes;
    
}

// changes array by copy only?

@end
