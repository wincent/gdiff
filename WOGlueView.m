//
// WOGlueView.m
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
#import "WOGlueView.h"

// other headers
#import "gdiff.h"

@implementation WOGlueView

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

    // draw left border
    NSRect border = NSMakeRect(0.0, 0.0, WO_BORDER_WIDTH, bounds.size.height);
    NSRect draw = NSIntersectionRect(border, rect);
    if (!NSIsEmptyRect(draw))
    {
        borderColor = [NSColor lightGrayColor];
        [borderColor set];
        NSRectFill(draw);
    }

    // draw right border
    border = NSMakeRect(bounds.size.width - WO_BORDER_WIDTH, 0.0, WO_BORDER_WIDTH, bounds.size.height);
    draw = NSIntersectionRect(border, rect);
    if (!NSIsEmptyRect(draw))
    {
        // border color most likely is already set
        if (!borderColor)
            [[NSColor lightGrayColor] set];
        NSRectFill(draw);
    }
}

@end
