//
//  Palettes+Saved.h
//  ColorThief
//
//  Created by Alex Edison on 4/19/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import "Palettes.h"

@interface Palettes (Saved)

- (NSArray *) paletteColorsSortedByKey:(NSString *)key;

+ (Palettes *) newPaletteInContext:(NSManagedObjectContext *)managedObjectContext
                          withName:(NSString *)paletteName
                       andFileName:(NSURL *)fileName;

@end
