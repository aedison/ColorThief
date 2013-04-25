//
//  CTColorEditorController.m
//  ColorThief
//
//  Created by Alex Edison on 4/25/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import "CTColorEditorController.h"

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)redSliderChanged:(UISlider *)sender {
}

- (IBAction)greenSliderChagned:(UISlider *)sender {
}

- (IBAction)bludeSliderChanged:(UISlider *)sender {
}
@end
