//
//  CTMediaBrowserVC.m
//  ColorThief
//
//  Created by Alex Edison on 4/30/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import "CTMediaBrowserVC.h"
#import "CTGrabberViewController.h"
#import "Palettes+Saved.h"
#import "CTAppDelegate.h"
#import "CTPaletteTVC.h"

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
        
        self.picker.delegate = self;
        
        self.picker.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        
        [self presentViewController:self.picker animated:YES completion:^{
            //[self viewDidDisappear:NO];
            //[self.picker viewWillAppear:NO];
        }];
        
        self.mediaWarning.hidden = YES;
    }
    
    // Otherwise, tell the user that the library is unavailable
    else
    {
        self.mediaWarning.hidden = NO;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.picker==nil){
        [self initializeBrowser];
    }
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"browserToPalettes"] && [segue.destinationViewController isKindOfClass:[CTPaletteTVC class]]){
        CTPaletteTVC* paletteList = segue.destinationViewController;
        paletteList.managedObjectContext = self.managedObjectContext;
        paletteList.fetchingFromImageFileName = [self.imageInfo[UIImagePickerControllerReferenceURL] absoluteString];
    }
    if([segue.identifier isEqualToString:@"BrowserNewToGrabber"]&&[segue.destinationViewController isKindOfClass:[CTGrabberViewController class]]){
        CTGrabberViewController* grabber = segue.destinationViewController;
        NSLog(@"Passing palette named -- %@ -- to grabber.",self.paletteToPass.paletteName);
        grabber.palette = self.paletteToPass;
    }
}


// Respond to button tap on alert view
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //Don't need to do anything special on cancel
    }
    else if(buttonIndex == 1 && [alertView.title isEqualToString:@"New Palette?"]){
        //load up a list of saved palettes
        
        [self performSegueWithIdentifier:@"browserToPalettes" sender:self];
        [self dismissViewControllerAnimated:YES completion:NULL];
        self.picker=nil;
        
    }
    else if(buttonIndex ==2 && [alertView.title isEqualToString:@"New Palette?"]){
        //throw an alert to ask for the new palette name
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Palette Name"
                                                        message:@"Name your new palette" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        UITextField *txtName = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
        txtName.text=@"";
        txtName.placeholder = @"Enter palette name";
        [txtName setBackgroundColor:[UIColor whiteColor]];
        [txtName setAutocorrectionType:UITextAutocorrectionTypeNo];
        [txtName becomeFirstResponder];
        
        [alert addSubview:txtName];
        [alert show];
    }
    else if (buttonIndex == 1 && [alertView.title isEqualToString:@"Palette Name"]) {
        
        if([[alertView.subviews lastObject] isKindOfClass:[UITextField class]]){
            
            UITextView* txtView=[alertView.subviews lastObject];
            NSString* paletteName=txtView.text;
            NSURL* imageURL =self.imageInfo[UIImagePickerControllerReferenceURL];
            
            
            self.paletteToPass=[Palettes newPaletteInContext:self.managedObjectContext withName:paletteName andFileName:imageURL];
            
            NSLog(@"Palette created with name -- %@",self.paletteToPass.paletteName);
            
            
            [self performSegueWithIdentifier:@"BrowserNewToGrabber" sender:self];
            [self dismissViewControllerAnimated:YES completion:NULL];
            self.picker=nil;

        }
    }
}


//Respond to a completed image selection
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imageInfo=info;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Palette?" message:@"Would you like to add to a saved palette, or make a new one?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Saved",@"New",nil];
    
    [alert show];
    
    
}

//Respond to a cancelled image selection
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popViewControllerAnimated:YES];
    
    

}

//Respond to the ImagePickers Navigation controller
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    //Recolor the nav bar to match the rest of the app
    navigationController.navigationBar.translucent = NO;
}

@end
