//
//  colorSquare.m
//  ColorThief
//
//  Created by Kevin Tabb on 5/4/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import "colorSquare.h"

@implementation colorSquare

@synthesize fXPos = _fXPos;
@synthesize fYPos = _fYPos;
@synthesize fXSize = _fXSize;
@synthesize fYSize = _fYSize;

- (void) setFXSize:(float)fXSize
{
    if(fXSize > 50){
        _fXSize = 50;
    }
    else if(fXSize<=0){
        _fXSize = 1;
    }
    else{
        _fXSize = fXSize;
    }
}

- (void) setFYSize:(float)fYSize
{
    if(fYSize > 50){
        _fYSize = 50;
    }
    else if(fYSize<=0){
        _fYSize = 1;
    }
    else{
        _fYSize = fYSize;
    }
}

- (colorSquare *) init
{
    return [self initWithRect:CGRectMake(0, 0, 1, 1)];
}

- (colorSquare *) initWithRect:(CGRect) rect
{
    self = [super init];
    self.fXPos = rect.origin.x;
    self.fYPos = rect.origin.y;
    self.fXSize = rect.size.width;
    self.fYSize = rect.size.height;
    return self;
}



- (UIColor*)getColorFromImage:(UIImage *)image
{
    UIColor *color = nil;
    
    //Set the bounds for the image, and get a new one cropped to the bounds.
    CGRect imageBounds = CGRectMake(self.fXPos, self.fYPos, self.fXSize, self.fYSize);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage],imageBounds);
    
    
    //Get data information from the new CGImage
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = imageBounds.size.width*bytesPerPixel;
    NSUInteger bitsPerComponent = 8;
    NSUInteger bytesPerComponent = bitsPerComponent/8;
    
    //Make an array to hold the raw pixel data
    unsigned char *rawData = (unsigned char*) malloc(imageBounds.size.height*bytesPerRow*sizeof(unsigned char));

    //Draw the new image onto a BitMap backed by rawData, then release the context since
    //we only care about the backing data array
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rawData, imageBounds.size.width, imageBounds.size.height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, imageBounds.size.width, imageBounds.size.height), imageRef);
    CGContextRelease(context);
    CGImageRelease(imageRef);

    
    //rawData now contains all of the pixel data, so start iterating over it to get the info we want.
    float pixelCount = imageBounds.size.height * imageBounds.size.width;
    float normailizer = pow(2,bitsPerComponent)-1;
    float redTotal = 0;
    float greenTotal = 0;
    float blueTotal = 0;
    //float alphaTotal=0;
    
    for(int j=0;j<imageBounds.size.height*bytesPerRow;j+=bytesPerRow){
        for(int i = 0; i<bytesPerRow;i+=bytesPerPixel){
            redTotal+=(rawData[i+j]*1.0);
            greenTotal+=(rawData[j+i+bytesPerComponent]*1.0);
            blueTotal+=(rawData[j+i+2*bytesPerComponent]*1.0);
            //alphaTotal+=(rawData[j+i+3*bytesPerComponent]*1.0);
        }
    }
    
    float redAverage = redTotal/(pixelCount*normailizer);
    float greenAverage = greenTotal/(pixelCount*normailizer);
    float blueAverage = blueTotal/(pixelCount*normailizer);
    //float alphaAverage = alphaTotal/(pixelCount*normailizer);
    
    color = [UIColor colorWithRed:redAverage green:greenAverage blue:blueAverage alpha:1];

    free(rawData);
    
    return color;
}

@end
