//
//  CTViewController.m
//  ColorThief
//
//  Created by Alex Edison on 4/15/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import "CTRootVC.h"
#import "CTMediaBrowserVC.h"
#import "CameraViewController.h"

@interface CTRootVC ()

@end

@implementation CTRootVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (IBAction)unwindToCTRootVC:(UIStoryboardSegue *)unwindSegue
{
    if([unwindSegue.sourceViewController isKindOfClass:[CTMediaBrowserVC class]]){
//        CTMediaBrowserVC* sourceMBVC = unwindSegue.sourceViewController;
//        UINavigationController* navCon = self.navigationController;
//        [self.navigationController popViewControllerAnimated:YES];
//        self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
//        [sourceMBVC dismissViewControllerAnimated:NO completion:NULL];
        
        //Seeing if we can just get away with using a blank unwind segue
    }
}

//Need to implement rollbacks when you "back" from a page
- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

@end
