//
//  CTPaletteTVC.h
//  ColorThief
//
//  Created by Alex Edison on 4/19/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface CTPaletteTVC : UITableViewController

@property (nonatomic, retain) NSMutableArray *palettes;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSString *fetchingFromImageFileName;

@end
