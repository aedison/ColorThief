//
//  CTGrabberViewController.m
//  ColorThief
//
//  Created by Alex Edison on 4/22/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import "CTGrabberViewController.h"
#import "colorSquare.h"

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
    

    // ++++++++++++++++++++++++++++++++
    
    // Start out in picture view state
    //////////////-----------
    self.colorView.iState = 0;
    self.colorView.fScale = 1;
    
    // Set sample background image
    UIGraphicsBeginImageContext(self.colorView.frame.size);
    [[UIImage imageNamed:@"iPhoneSamplePic.jpg"] drawInRect:self.colorView.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.colorView.backgroundColor = [UIColor colorWithPatternImage:image];
    
    // TESTING COLOR SQUARE
    // ++++++++++++++++++++++++++++++++
    
    // init at point (50, 50) with size (10, 10)
    [self.colorSquare init:50 :50 :10 :10];
    
    // Test "getColorCode"
    UIColor *myTestColor = [self.colorSquare getColorCode:self.colorView];
    
    NSLog(@"UIColor is set\n");

    
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
