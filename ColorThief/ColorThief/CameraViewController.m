//
//  CameraViewController.m
//  ColorThief
//
//  Created by Kevin Tabb on 4/16/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import "CameraViewController.h"
#import "Palettes+Saved.h"
#import "CTAppDelegate.h"

@interface CameraViewController () 

@end

@implementation CameraViewController

- (NSManagedObjectContext *) managedObjectContext
{
    if(_managedObjectContext==nil){
        CTAppDelegate* appDelegate=[[UIApplication sharedApplication] delegate];
        _managedObjectContext = [appDelegate managedObjectContext];
    }
    return _managedObjectContext;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void) initializeCamera
{
    // Create a bool variable "camera" and call isSourceTypeAvailable to see if camera exists on device
    BOOL camera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    // If there is a camera, then display it
    if(camera)
    {
        self.cameraWarning.hidden=YES;
        
        self.picker = [[UIImagePickerController alloc] init];
        
        self.picker.delegate = self;
        
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:self.picker animated:YES completion:nil];
        
        
    }
    
    // Otherwise, show the warning on black background
    else
    {
        self.cameraWarning.hidden=NO;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.picker==nil){
       [self initializeCamera]; 
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
        
        //Need to test this with camera to see if it returns to an active camera/retake option
        [alertView resignFirstResponder];
        //[self imagePickerControllerDidCancel:self.picker];
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
