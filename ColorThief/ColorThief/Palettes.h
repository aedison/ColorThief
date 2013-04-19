//
//  Palettes.h
//  ColorThief
//
//  Created by Alex Edison on 4/19/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Colors;

@interface Palettes : NSManagedObject

@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSString * idKey;
@property (nonatomic, retain) NSString * paletteName;
@property (nonatomic, retain) NSSet *paletteColors;
@end

@interface Palettes (CoreDataGeneratedAccessors)

- (void)addPaletteColorsObject:(Colors *)value;
- (void)removePaletteColorsObject:(Colors *)value;
- (void)addPaletteColors:(NSSet *)values;
- (void)removePaletteColors:(NSSet *)values;

@end
