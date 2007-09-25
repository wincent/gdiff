//
// WOFile.h
// gdiff
//
// Created by Wincent Colaiuta on 21 September 2007.
// Copyright 2007 Wincent Colaiuta.

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

    //! The contents of the blob corresponding to the "from file".
    //! Note that WOFile itself doesn't know how to derive the content of a blob from the blob hash; it is just a dumb wrapper class that depends on some other entity to tell it what the blob contents are. This design pattern is chosen rather than encapsulating that knowledge inside the WOFile class because otherwise it would need to hold a reference to the WORepo instance representing the current repository, and the cleanest way of making a responsive, threaded user interface is to delegate the responsibility to another controller (which can manage hash-to-blob-content lookups in an NSOperationQueue).
    NSString        *fromBlob;

    //! The contents of the blob corresponding to the "to file".
    //! \sa fromBlob
    NSString        *toBlob;

    //! An array of WOChange objects.
    NSMutableArray  *changes;

}

// Returns a new WOFile instance.
+ (WOFile *)file;

//! \exception NSInternalInconsistencyException thrown if \p aChange is nil.
- (void)appendChange:(WOChange *)aChange;

#pragma mark -
#pragma mark Properties

@property(copy)     NSString        *fromPath;
@property(copy)     NSString        *toPath;
@property(copy)     NSString        *fromHash;
@property(copy)     NSString        *toHash;
@property(copy)     NSString        *fromBlob;
@property(copy)     NSString        *toBlob;
@property(readonly) NSMutableArray  *changes;

@end
