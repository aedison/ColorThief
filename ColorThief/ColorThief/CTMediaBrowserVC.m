//
//  CTMediaBrowserVC.m
//  ColorThief
//
//  Created by Alex Edison on 4/30/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import "CTMediaBrowserVC.h"
#import "Palettes+Saved.h"

@interface CTMediaBrowserVC ()

@end

@implementation CTMediaBrowserVC

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initializeBrowser
{
    // Create a bool variable "camera" and call isSourceTypeAvailable to see if camera exists on device
    BOOL browser = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    // If there is a camera, then display the world throught the viewfinder
    if(browser)
    {
        self.picker = [[UIImagePickerController alloc] init];
        
        // Since I'm not actually taking a picture, is a delegate function necessary?
        self.picker.delegate = self;
        
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.picker animated:YES completion:nil];
        
        NSLog(@"Browser is available");
    }
    
    // Otherwise, do nothing.
    else
    {
        NSLog(@"No photo library available");
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.picker==nil){
        [self initializeBrowser];
    }
}

// Respond to button tap on alert view
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"Cancel Tapped.");
        [self imagePickerControllerDidCancel:self.picker];
    }
    else if (buttonIndex == 1) {
        NSLog(@"OK Tapped.");
        if([[alertView.subviews lastObject] isKindOfClass:[UITextField class]]){
            
            UIImage *viewImage =self.imageInfo[UIImagePickerControllerOriginalImage];
            UITextView* txtView=[alertView.subviews lastObject];
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            NSString* paletteName=txtView.text;
            
            // Request to save the image to camera roll
            [library writeImageToSavedPhotosAlbum:[viewImage CGImage] orientation:(ALAssetOrientation)[viewImage imageOrientation] completionBlock:^(NSURL *imageURL, NSError *error){
                if (error) {
                    NSLog(@"error -- %@",error);
                } else {
                    NSLog(@"image url %@", imageURL);
                    
                    [Palettes newPaletteInContext:self.managedObjectContext withName:paletteName andFileName:imageURL];
                }
            }];
            [self performSegueWithIdentifier:@"CameraToGrabber" sender:self];
            self.picker=nil;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imageInfo=info;
    
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

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.picker=nil;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
