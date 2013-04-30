//
//  ColorView.h
//  ColorThief
//
//  Created by Kevin Tabb on 4/23/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorView : UIView

// zooming
@property (nonatomic) CGFloat fScale;

// panning
@property (nonatomic) CGFloat fXOffSet;
@property (nonatomic) CGFloat fYOffset;

@end
