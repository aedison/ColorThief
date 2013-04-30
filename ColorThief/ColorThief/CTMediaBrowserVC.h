//
//  CTMediaBrowserVC.h
//  ColorThief
//
//  Created by Alex Edison on 4/30/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface CTMediaBrowserVC : UIViewController <UIImagePickerControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSDictionary* imageInfo;
@property (nonatomic, strong) UIImagePickerController *picker;

@end
