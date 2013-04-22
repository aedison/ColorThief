//
//  CameraViewController.m
//  ColorThief
//
//  Created by Kevin Tabb on 4/16/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import "CameraViewController.h"

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
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

@end
