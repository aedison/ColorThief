//
//  CTColorEditorController.m
//  ColorThief
//
//  Created by Alex Edison on 4/25/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import "CTColorEditorController.h"
#import "Palettes+Saved.h"
#import "Colors+Saved.h"
#import "CTKeyboardHandler.h"

#define kOFFSET_FOR_KEYBOARD 100.0

@interface CTColorEditorController ()

@end

@implementation CTColorEditorController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.keyboard.delegate = nil;
    self.keyboard = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.keyboard = [[CTKeyboardHandler alloc] init];
    self.keyboard.delegate = self;
    
    [self.paletteSourceLoading startAnimating];
    [self.colorViewLoading startAnimating];
    
    NSURL* assetURL = [NSURL URLWithString:self.palette.fileName];
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        if (iref) {
            UIImage* image = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:[rep orientation]];
            [self loadImage:image toView:self.paletteSourceIV stoppingIndicator:self.paletteSourceLoading];
        }
    };
    
    //
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"Cant get image - %@",[myerror localizedDescription]);
    };
    
    if(self.palette.fileName && [self.palette.fileName length])
    {
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:assetURL
                       resultBlock:resultblock
                      failureBlock:failureblock];
    }
    
    [self loadImage:[self.color imageFromSelf] toView:self.colorIV stoppingIndicator:self.colorViewLoading];
    
    self.redTxtField.text = [NSString stringWithFormat:@"%.3g",[self.color.red floatValue]*255];
    self.greenTxtField.text = [NSString stringWithFormat:@"%.3g",[self.color.green floatValue]*255];
    self.blueTxtField.text = [NSString stringWithFormat:@"%.3g",[self.color.blue floatValue]*255];
    self.alphaTxtField.text = [NSString stringWithFormat:@"%.3g",[self.color.alpha floatValue]*255];
    self.paletteName.text = self.palette.paletteName;
    
    self.redSlider.maximumValue=255;
    self.greenSlider.maximumValue=255;
    self.blueSlider.maximumValue=255;
    self.alphaSlider.maximumValue=255;
    
    self.redSlider.value = 255*self.color.red.floatValue;
    self.greenSlider.value = 255*self.color.green.floatValue;
    self.blueSlider.value = 255*self.color.blue.floatValue;
    self.alphaSlider.value = 255*self.color.alpha.floatValue;
    
    self.redTxtField.delegate=self;
    self.greenTxtField.delegate=self;
    self.blueTxtField.delegate=self;
    self.alphaTxtField.delegate=self;
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.keyboardYOffset = self.blueTxtField.frame.origin.y;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)redSliderChanged:(UISlider *)sender
{
    self.redTxtField.text=[NSString stringWithFormat:@"%.3g", sender.value];
    self.color.red = [NSNumber numberWithFloat: sender.value/255];
    [self loadImage:[self.color imageFromSelf] toView:self.colorIV stoppingIndicator:self.colorViewLoading];
}

- (IBAction)greenSliderChagned:(UISlider *)sender
{
    self.greenTxtField.text=[NSString stringWithFormat:@"%.3g", sender.value];
    self.color.green = [NSNumber numberWithFloat: sender.value/255];
    [self loadImage:[self.color imageFromSelf] toView:self.colorIV stoppingIndicator:self.colorViewLoading];
}

- (IBAction)blueSliderChanged:(UISlider *)sender
{
    self.blueTxtField.text=[NSString stringWithFormat:@"%.3g", sender.value];
    self.color.blue = [NSNumber numberWithFloat: sender.value/255];
    [self loadImage:[self.color imageFromSelf] toView:self.colorIV stoppingIndicator:self.colorViewLoading];
}

- (IBAction)alphaSliderChanged:(UISlider *)sender
{
    self.alphaTxtField.text=[NSString stringWithFormat:@"%.3g", sender.value];
    self.color.alpha = [NSNumber numberWithFloat: sender.value/255];
    [self loadImage:[self.color imageFromSelf] toView:self.colorIV stoppingIndicator:self.colorViewLoading];
}

