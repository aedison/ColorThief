//
//  CTColorEditorController.h
//  ColorThief
//
//  Created by Alex Edison on 4/25/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Colors,Palettes;

@interface CTColorEditorController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *colorIV;
@property (weak, nonatomic) IBOutlet UIImageView *paletteSourceIV;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *paletteSourceLoading;
@property (weak, nonatomic) IBOutlet UILabel *paletteName;
@property (weak, nonatomic) IBOutlet UITextField *redTxtField;
@property (weak, nonatomic) IBOutlet UITextField *greenTxtField;
@property (weak, nonatomic) IBOutlet UITextField *blueTxtField;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;

- (IBAction)redSliderChanged:(UISlider *)sender;
- (IBAction)greenSliderChagned:(UISlider *)sender;
- (IBAction)bludeSliderChanged:(UISlider *)sender;

@property (strong, nonatomic) Colors* color;
@property (strong, nonatomic) Palettes* palette;
@property (strong, nonatomic) UIImage* imageForPalette;

@end
