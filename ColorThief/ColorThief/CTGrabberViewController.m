//
//  CTGrabberViewController.m
//  ColorThief
//
//  Created by Alex Edison on 4/22/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import "CTGrabberViewController.h"
#import "colorSquare.h"
#import "ColorView.h"
#import "Palettes+Saved.h"

@interface CTGrabberViewController ()
@property (nonatomic, strong) colorSquare *colorSquare;

@end

@implementation CTGrabberViewController


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
    
    //Ask the AssetLibrary for the image that we want to load
    NSURL* assetURL = [NSURL URLWithString:self.palette.fileName];
    NSLog(@"Loading from palette name -- %@", self.palette.paletteName);
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        if (iref) {
            self.image = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
            self.colorView.backgroundColor = [UIColor colorWithPatternImage:self.image];
            [self.colorView setNeedsDisplay];
            // TESTING COLOR SQUARE
            // ++++++++++++++++++++++++++++++++
            if (!self.colorSquare)
            {
                self.colorSquare = [[colorSquare alloc] initWithRect:CGRectMake(50, 50, 10, 10)];
            }
            
            UIColor *colorSquareColor = [self.colorSquare getColorFromImage:self.image];
            NSLog(@"Color grabbed: %@",colorSquareColor.description);
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

    // ++++++++++++++++++++++++++++++++
    
    // Start out in picture view state
    //////////////-----------
    self.colorView.iState = 0;
    self.colorView.fScale = 1;
    
    // Set sample background image
//    UIGraphicsBeginImageContext(self.colorView.frame.size);
//    [[UIImage imageNamed:@"iPhoneSamplePic.jpg"] drawInRect:self.colorView.bounds];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    self.colorView.backgroundColor = [UIColor colorWithPatternImage:image];
    

    
    
    /* 
    // Test "getColorCode"
    UIColor *myTestColor = [self.colorSquare getColorCode:self.colorView];
     */

    
    // add gesture recognizers
    // add pinch recognizer
    [self.colorView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.colorView action:@selector(pinch:)]];
    // add pan recognizer
    [self.colorView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.colorView action:@selector(pan:)]];
    // add tap recognizer
    [self.colorView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.colorView action:@selector(tap:)]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
    NSLog(@"Grabber disappeared");
}

- (IBAction)modeSwitch:(id)sender
{
    if (self.colorView.iState == 0)
    {
        self.colorView.iState = 1;
    }
    else
    {
        self.colorView.iState = 0;
    }
}
@end
