//
//  CTColorEditorController.m
//  ColorThief
//
//  Created by Alex Edison on 4/25/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import "CTColorEditorController.h"
#import "Palettes+Saved.h"
#import "Colors+Saved.h"

@interface CTColorEditorController ()

@end

@implementation CTColorEditorController

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.paletteSourceLoading startAnimating];
    [self.colorViewLoading startAnimating];
    
    NSLog(@"File Name being read : %@", self.palette.fileName);
    
    NSURL* assetURL = [NSURL URLWithString:self.palette.fileName];
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        if (iref) {
            UIImage* image = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:[rep orientation]];
            [self loadImage:image toView:self.paletteSourceIV stoppingIndicator:self.paletteSourceLoading];
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
    
    [self loadImage:[self.color imageFromSelf] toView:self.colorIV stoppingIndicator:self.colorViewLoading];
    
    self.redTxtField.text = [NSString stringWithFormat:@"%@",self.color.red];
    self.greenTxtField.text = [NSString stringWithFormat:@"%@",self.color.green];
    self.blueTxtField.text = [NSString stringWithFormat:@"%@",self.color.blue];
    self.paletteName.text = self.palette.paletteName;
    
    self.redSlider.maximumValue=100;
    self.greenSlider.maximumValue=100;
    self.blueSlider.maximumValue=100;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)redSliderChanged:(UISlider *)sender
{
    self.redTxtField.text=[NSString stringWithFormat:@"%g", sender.value/100];
}

- (IBAction)greenSliderChagned:(UISlider *)sender {
}

- (IBAction)bludeSliderChanged:(UISlider *)sender {
}


- (void) loadImage:(UIImage *) image toView:(UIImageView *)imageView stoppingIndicator:(UIActivityIndicatorView *)indicator
{
    [indicator stopAnimating];
    imageView.image =image;
    [self.view setNeedsDisplay];
    
}
@end
