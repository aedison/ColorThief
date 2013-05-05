//
//  CTGrabberViewController.m
//  ColorThief
//
//  Created by Alex Edison on 4/22/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import "CTGrabberViewController.h"

@interface CTGrabberViewController ()

// This property will denote whether we are in the "picture view" state or the "color select" state
// picture view = 0, color select = 1
@property (nonatomic) int iState;

@end

@implementation CTGrabberViewController

@synthesize iState = _iState;

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
    
    // Start out in picture view state
    _iState = 0;
    
    
    // Set sample background image
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"iPhoneSamplePic.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    // add gesture recognizers
    // add pinch recognizer
    [self.view addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.view action:@selector(pinch:)]];
    // add pan recognizer
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.view action:@selector(pan:)]];
    // add tap recognizer
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(tap:)]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
