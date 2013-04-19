//
//  Colors.h
//  ColorThief
//
//  Created by Alex Edison on 4/19/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Palettes;

@interface Colors : NSManagedObject

@property (nonatomic, retain) NSNumber * blue;
@property (nonatomic, retain) NSNumber * green;
@property (nonatomic, retain) NSString * idKey;
@property (nonatomic, retain) NSNumber * red;
@property (nonatomic, retain) Palettes *sourcePalette;

@end
