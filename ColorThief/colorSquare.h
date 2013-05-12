//
//  colorSquare.h
//  ColorThief
//
//  Created by Kevin Tabb on 5/4/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface colorSquare : NSObject

// functions
- (colorSquare *)init;
- (colorSquare *)initWithRect:(CGRect)rect;
- (NSArray*) getRGBAsFromImage:(UIImage*)image :(int)xx :(int)yy :(int)count;
- (UIColor*)getColorFromImage:(UIImage *)image;

// properties
@property float fXPos;
@property float fYPos;
@property float fXSize;
@property float fYSize;

@end
