//
// WOFile.h
// gdiff
//
// Created by Wincent Colaiuta on 21 September 2007.
// Copyright 2007 Wincent Colaiuta.

// system headers
#import <Foundation/Foundation.h>

@class WOChange;

@interface WOFile : NSObject {

    //! Repository-relative path.
    NSString        *path;

    //! An array of WOChange objects.
    NSMutableArray  *changes;

}

// Returns a WOFile instance based on the file at the repository-relative path, \p aPath.
//! \exception NSInternalInconsistencyException thrown if \p aPath is nil.
+ (WOFile *)fileWithPath:(NSString *)aPath;

//! \exception NSInternalInconsistencyException thrown if \p aChange is nil.
- (void)appendChange:(WOChange *)aChange;

#pragma mark -
#pragma mark Properties

- (void)setPath:(NSString *)aPath;

// changes array by copy only?

@end
