//
//  CTDrawingView.m
//  ColorThief
//
//  Created by Alex Edison on 5/12/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import "CTDrawingView.h"
#import "colorSquare.h"

@implementation CTDrawingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef con = UIGraphicsGetCurrentContext();
    
    // draw the colorSquare:
    if (self.colorSquare)
    {
        float colorX = self.colorSquare.fXPos*self.scale+self.overlayedView.frame.origin.x;
        float colorY = self.colorSquare.fYPos*self.scale+self.overlayedView.frame.origin.y;
        
        CGRect rColorRect = CGRectMake(colorX, colorY, self.colorSquare.fXSize, self.colorSquare.fYSize);
        CGRect rDispRect = CGRectMake(rColorRect.origin.x - (2 * self.colorSquare.fXSize), rColorRect.origin.y - 30 - (.5 * self.colorSquare.fYSize), 50, 50);
        // move the color display to left/right depending on screen location of square
        if (rColorRect.origin.x > self.frame.size.width / 2)
        {
            // left
            rDispRect.origin.x = rColorRect.origin.x - 50;
        }
        else
        {
            // right
            rDispRect.origin.x = rColorRect.origin.x + rColorRect.size.width;
        }
        
        // move the color display up/down depending on screen location of square
        if (rColorRect.origin.y > self.frame.size.height / 2)
        {
            // up
            rDispRect.origin.y = rColorRect.origin.y - 50;
        }
        else
        {
            // down
            rDispRect.origin.y = rColorRect.origin.y + rColorRect.size.height;
        }
        
        UIColor *colorForDisplay = [self.colorSquare getColorFromImage:self.image];
        CGContextSetRGBFillColor(con, 1.0, 1.0, 1.0, .35);
        CGContextFillRect(con, rColorRect);
        CGContextSetFillColorWithColor(con, [colorForDisplay CGColor]);
        CGContextFillRect(con, rDispRect);
        CGContextSetRGBStrokeColor(con, 0.5, 0.5, 0.5, 1);
        CGContextStrokeRect(con,rDispRect);
    }
    
}

@end
