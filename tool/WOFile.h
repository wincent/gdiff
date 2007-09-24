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

    //! Repository-relative "from file" path.
    //! For newly created files this should be /dev/null, in keeping with Git conventions.
    NSString        *fromPath;

    //! Repository-relative "to file" path.
    //! For newly deleted files this should be /dev/null, in keeping with Git conventions.
    NSString        *toPath;

    //! SHA-1 blob id corresponding to the "from file".
    //! For non-existent files this will be "0000000", in keeping with Git conventions.
    NSString        *fromHash;

    //! SHA-1 blob id corresponding to the "to file".
    //! For non-existent files this will be "0000000", in keeping with Git conventions.
    NSString        *toHash;

    //! An array of WOChange objects.
    NSMutableArray  *changes;

}

// Returns a new WOFile instance.
+ (WOFile *)file;

//! \exception NSInternalInconsistencyException thrown if \p aChange is nil.
- (void)appendChange:(WOChange *)aChange;

#pragma mark -
#pragma mark Properties

- (void)setFromPath:(NSString *)aPath;
- (void)setToPath:(NSString *)aPath;

- (void)setFromHash:(NSString *)aPath;
- (void)setToHash:(NSString *)aPath;

// changes array by copy only?

@end
