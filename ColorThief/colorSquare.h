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
- (UIColor*)getColorFromImage:(UIImage *)image;

// properties
@property (nonatomic) float fXPos;
@property (nonatomic) float fYPos;
@property (nonatomic) float fXSize;
@property (nonatomic) float fYSize;

@end
