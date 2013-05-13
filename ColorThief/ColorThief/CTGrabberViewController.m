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
#import "Colors+Saved.h"
#import "CTAppDelegate.h"
#import "CTDrawingView.h"


@interface CTGrabberViewController ()

@end

@implementation CTGrabberViewController

- (NSManagedObjectContext *) moc
{
    if(_moc==nil){
        CTAppDelegate* appDelegate=[[UIApplication sharedApplication] delegate];
        _moc = [appDelegate managedObjectContext];
    }
    return _moc;
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
    
    // Gestures
    self.gPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self.colorView action:@selector(pinch:)];
    self.gPan = [[UIPanGestureRecognizer alloc] initWithTarget:self.colorView action:@selector(pan:)];
    self.gTap = [[UITapGestureRecognizer alloc] initWithTarget:self.colorView action:@selector(tap:)];
    
    // Set properties of colorView
    [super viewDidLoad];
    //other code...
    self.colorView.delegate = self;
    self.colorView.clipsToBounds = YES;
    self.colorView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.colorView.minimumZoomScale = .1;
    self.colorView.maximumZoomScale = 10.0;
    self.colorView.overlay = self.overlay;
    self.colorView.content = self.imageView;
    self.overlay.overlayedView = self.imageView;
    
    //Ask the AssetLibrary for the image that we want to load
    NSURL* assetURL = [NSURL URLWithString:self.palette.fileName];
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        if (iref) {
            self.image = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
            self.colorView.image = self.image;
            self.imageView.image = self.image;
            self.overlay.image = self.image;
            self.colorView.contentSize = self.image.size;
            self.colorView.zoomScale = self.view.frame.size.width/self.image.size.width;
            [self.colorView setNeedsDisplay];
            // TESTING COLOR SQUARE
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
    self.colorView.bDrawing = FALSE;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)scrollViewDidZoom:(ColorView *)colorView
{
//    NSLog(@"zoom factor: %f", colorView.zoomScale);
//    UIPinchGestureRecognizer *test = colorView.pinchGestureRecognizer;
//    
//    UIView *piece = test.view;
//    CGPoint locationInView = [test locationInView:piece];
//    CGPoint locationInSuperview = [test locationInView:piece.superview];
//    
//    NSLog(@"locationInView: %@ locationInSuperView: %@", NSStringFromCGPoint(locationInView), NSStringFromCGPoint(locationInSuperview));

    //NSLog(@"Position of imageView %@",NSStringFromCGPoint(self.imageView.frame.origin));
    
    self.overlay.scale = colorView.zoomScale;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (IBAction)modeSwitch:(id)sender
{
    if (self.colorView.iState == 1)
    {
        self.colorView.iState = 0;
        [sender setTitle:@"To Color Grab Mode" forState:UIControlStateNormal];
        [self.colorView removeGestureRecognizer:self.gPinch];
        [self.colorView removeGestureRecognizer:self.gPan];
        [self.colorView removeGestureRecognizer:self.gTap];
    }
    else
    {
        self.colorView.iState = 1;
        [sender setTitle:@"To Pan/Zoom Mode" forState:UIControlStateNormal];
        // add gesture recognizers
        // add pinch recognizer

        [self.colorView addGestureRecognizer:self.gPinch];
        [self.colorView addGestureRecognizer:self.gPan];
        [self.colorView addGestureRecognizer:self.gTap];
    }
}

- (IBAction)deleteSquare:(id)sender
{
    self.overlay.colorSquare = NULL;
    [self.colorView setNeedsDisplay];
}

- (IBAction)saveColor:(UIButton *)sender {
    if(self.overlay.colorSquare){
        [Colors newColorFromUIColor:[self.overlay.colorSquare getColorFromImage:self.colorView.image] inContext:self.moc inPalette:self.palette];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Box" message:@"You can only save once you have drawn a color square" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)homeButtom:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
