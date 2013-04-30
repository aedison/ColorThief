//
//  Colors+Saved.h
//  ColorThief
//
//  Created by Alex Edison on 4/19/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import "Colors.h"

@interface Colors (Saved)

- (UIColor *) associatedUIColor;
- (UIImage *) imageFromSelf;
+ (Colors *) newColorFromUIColor:(UIColor *)color
                   inContext:(NSManagedObjectContext *)managedObjectContext;

@end
