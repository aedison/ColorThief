//
//  CTColorEditorController.m
//  ColorThief
//
//  Created by Alex Edison on 4/25/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import "CTColorEditorController.h"
#import "Palettes+Saved.h"
#import "Colors+Saved.h"

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    self.alphaTxtField.text = [NSString stringWithFormat:@"%.2g",[self.color.alpha floatValue]];
    self.paletteName.text = self.palette.paletteName;
    
    self.redSlider.maximumValue=255;
    self.greenSlider.maximumValue=255;
    self.blueSlider.maximumValue=255;
    self.alphaSlider.maximumValue=100;
    
    self.redSlider.value = 255*self.color.red.floatValue;
    self.greenSlider.value = 255*self.color.green.floatValue;
    self.blueSlider.value = 255*self.color.blue.floatValue;
    self.alphaSlider.value = 100*self.color.alpha.floatValue;
    
    self.redTxtField.delegate=self;
    self.greenTxtField.delegate=self;
    self.blueTxtField.delegate=self;
    self.alphaTxtField.delegate=self;
    
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
    self.alphaTxtField.text=[NSString stringWithFormat:@"%.2g", sender.value/100];
    self.color.alpha = [NSNumber numberWithFloat: sender.value/100];
    [self loadImage:[self.color imageFromSelf] toView:self.colorIV stoppingIndicator:self.colorViewLoading];
}

- (IBAction)saveButton:(UIButton *)sender
{
    // Commit the change.
    NSError *error = nil;
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
    self.alphaTxtField.text = [NSString stringWithFormat:@"%.2g",[self.color.alpha floatValue]];
    
    self.redSlider.value = 255*self.color.red.floatValue;
    self.greenSlider.value = 255*self.color.green.floatValue;
    self.blueSlider.value = 255*self.color.blue.floatValue;
    self.alphaSlider.value = 100*self.color.alpha.floatValue;
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
    
    if(enteredNumber && [enteredNumber floatValue] <= 1 && [enteredNumber floatValue]>=0){
        
        if([textField isEqual:self.redTxtField]){
            self.color.red = enteredNumber;
            self.redSlider.value = 100*self.color.red.floatValue;
        }
        else if([textField isEqual:self.greenTxtField]){
            self.color.green = enteredNumber;
            self.greenSlider.value = 100*self.color.green.floatValue;
        }
        else if([textField isEqual:self.blueTxtField])
        {
            self.color.blue=enteredNumber;
            self.blueSlider.value = 100*self.color.blue.floatValue;
        }
        
        [self loadImage:[self.color imageFromSelf] toView:self.colorIV stoppingIndicator:self.colorViewLoading];
        
        return YES;
    }
    else{
        NSLog(@"Number out of bounds");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Number out of bounds"
                                                        message:@"Valid entries are numbers between 0 and 1"
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

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    if([self textFieldIsValid:textField]){
        [textField resignFirstResponder];
        return YES;
    }
    else{
        return NO;
    }
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.300000011920929;
    CGRect frame = self.view.frame;
    frame.origin.y -= kOFFSET_FOR_KEYBOARD;
    frame.size.height += kOFFSET_FOR_KEYBOARD;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.300000011920929;
    CGRect frame = self.view.frame;
    frame.origin.y += kOFFSET_FOR_KEYBOARD;
    frame.size.height -= kOFFSET_FOR_KEYBOARD;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}
@end
