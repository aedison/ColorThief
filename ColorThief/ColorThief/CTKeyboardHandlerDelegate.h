//
//  CTKeyboardHandlerDelegate.h
//  ColorThief
//
//  Created by Alex Edison on 5/6/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CTKeyboardHandlerDelegate <NSObject>

- (void)keyboardSizeChanged:(CGSize)delta;

@end
