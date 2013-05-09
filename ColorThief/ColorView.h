//
//  ColorView.h
//  ColorThief
//
//  Created by Kevin Tabb on 4/23/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorView : UIView

// zooming
@property (nonatomic) CGFloat fScale;

// panning
@property (nonatomic) CGFloat fXOffSet;
@property (nonatomic) CGFloat fYOffset;

// view mode/grab mode
// This property will denote whether we are in the "picture view" state or the "color select" state
// picture view = 0, color select = 1
@property (nonatomic) int iState;

@end