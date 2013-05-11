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
 - (void) init:(int)iXP :(int)iYP :(int)iXS :(int)iYS;
 - (NSArray*) getRGBAsFromImage:(UIImage*)image :(int)xx :(int)yy :(int)count;

// properties
@property float fXPos;
@property float fYPos;
@property float fXSize;
@property float fYSize;

@end
