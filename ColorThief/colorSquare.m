//
//  colorSquare.m
//  ColorThief
//
//  Created by Kevin Tabb on 5/4/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import "colorSquare.h"

@implementation colorSquare

@synthesize fXPos = _fXPos;
@synthesize fYPos = _fYPos;
@synthesize fXSize = _fXSize;
@synthesize fYSize = _fYSize;

@synthesize redVal = _redVal;
@synthesize greenVal = _greenVal;
@synthesize blueVal = _blueVal;
@synthesize alphaVal = _alphaVal;

 - (void)init:(int)iXP :(int)iYP :(int)iXS :(int)iYS
{
    _fXPos = iXP;
    _fYPos = iYP;
    _fXSize = iXS;
    _fYSize = iYS;
}

- (UIColor*)getColorCode:(ColorView *)colorView
{
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    return color;
}

@end
