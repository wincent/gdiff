//
// gdiff.h
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
// Copyright 2007 Wincent Colaiuta.

//! \file gdiff.h
//! Project-wide macros

//! Width of the WOGutterView used for drawing line numbers.
#define WO_GUTTER_WIDTH 72.0

//! Width of the WOGlueView used for drawing bezier curves that link deletions on the left (the "from" file) with insertions on the right (the "to" file).
//! Note that this width is only advisory and may be rounded up if necessary in order to completely fill the window's horizontal space; this occurs when dividing up the space equally between the two file views results in an extra pixel of slack (whenever there are an odd number of pixels division by two will result in a remainder of one).
#define WO_GLUE_WIDTH   72.0

//! The absolute path to the <tt>ditto</tt> tool as a constant C string.
//! <tt>ditto</tt> is included in the base Mac OS X install.
#define WO_DITTO        "/usr/bin/ditto"
