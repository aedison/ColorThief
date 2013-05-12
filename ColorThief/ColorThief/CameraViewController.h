//
//  CameraViewController.h
//  ColorThief
//
//  Created by Kevin Tabb on 4/16/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class Palettes;

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSDictionary* imageInfo;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) Palettes *paletteToPass;
@property (weak, nonatomic) IBOutlet UILabel *cameraWarning;

@end
