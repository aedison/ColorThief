//
//  CTKeyboardHandler.h
//  ColorThief
//
//  Thanks to http://stackoverflow.com/a/12402817 for this implementation of a keyboard tracker.
//
//  Created by Alex Edison on 5/6/13.
// 
//

#import <Foundation/Foundation.h>

@protocol CTKeyboardHandlerDelegate;

@interface CTKeyboardHandler : NSObject

- (id)init;

// Put 'weak' instead of 'assign' if you use ARC
@property(nonatomic, weak) id<CTKeyboardHandlerDelegate> delegate;
@property(nonatomic) CGRect frame;

@end
