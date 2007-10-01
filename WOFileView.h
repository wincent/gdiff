//
// WOFileView.h
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
// Copyright 2007 Wincent Colaiuta.

@interface WOFileView : NSTextView {

    NSString    *text;
    NSArray     *changes;

}

#pragma mark -
#pragma mark Properties

@property(assign) NSString *text;
@property(assign) NSArray *changes;

@end
