//
//  ColorView.h
//  ColorThief
//
//  Created by Kevin Tabb on 4/23/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Palettes,colorSquare,CTDrawingView;

@interface ColorView : UIScrollView


@property (nonatomic) bool bDrawing;
@property (nonatomic) CGFloat fCXOffSet;
@property (nonatomic) CGFloat fCYOffset;

// zooming
@property (nonatomic) CGFloat fScale;

// panning
@property (nonatomic) CGFloat fXOffSet;
@property (nonatomic) CGFloat fYOffset;

// Image we are holding
@property (nonatomic, strong) UIImage *image;

//Content view
@property (nonatomic, weak) UIView *content;

// The our associated drawing view
@property (nonatomic, weak) CTDrawingView *overlay;

// view mode/grab mode
// This property will denote whether we are in the "picture view" state or the "color select" state
// picture view = 0, color select = 1
@property (nonatomic) int iState;

@end
