//
//  Palettes+Saved.m
//  ColorThief
//
//  Created by Alex Edison on 4/19/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
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
                       andFileName:(NSURL *)fileName
{
    NSString * file = [fileName absoluteString];
    NSString * name = paletteName;
    NSString *  key = [file stringByAppendingString:name];
    
    NSError* error=nil;
    
    
    //Need to write some validation methods here
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Palette"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idKey == %@",key];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"paletteName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [request setPredicate:predicate];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    Palettes* newPalette = nil;
    
    if([results count]==0){
        
        Palettes* newPalette= [NSEntityDescription insertNewObjectForEntityForName:@"Palette"
                                                            inManagedObjectContext:managedObjectContext];
        newPalette.fileName=[fileName absoluteString];
        newPalette.paletteName=paletteName;
        newPalette.idKey=[newPalette.fileName stringByAppendingString:newPalette.paletteName];
        newPalette.paletteColors=nil;
        
        error = nil;
        if (![managedObjectContext save:&error]) {
            NSLog(@"Error during palette save: %@",error.description);
        }
    }
    else if([results count]==1){
        newPalette=results[0];
    }
    else if(results == nil){
        NSLog(@"Error checking for existing entry in database -- %@",error);
    }
    else{
        NSLog(@"Something strange happened. The unique key is not unique");
        newPalette = nil;
    }
    
    return newPalette;
}

@end
