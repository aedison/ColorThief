//
//  Palettes+Saved.m
//  ColorThief
//
//  Created by Alex Edison on 4/19/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import "Palettes+Saved.h"

@implementation Palettes (Saved)

- (NSArray *) paletteColorsSortedByKey:(NSString *)key{
    return [self.paletteColors sortedArrayUsingDescriptors:
     [NSArray arrayWithObject:
      [NSSortDescriptor sortDescriptorWithKey:key ascending:YES]]];
}


+ (Palettes *) newPaletteInContext:(NSManagedObjectContext *)managedObjectContext
                          withName:(NSString *)paletteName
                       andFileName:(NSString *)fileName
{
    Palettes* newPalette= [NSEntityDescription insertNewObjectForEntityForName:@"Palette"
                                                     inManagedObjectContext:managedObjectContext];
    newPalette.fileName=fileName;
    newPalette.paletteName=paletteName;
    newPalette.idKey=[newPalette.fileName stringByAppendingString:newPalette.paletteName];
    newPalette.paletteColors=nil;
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error during palette save: %@",error.description);
    }
    
    return newPalette;
}

@end
