//
// WOGutterView.m
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
// Copyright 2007 Wincent Colaiuta.
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

// class header
#import "WOGutterView.h"

// other headers
#import "gdiff.h"

@implementation WOGutterView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect
{
    NSRect  bounds          = [self bounds];
    NSColor *borderColor    = nil;

    // draw left border if required
    if (borderMask & WOLeftBorder)
    {
        NSRect leftBorder = NSMakeRect(0.0, 0.0, WO_BORDER_WIDTH, bounds.size.height);
        NSRect draw = NSIntersectionRect(leftBorder, rect);
        if (!NSIsEmptyRect(draw))
        {
            borderColor = [NSColor lightGrayColor];
            [borderColor set];
            NSRectFill(draw);
        }
    }

    // draw right border if required
    if (borderMask & WORightBorder)
    {
        NSRect rightBorder = NSMakeRect(bounds.size.width - WO_BORDER_WIDTH, 0.0, WO_BORDER_WIDTH, bounds.size.height);
        NSRect draw = NSIntersectionRect(rightBorder, rect);
        if (!NSIsEmptyRect(draw))
        {
            // border color will already be set if left border was drawn
            if (!borderColor)
                [[NSColor lightGrayColor] set];
            NSRectFill(draw);
        }
    }

    // set up paragraph attributes
    // TODO: user control over font type and size
    NSFont *font = [NSFont userFixedPitchFontOfSize:0.0];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    if (borderMask & WORightBorder)
        [style setAlignment:NSRightTextAlignment];
    else
        [style setAlignment:NSLeftTextAlignment];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                font,                       NSFontAttributeName,
                                [NSColor darkGrayColor],    NSForegroundColorAttributeName,
                                style,                      NSParagraphStyleAttributeName, nil];

    // draw line numbers
    // testing only
    NSRect lineRect = [self bounds];
    [@"1234" drawInRect:lineRect withAttributes:attributes];
}

#pragma mark -
#pragma mark Properties

@synthesize borderMask;

@end
