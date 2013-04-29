//
//  ColorView.m
//  ColorThief
//
//  Created by Kevin Tabb on 4/23/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import "ColorView.h"

@implementation ColorView

@synthesize fScale = _fScale;
@synthesize fXOffSet = _fXOffSet;
@synthesize fYOffset = _fYOffset;

- (id)initWithFrame:(CGRect)frame
{
    _fScale = 1;
    _fXOffSet = 0;
    _fYOffset = 0;
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded))
    {
        // set scale to appropriate value according to pinch and redraw
        NSLog(@"%f", gesture.scale);
        _fScale += (gesture.scale - 1) * 100;
        gesture.scale = 1;
        [self setNeedsDisplay];
    }
}

// Reset zoom and alignment
- (void)tap:(UITapGestureRecognizer *)gesture
{
    _fXOffSet = 0;
    _fYOffset = 0;
    _fScale = 1;
    [self setNeedsDisplay];
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded))
    {
        // this will shift everything when we redraw
        CGPoint pTranslate = [gesture translationInView:self];
        _fXOffSet = pTranslate.x;
        _fYOffset = pTranslate.y;
        [self setNeedsDisplay];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    // Redraw sample background image
    UIGraphicsBeginImageContext(self.frame.size);
    // NSLog(@"%f", _fScale);
    // fScale linearly modifies the size of the rect in which the image is drawn
    // By incrementing fScale, the image should be drawn larger (thus, zooming in)
    CGRect rTempRect = CGRectMake(self.bounds.origin.x + _fXOffSet, self.bounds.origin.y + _fYOffset, self.bounds.size.width + _fScale, self.bounds.size.height + _fScale);
    
    [[UIImage imageNamed:@"iPhoneSamplePic.jpg"] drawInRect:rTempRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Update background
    self.backgroundColor = [UIColor colorWithPatternImage:image];
    
}


@end
