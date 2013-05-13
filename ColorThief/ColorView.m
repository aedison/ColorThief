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
#import "CTDrawingView.h"

@implementation ColorView

@synthesize fScale = _fScale;
@synthesize fXOffSet = _fXOffSet;
@synthesize fYOffset = _fYOffSet;
@synthesize iState = _iState;
@synthesize bDrawing = _bDrawing;
@synthesize fCXOffSet = _fCXOffSet;
@synthesize fCYOffset = _fCYOffSet;

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
        [self.delegate scrollViewDidZoom:self];
        // set scale to appropriate value according to pinch and redraw
        _fScale += (gesture.scale - 1);
        gesture.scale = 1;
        [self setNeedsDisplay];
    }
}

// Reset zoom and alignment
- (void)tap:(UITapGestureRecognizer *)gesture
{
    // This code allows the user to draw a 1x1 square by just tapping the screen
    if (_iState == 1 && !self.overlay.colorSquare)
    {
        // Alloc colorSquare if it doesn't exist
        self.overlay.colorSquare = [[colorSquare alloc] init];
        // initialize square as 1x1 at the location of the touch
        CGPoint pLoc = [gesture locationInView:self];
        self.overlay.colorSquare.fXPos = (pLoc.x-self.content.frame.origin.x)/self.zoomScale;
        self.overlay.colorSquare.fYPos = (pLoc.y-self.content.frame.origin.y)/self.zoomScale;
        [self setNeedsDisplay];
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint pTranslate = [gesture translationInView:self];
        CGPoint pLoc = [gesture locationInView:self];
        if (_iState == 1)
        {
            // colorSquare drawing code:
            // ++++++++++++++++++++++++++++++++

            if (!self.overlay.colorSquare) // This should always mean that bDrawing == FALSE
            {
                // Alloc colorSquare if it doesn't exist
                self.overlay.colorSquare = [[colorSquare alloc] init];
                self.overlay.colorSquare.fXPos = (pLoc.x-self.content.frame.origin.x)/self.zoomScale;
                self.overlay.colorSquare.fYPos = (pLoc.y-self.content.frame.origin.y)/self.zoomScale;
                // set bDrawing to true
                self.bDrawing = TRUE;
            }
            else if (_bDrawing)
            {
                // if we are currently drawing the square, change the size
                self.overlay.colorSquare.fXSize = pTranslate.x;
                self.overlay.colorSquare.fYSize = pTranslate.y;
                // if we have finished drawing the square, set bDrawing to false
                if (gesture.state == UIGestureRecognizerStateEnded)
                {
                    self.bDrawing = FALSE;
                }
            }
            else
            {
                // if we are done drawing the square, move the starting location
                self.overlay.colorSquare.fXPos = (pLoc.x-self.content.frame.origin.x)/self.zoomScale;
                self.overlay.colorSquare.fYPos = (pLoc.y-self.content.frame.origin.y)/self.zoomScale;
                self.overlay.colorSquare.fXPos -= (.5 * self.overlay.colorSquare.fXSize);
                self.overlay.colorSquare.fYPos -= (.5 * self.overlay.colorSquare.fYSize);
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
    self.overlay.image = self.image;
    [self.overlay setNeedsDisplay];
}


@end
