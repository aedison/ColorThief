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
    return [self initWithRect:CGRectMake(0, 0, 5, 5)];
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

- (UIImage *)getBoundedImageFromImage:(UIImage*)image
{
    //Set the bounds for the image, and get a new one cropped to the bounds.
    CGRect imageBounds = CGRectMake(self.fXPos, self.fYPos, self.fXSize, self.fYSize);
    UIImage *newImage;
    switch ([image imageOrientation]) {
        case UIImageOrientationUp:
            imageBounds = CGRectMake(self.fXPos, self.fYPos, self.fXSize, self.fYSize);
            break;
        case UIImageOrientationDown:
            imageBounds = CGRectMake(image.size.width - self.fXPos-self.fXSize, image.size.height-self.fYPos-self.fYSize, self.fXSize, self.fYSize);
            break;
        case UIImageOrientationLeft:
            imageBounds = CGRectMake(image.size.height - self.fYPos, self.fXPos - self.fYSize, self.fYSize, self.fXSize);
            break;
        case UIImageOrientationRight:
            imageBounds = CGRectMake(self.fYPos, image.size.width - self.fXPos - self.fXSize, self.fYSize, self.fXSize);
            break;
        case UIImageOrientationDownMirrored:
            newImage = [UIImage imageWithCGImage:[image CGImage] scale:1 orientation:UIImageOrientationDownMirrored];
            break;
        case UIImageOrientationUpMirrored:
            newImage = [UIImage imageWithCGImage:[image CGImage] scale:1 orientation:UIImageOrientationUpMirrored];
            break;
        case UIImageOrientationLeftMirrored:
            newImage = [UIImage imageWithCGImage:[image CGImage] scale:1 orientation:UIImageOrientationRightMirrored];
            break;
        case UIImageOrientationRightMirrored:
            newImage = [UIImage imageWithCGImage:[image CGImage] scale:1 orientation:UIImageOrientationLeftMirrored];
            break;
        default:
            newImage = [UIImage imageWithCGImage:[image CGImage] scale:1 orientation:UIImageOrientationUp];
            break;
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage],imageBounds);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return returnImage;
}


- (UIColor*)getColorFromImage:(UIImage *)image
{
    UIColor *color = nil;
    
    //Set the bounds for the image, and get a new one cropped to the bounds.
    CGRect imageBounds ;
    switch ([image imageOrientation]) {
        case UIImageOrientationUp:
            imageBounds = CGRectMake(self.fXPos, self.fYPos, self.fXSize, self.fYSize);
            break;
        case UIImageOrientationDown:
            imageBounds = CGRectMake(image.size.width - self.fXPos-self.fXSize, image.size.height-self.fYPos-self.fYSize, self.fXSize, self.fYSize);
            break;
        case UIImageOrientationLeft:
            imageBounds = CGRectMake(image.size.height - self.fYPos, self.fXPos - self.fYSize, self.fYSize, self.fXSize);
            break;
        case UIImageOrientationRight:
            imageBounds = CGRectMake(self.fYPos, image.size.width - self.fXPos - self.fXSize, self.fYSize, self.fXSize);
            break;
        case UIImageOrientationDownMirrored:
        case UIImageOrientationUpMirrored:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
        default:
            imageBounds = CGRectMake(self.fXPos, self.fYPos, self.fXSize, self.fYSize);
            break;
    }

    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage],imageBounds);
    
    
    //Set up the data for the bitmap context
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
