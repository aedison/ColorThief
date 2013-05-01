//
//  CTMediaBrowserVC.m
//  ColorThief
//
//  Created by Alex Edison on 4/30/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import "CTMediaBrowserVC.h"
#import "Palettes+Saved.h"
#import "CTAppDelegate.h"

@interface CTMediaBrowserVC ()

@end

@implementation CTMediaBrowserVC

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
    // Ask the device if we can get the PhotoLibrary
    BOOL browser = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    if(browser)
    {
        // If we can, then make a picker for it.
        self.picker = [[UIImagePickerController alloc] init];
        
        // Since I'm not actually taking a picture, is a delegate function necessary?
        self.picker.delegate = self;
        
        self.picker.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:self.picker animated:YES completion:^{
            //[self viewDidDisappear:NO];
            //[self.picker viewWillAppear:NO];
        }];
        
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

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"Browser will disappear");
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"Browser did disappear");
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
            
            UITextView* txtView=[alertView.subviews lastObject];
            NSString* paletteName=txtView.text;
            NSURL* imageURL =self.imageInfo[UIImagePickerControllerReferenceURL];
            
            NSLog(@"Picked image with url: %@",imageURL);
            
            [Palettes newPaletteInContext:self.managedObjectContext withName:paletteName andFileName:imageURL];

            
            
            [self performSegueWithIdentifier:@"BrowserToGrabber" sender:self];
            [self dismissViewControllerAnimated:YES completion:NULL];
            self.picker=nil;

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
    
    self.picker.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:^{
        self.picker=nil;
    }];
    [self.navigationController popViewControllerAnimated:YES];
    

}

@end
