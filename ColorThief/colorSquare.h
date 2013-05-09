//
//  colorSquare.h
//  ColorThief
//
//  Created by Kevin Tabb on 5/4/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ColorView.h"

@interface colorSquare : NSObject

// functions
 - (UIColor*) getColorCode:(ColorView*)colorView;
 - (void) init:(int)iXP :(int)iYP :(int)iXS :(int)iYS;

// properties
@property float fXPos;
@property float fYPos;
@property float fXSize;
@property float fYSize;

@property float redVal;
@property float greenVal;
@property float blueVal;
@property float alphaVal;

@end
