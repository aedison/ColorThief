//
//  CTColorEditorController.m
//  ColorThief
//
//  View controller to handle the editing of a single color from a palette.
//  Loads the image for the palette and the color into two UIImageViews, and
//  presents a set of sliders and UITextFields to edit the color.
//
//  Created by Alex Edison on 4/25/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import "CTColorEditorController.h"
#import "Palettes+Saved.h"
#import "Colors+Saved.h"
#import "CTKeyboardHandler.h"


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
    
    //Ask the AssetLibrary for the image that we want to load
    NSURL* assetURL = [NSURL URLWithString:self.palette.fileName];
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        if (iref) {
            UIImage* image = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
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
    
    //Load the color to be presented
    [self loadImage:[self.color imageFromSelf] toView:self.colorIV stoppingIndicator:self.colorViewLoading];
    
    //Setup the sliders and text fields with appropriate values for the color
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
    
    self.colorHex.text=[self.color hexString];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //Our view should always show the bottom text field, even when
    //the keyboard is showing, so use the BlueTextFields location
    //as an addtional offset for the view when showing the keyboard.
    self.keyboardYOffset = self.blueTxtField.frame.origin.y;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// When a slider changes, update the associated text field and the color displays
- (IBAction)redSliderChanged:(UISlider *)sender
{
    self.redTxtField.text=[NSString stringWithFormat:@"%.3g", sender.value];
    self.color.red = [NSNumber numberWithFloat: sender.value/255];
    self.colorHex.text=[self.color hexString];
    [self loadImage:[self.color imageFromSelf] toView:self.colorIV stoppingIndicator:self.colorViewLoading];
}

- (IBAction)greenSliderChagned:(UISlider *)sender
{
    self.greenTxtField.text=[NSString stringWithFormat:@"%.3g", sender.value];
    self.color.green = [NSNumber numberWithFloat: sender.value/255];
    self.colorHex.text=[self.color hexString];
    [self loadImage:[self.color imageFromSelf] toView:self.colorIV stoppingIndicator:self.colorViewLoading];
}

- (IBAction)blueSliderChanged:(UISlider *)sender
{
    self.blueTxtField.text=[NSString stringWithFormat:@"%.3g", sender.value];
    self.color.blue = [NSNumber numberWithFloat: sender.value/255];
    self.colorHex.text=[self.color hexString];
    [self loadImage:[self.color imageFromSelf] toView:self.colorIV stoppingIndicator:self.colorViewLoading];
}

- (IBAction)alphaSliderChanged:(UISlider *)sender
{
    self.alphaTxtField.text=[NSString stringWithFormat:@"%.3g", sender.value];
    self.color.alpha = [NSNumber numberWithFloat: sender.value/255];
    self.colorHex.text=[self.color hexString];
    [self loadImage:[self.color imageFromSelf] toView:self.colorIV stoppingIndicator:self.colorViewLoading];
}



// Commit the change and go back to the previous VC
- (IBAction)saveButton:(UIButton *)sender
{
    NSError *error = nil;
    self.color.idKey=[[self.color hexString] stringByAppendingString:self.palette.paletteName];
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Could not save color -- %@",error);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


// Rollback any changes and reset the sliders and presented information
- (IBAction)resetButton:(UIButton *)sender
{
    [self.managedObjectContext rollback];
    self.colorHex.text=[self.color hexString];
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




//Helper function to load a given image into a UIImageView and stop the spinner
- (void) loadImage:(UIImage *) image toView:(UIImageView *)imageView stoppingIndicator:(UIActivityIndicatorView *)indicator
{
    [indicator stopAnimating];
    imageView.image =image;
    [self.view setNeedsDisplay];
    
}

//Helper function to verify the contents of a provided text field
- (BOOL) textFieldIsValid:(UITextField *)textField
{
    //Verify that the text inside the given UITextField is within allowable bounds
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * enteredNumber = [f numberFromString:textField.text];
    
    if(enteredNumber && [enteredNumber floatValue] <= 255 && [enteredNumber floatValue]>=0){
        //If the entered value is within our bounds, update everything appropriately
        //and return YES.
        
        
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
        self.colorHex.text=[self.color hexString];
        [self loadImage:[self.color imageFromSelf] toView:self.colorIV stoppingIndicator:self.colorViewLoading];
        
        return YES;
    }
    else{
        //Otherwise throw an alert telling the user that the text field is invalid
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Number out of bounds"
                                                        message:@"Valid entries are numbers between 0 and 255"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}


//Delegate methods for UITextField.
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    //Verify that the field is valid, and allow returning if it is.
    if([self textFieldIsValid:textField]){
        [textField resignFirstResponder];
        self.navigationItem.hidesBackButton = NO;
        return YES;
    }
    else{
        return NO;
    }
}

//Setup the textField to start editing.
//The keyboard offset should always be positive before it appears,
//since we want to move the view up.
//We also want to hide the back button to prevent people from exiting with an unverified value.
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    self.keyboardYOffset = abs(self.keyboardYOffset);
    self.navigationItem.hidesBackButton = YES;
    return YES;
}

//Similar to the shouldReturn method, except this is where
//we tell set the keyboard offset to be negative, so the view slides
//back to the right place.
-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    if([self textFieldIsValid:textField]){
        self.keyboardYOffset = -self.keyboardYOffset;
        self.navigationItem.hidesBackButton = NO;
        [textField resignFirstResponder];
        return YES;
    }
    else{
        return NO;
    }
}


//Keyboard handler delegate method
//Slide the view so that the bottom textField is still visible above the keyboard.
-(void) keyboardSizeChanged:(CGSize)delta
{
    CGRect frame = self.view.frame;
    frame.origin.y -= delta.height-self.keyboardYOffset;
    self.view.frame = frame;
}
@end