- (IBAction)saveButton:(UIButton *)sender
{
    // Commit the change.
    NSError *error = nil;
    self.color.idKey=[[self.color hexString] stringByAppendingString:self.palette.paletteName];
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Could not save color -- %@",error);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)resetButton:(UIButton *)sender
{
    // Rollback any changes
    [self.managedObjectContext rollback];
    [self loadImage:[self.color imageFromSelf] toView:self.colorIV stoppingIndicator:self.colorViewLoading];
    self.redTxtField.text = [NSString stringWithFormat:@"%.3g",[self.color.red floatValue]*255];
    self.greenTxtField.text = [NSString stringWithFormat:@"%.3g",[self.color.green floatValue]*255];
    self.blueTxtField.text = [NSString stringWithFormat:@"%.3g",[self.color.blue floatValue]*255];
    self.alphaTxtField.text = [NSString stringWithFormat:@"%.3g",[self.color.alpha floatValue]*255];
    
    self.redSlider.value = 255*self.color.red.floatValue;
    self.greenSlider.value = 255*self.color.green.floatValue;
    self.blueSlider.value = 255*self.color.blue.floatValue;
    self.alphaSlider.value = 255*self.color.alpha.floatValue;
}


- (void) loadImage:(UIImage *) image toView:(UIImageView *)imageView stoppingIndicator:(UIActivityIndicatorView *)indicator
{
    [indicator stopAnimating];
    imageView.image =image;
    [self.view setNeedsDisplay];
    
}

- (BOOL) textFieldIsValid:(UITextField *)textField
{
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * enteredNumber = [f numberFromString:textField.text];
    
    if(enteredNumber && [enteredNumber floatValue] <= 255 && [enteredNumber floatValue]>=0){
        
        if([textField isEqual:self.redTxtField]){
            self.color.red = [NSNumber numberWithFloat:enteredNumber.floatValue/255];
            self.redSlider.value = 255*self.color.red.floatValue;
        }
        else if([textField isEqual:self.greenTxtField]){
            self.color.green = [NSNumber numberWithFloat:enteredNumber.floatValue/255];
            self.greenSlider.value = 255*self.color.green.floatValue;
        }
        else if([textField isEqual:self.blueTxtField])
        {
            self.color.blue=[NSNumber numberWithFloat:enteredNumber.floatValue/255];
            self.blueSlider.value = 255*self.color.blue.floatValue;
        }
        else if([textField isEqual:self.alphaTxtField])
        {
            self.color.alpha=[NSNumber numberWithFloat:enteredNumber.floatValue/255];
            self.alphaSlider.value = 255*self.color.alpha.floatValue;
        }
        
        [self loadImage:[self.color imageFromSelf] toView:self.colorIV stoppingIndicator:self.colorViewLoading];
        
        return YES;
    }
    else{
        NSLog(@"Number out of bounds");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Number out of bounds"
                                                        message:@"Valid entries are numbers between 0 and 255"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if([self textFieldIsValid:textField]){
        [textField resignFirstResponder];
        return YES;
    }
    else{
        return NO;
    }
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if(self.keyboard != nil){
        self.keyboardYOffset = abs(self.keyboardYOffset);
        return YES;
    }
    else{
        NSLog(@"self.keyboard not set correctly");
        return NO;
    }
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    if([self textFieldIsValid:textField]){
        self.keyboardYOffset = -self.keyboardYOffset;
        [textField resignFirstResponder];
        return YES;
    }
    else{
        return NO;
    }
}


//Keyboard handler delegate method

-(void) keyboardSizeChanged:(CGSize)delta
{
    CGRect frame = self.view.frame;
    frame.origin.y -= delta.height-self.keyboardYOffset;
    self.view.frame = frame;
}
@end
