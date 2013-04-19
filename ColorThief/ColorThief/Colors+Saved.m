//
//  Colors+Saved.m
//  ColorThief
//
//  Created by Alex Edison on 4/19/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import "Colors+Saved.h"

@implementation Colors (Saved)

- (UIColor *) associatedUIColor
{
    return [UIColor colorWithRed:self.red.floatValue green:self.green.floatValue blue:self.green.floatValue alpha:self.alpha.floatValue];
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

+ (Colors *) newColorFromUIColor:(UIColor *)color
                       inContext:(NSManagedObjectContext *)managedObjectContext
{
    Colors* tempColor= [NSEntityDescription insertNewObjectForEntityForName:@"Color"
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
    }else {
        NSLog(@"Could not retrieve color data from UIColor");
    }
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error during color save: %@",error.description);
    }
    return tempColor;

}


@end
