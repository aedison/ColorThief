//
//  CameraViewController.m
//  ColorThief
//
//  Created by Kevin Tabb on 4/16/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import "CameraViewController.h"
#import "Palettes+Saved.h"

@interface CameraViewController () <UIImagePickerControllerDelegate>

@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Create a bool variable "camera" and call isSourceTypeAvailable to see if camera exists on device
    BOOL camera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    // If there is a camera, then display the world throught the viewfinder
    if(camera)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        // Since I'm not actually taking a picture, is a delegate function necessary?
        picker.delegate = self;
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:NO completion:nil];
        
        NSLog(@"Camera is available");
    }
    
    // Otherwise, do nothing.
    else
    {
        NSLog(@"No camera available");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New palette name" message:@"/n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok",nil];
        UITextField *txtName = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
        txtName.text=@"";
        txtName.placeholder = @"Enter palette name";
        [txtName setBackgroundColor:[UIColor whiteColor]];
        [txtName setAutocorrectionType:UITextAutocorrectionTypeNo];
        [txtName becomeFirstResponder];
         
        [alert addSubview:txtName];
        [alert show];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Respond to button tap on alert view
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"Cancel Tapped.");
    }
    else if (buttonIndex == 1) {
        NSLog(@"OK Tapped.");
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *viewImage =info[UIImagePickerControllerOriginalImage];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    // Request to save the image to camera roll
    [library writeImageToSavedPhotosAlbum:[viewImage CGImage] orientation:(ALAssetOrientation)[viewImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        if (error) {
            NSLog(@"error");
        } else {
            NSLog(@"url %@", assetURL);
        }
    }];
    //[Palettes newPaletteInContext:<#(NSManagedObjectContext *)#> withName:<#(NSString *)#> andFileName:<#(NSString *)#>
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // Add code here for alert
    // Alert will ask for an image name
    /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter a name for your palette" message:@"More info..." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok",nil];
    [alert show]; */
    
}


@end
