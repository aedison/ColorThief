//
//  CTGrabberViewController.h
//  ColorThief
//
//  Created by Alex Edison on 4/22/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class ColorView, colorSquare, Palettes;

@interface CTGrabberViewController : UIViewController <UIScrollViewDelegate>
- (IBAction)modeSwitch:(id)sender;
- (IBAction)deleteSquare:(id)sender;
- (IBAction)saveColor:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet ColorView *colorView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) Palettes *palette;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSManagedObjectContext *moc;

// Gesture Recognizers
@property (nonatomic, strong) UIPinchGestureRecognizer *gPinch;
@property (nonatomic, strong) UIPanGestureRecognizer *gPan;
@property (nonatomic, strong) UITapGestureRecognizer *gTap;

@end
