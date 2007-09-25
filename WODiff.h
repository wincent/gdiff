//
// WODiff.h
// gdiff
//
// Created by Wincent Colaiuta on 21 September 2007.
// Copyright 2007 Wincent Colaiuta.

@class WOFile;

@interface WODiff : NSObject {

    //! An array of WOFile objects.
    NSMutableArray *files;

}

//! Convenience method which returns a new WODiff instance.
+ (WODiff *)diff;

//! \exception NSInternalInconsistencyException thrown if \p aFile is nil.
- (void)appendFile:(WOFile *)aFile;

@end
