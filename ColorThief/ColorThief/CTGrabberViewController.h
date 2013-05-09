//
//  CTGrabberViewController.h
//  ColorThief
//
//  Created by Alex Edison on 4/22/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class ColorView, Palettes;

@interface CTGrabberViewController : UIViewController
- (IBAction)modeSwitch:(id)sender;

@property (strong, nonatomic) IBOutlet ColorView *colorView;

@property (nonatomic, strong) Palettes *palette;
@property (nonatomic, strong) UIImage *image;

@end
