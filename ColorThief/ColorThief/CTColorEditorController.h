//
//  CTColorEditorController.h
//  ColorThief
//
//  Created by Alex Edison on 4/25/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "CTKeyboardHandlerDelegate.h"

@class Colors,Palettes,CTKeyboardHandler;

@interface CTColorEditorController : UIViewController <UITextFieldDelegate,CTKeyboardHandlerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *colorIV;
@property (weak, nonatomic) IBOutlet UIImageView *paletteSourceIV;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *paletteSourceLoading;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *colorViewLoading;
@property (weak, nonatomic) IBOutlet UILabel *paletteName;
@property (weak, nonatomic) IBOutlet UILabel *colorHex;
@property (weak, nonatomic) IBOutlet UITextField *redTxtField;
@property (weak, nonatomic) IBOutlet UITextField *greenTxtField;
@property (weak, nonatomic) IBOutlet UITextField *blueTxtField;
@property (weak, nonatomic) IBOutlet UITextField *alphaTxtField;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;


- (IBAction)redSliderChanged:(UISlider *)sender;
- (IBAction)greenSliderChagned:(UISlider *)sender;
- (IBAction)blueSliderChanged:(UISlider *)sender;
- (IBAction)alphaSliderChanged:(UISlider *)sender;
- (IBAction)saveButton:(UIButton *)sender;
- (IBAction)resetButton:(UIButton *)sender;

@property (strong, nonatomic) Colors* color;
@property (strong, nonatomic) Palettes* palette;
@property (strong, nonatomic) UIImage* imageForPalette;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) CTKeyboardHandler* keyboard;
@property (nonatomic) int keyboardYOffset;

- (void) loadImage:(UIImage *) image
            toView:(UIImageView *)imageView
 stoppingIndicator:(UIActivityIndicatorView *) indicator;

- (BOOL) textFieldIsValid:(UITextField *)textField;

@end
