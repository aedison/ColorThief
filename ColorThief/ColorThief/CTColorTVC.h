//
//  CTColorTVC.h
//  ColorThief
//
//  Created by Alex Edison on 4/22/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Palettes;

@interface CTColorTVC : UITableViewController

@property (nonatomic, retain) Palettes *palette;
@property (nonatomic, retain) NSMutableArray *colors;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
