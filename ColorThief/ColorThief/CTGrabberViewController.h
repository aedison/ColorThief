//
//  CTGrabberViewController.h
//  ColorThief
//
//  Created by Alex Edison on 4/22/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "colorView.h"

@interface CTGrabberViewController : UIViewController
- (IBAction)modeSwitch:(id)sender;

@property (strong, nonatomic) IBOutlet ColorView *colorView;

@end
