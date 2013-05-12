//
//  ColorView.m
//  ColorThief
//
//  Created by Kevin Tabb on 4/23/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import "ColorView.h"
#import "Palettes+Saved.h"
#import "colorSquare.h"

@implementation ColorView

@synthesize colorSquare = _colorSquare;
@synthesize fScale = _fScale;
@synthesize fXOffSet = _fXOffSet;
@synthesize fYOffset = _fYOffSet;
@synthesize iState = _iState;
@synthesize bDrawing = _bDrawing;
@synthesize fCXOffSet = _fCXOffSet;
@synthesize fCYOffset = _fCYOffSet;

/* // Alloc colorSquare
// ++++++++++++++++++++++++++++++++
if (!self.colorSquare)
{
    self.colorSquare = [[colorSquare alloc] init];
}
*/ 
- (id)initWithFrame:(CGRect)frame
{
    _fScale = 1;
    _fXOffSet = 0;
    _fYOffSet = 0;
    _bDrawing = FALSE;
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if (_iState == 0 && ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)))
    {
        // set scale to appropriate value according to pinch and redraw
        // NSLog(@"%d", _iState);
        _fScale += (gesture.scale - 1);
        gesture.scale = 1;
        [self setNeedsDisplay];
    }
}

// Reset zoom and alignment
- (void)tap:(UITapGestureRecognizer *)gesture
{
    _fXOffSet = 0;
    _fYOffSet = 0;
    _fScale = 1;
    [self setNeedsDisplay];
    // This code allows the user to draw a 1x1 square by just tapping the screen
    if (_iState == 1 && !self.colorSquare)
    {
        // Alloc colorSquare if it doesn't exist
        self.colorSquare = [[colorSquare alloc] init];
        // initialize square as 1x1 at the location of the touch
        CGPoint pLoc = [gesture locationInView:self];
        self.colorSquare.fXPos=pLoc.x;
        self.colorSquare.fYPos = pLoc.y;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint pTranslate = [gesture translationInView:self];
        CGPoint pLoc = [gesture locationInView:self];
        if (_iState == 0)
        {
            // this will shift everything when we redraw
            _fXOffSet = pTranslate.x;
            _fYOffSet = pTranslate.y;
        }
        else if (_iState == 1)
        {
            // colorSquare drawing code:
            // ++++++++++++++++++++++++++++++++
            _fCXOffSet = pTranslate.x;
            _fCYOffSet = pTranslate.y;
            if (!self.colorSquare) // This should always mean that bDrawing == FALSE
            {
                // Alloc colorSquare if it doesn't exist
                self.colorSquare = [[colorSquare alloc] initWithRect:CGRectMake(pLoc.x, pLoc.y, 1, 1)];
                // set bDrawing to true
                _bDrawing = TRUE;
            }
            else if (_bDrawing)
            {
                // if we are currently drawing the square, change the size
                self.colorSquare.fXSize = _fCXOffSet;
                self.colorSquare.fYSize = _fCYOffSet;
                // if we have finished drawing the square, set bDrawing to false
                if (gesture.state == UIGestureRecognizerStateEnded)
                {
                    _bDrawing = FALSE;
                }
            }
            else
            {
                // if we are done drawing the square, move the starting location
                self.colorSquare.fXPos = pLoc.x;
                self.colorSquare.fYPos = pLoc.y;
                self.colorSquare.fXPos -= (.5 * self.colorSquare.fXSize);
                self.colorSquare.fYPos -= (.5 * self.colorSquare.fYSize);
            }
        }
        else
        {
            NSLog(@"iState is not 0 or 1 and I have no idea how this happened");
        }
    }
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    // Redraw sample background image
//    UIGraphicsBeginImageContext(self.frame.size);
//    // NSLog(@"%f", _fScale);
//    // fScale modifies the size of the rect in which the image is drawn
//    // By incrementing fScale, the image should be drawn larger (thus, zooming in)
//    CGRect rTempRect = CGRectMake(self.bounds.origin.x + _fXOffSet, self.bounds.origin.y + _fYOffSet, self.bounds.size.width * _fScale, self.bounds.size.height * _fScale);
//    
//    [self.image drawInRect:rTempRect];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    // Update background
//    self.backgroundColor = [UIColor colorWithPatternImage:image];
    
    CGContextRef con = UIGraphicsGetCurrentContext();
    
    // draw the colorSquare:
    if (self.colorSquare)
    {
        CGRect rColorRect = CGRectMake(self.colorSquare.fXPos, self.colorSquare.fYPos, self.colorSquare.fXSize, self.colorSquare.fYSize);
        CGRect rDispRect = CGRectMake(self.colorSquare.fXPos - (2 * self.colorSquare.fXSize), self.colorSquare.fYPos - 30 - (.5 * self.colorSquare.fYSize), 50, 50);
        // move the color display to left/right depending on screen location of square
        if (self.colorSquare.fXPos > self.frame.size.width / 2)
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
        if (self.colorSquare.fYPos > self.frame.size.height / 2)
        {
            // up
            rDispRect.origin.y = rColorRect.origin.y - 50;
        }
        else
        {
            // down
            rDispRect.origin.y = rColorRect.origin.y + rColorRect.size.height;
        }
        
        CGContextSetRGBFillColor(con, 1.0, 1.0, 1.0, .35);
        CGContextFillRect(con, rColorRect);
        CGContextSetFillColorWithColor(con, [[self.colorSquare getColorFromImage:self.image] CGColor]);
        CGContextFillRect(con, rDispRect);
    }
    
}


@end
