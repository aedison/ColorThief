//
//  Colors+Saved.m
//  ColorThief
//
//  Created by Alex Edison on 4/19/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import "Colors+Saved.h"
#import "Palettes.h"

@implementation Colors (Saved)

- (UIColor *) associatedUIColor
{
    return [UIColor colorWithRed:self.red.floatValue green:self.green.floatValue blue:self.blue.floatValue alpha:self.alpha.floatValue];
}

- (UIImage *) imageFromSelf
{
    
    UIImage *img = nil;
    CGSize size= CGSizeMake(50., 50.);
    UIColor* color = [self associatedUIColor];
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size,NO,0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (NSString *) hexString
{
    NSString *stringForRed,*stringForGreen,*stringForBlue;
    stringForRed = [NSString stringWithFormat:@"%X",[NSNumber numberWithFloat:self.red.floatValue*255].integerValue];
    stringForGreen = [NSString stringWithFormat:@"%X",[NSNumber numberWithFloat:self.green.floatValue*255].integerValue];
    stringForBlue = [NSString stringWithFormat:@"%X",[NSNumber numberWithFloat:self.blue.floatValue*255].integerValue];
    
    if([stringForRed length]==1){
        stringForRed = [@"0" stringByAppendingString:stringForRed];
    }
    if([stringForGreen length]==1){
        stringForGreen = [@"0" stringByAppendingString:stringForGreen];
    }
    if([stringForBlue length]==1){
        stringForBlue = [@"0" stringByAppendingString:stringForBlue];
    }
    NSString* colorDescription=[NSString stringWithFormat:@"%@%@%@",stringForRed,stringForGreen,stringForBlue];
    return colorDescription;
}

+ (NSString *)hexStringFromUIColor:(UIColor *)color
{
    CGFloat tempRed=0;
    CGFloat tempGreen=0;
    CGFloat tempBlue=0;
    CGFloat tempAlpha=0;
    if(![color getRed:&tempRed green:&tempGreen blue:&tempBlue alpha:&tempAlpha]){
        NSLog(@"Could not retrieve color data from UIColor");
    }
    NSString *stringForRed,*stringForGreen,*stringForBlue;
    stringForRed = [NSString stringWithFormat:@"%X",[NSNumber numberWithFloat:tempRed*255].integerValue];
    stringForGreen = [NSString stringWithFormat:@"%X",[NSNumber numberWithFloat:tempGreen*255].integerValue];
    stringForBlue = [NSString stringWithFormat:@"%X",[NSNumber numberWithFloat:tempBlue*255].integerValue];
    
    if([stringForRed length]==1){
        stringForRed = [@"0" stringByAppendingString:stringForRed];
    }
    if([stringForGreen length]==1){
        stringForGreen = [@"0" stringByAppendingString:stringForGreen];
    }
    if([stringForBlue length]==1){
        stringForBlue = [@"0" stringByAppendingString:stringForBlue];
    }
    NSString* colorDescription=[NSString stringWithFormat:@"%@%@%@",stringForRed,stringForGreen,stringForBlue];
    return colorDescription;
}

+ (Colors *) newColorFromUIColor:(UIColor *)color
                       inContext:(NSManagedObjectContext *)managedObjectContext
                       inPalette:(Palettes *)palette
{
    Colors* tempColor = nil;
    
    NSString* pName = nil;
    NSString* colorHex = [Colors hexStringFromUIColor:color];
    NSString *key = nil;
    
    pName = palette.paletteName;
    key = [NSString stringWithFormat:@"%@%@",colorHex,pName];

    NSError *error = nil;
    
    //Need to write some validation methods here
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Color"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idKey == %@",key];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"red" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [request setPredicate:predicate];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    //Need to write some validation methods
    if([results count]==0){
        tempColor= [NSEntityDescription insertNewObjectForEntityForName:@"Color"
                                                         inManagedObjectContext:managedObjectContext];
        CGFloat tempRed=0;
        CGFloat tempGreen=0;
        CGFloat tempBlue=0;
        CGFloat tempAlpha=0;
        if([color getRed:&tempRed green:&tempGreen blue:&tempBlue alpha:&tempAlpha]){
            tempColor.red=[NSNumber numberWithFloat:tempRed];
            tempColor.green = [NSNumber numberWithFloat:tempGreen];
            tempColor.blue = [NSNumber numberWithFloat:tempBlue];
            tempColor.alpha = [NSNumber numberWithFloat:tempAlpha];
        }
        else{
            NSLog(@"Could not retrieve color data from UIColor");
        }
        tempColor.sourcePalette = palette;
        tempColor.idKey = key;
        [palette addPaletteColorsObject:tempColor];
        if (![managedObjectContext save:&error]) {
            NSLog(@"Error during color save: %@",error.description);
        }
        return tempColor;
    }
    else if ([results count]==1){
        tempColor=results[0];
        return tempColor;
    }
    else{
        NSLog(@"Color fetch returned incorrect number of entries");
        return nil;
    }
}


@end
