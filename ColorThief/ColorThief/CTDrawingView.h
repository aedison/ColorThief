//
//  CTDrawingView.h
//  ColorThief
//
//  Created by Alex Edison on 5/12/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import <UIKit/UIKit.h>

@class colorSquare;

@interface CTDrawingView : UIView

@property (nonatomic, strong) colorSquare *colorSquare;

// Image we are holding
@property (nonatomic, strong) UIImage *image;

//View we are directly overlaying
@property (nonatomic, strong) UIView *overlayedView;

//Scale factor
@property (nonatomic) float scale;

@end
