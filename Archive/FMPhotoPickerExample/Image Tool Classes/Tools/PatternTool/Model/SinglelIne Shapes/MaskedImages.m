//
//  MaskedImages.m
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 08/01/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "MaskedImages.h"
#import "RandomObjects.h"
#import "NSNumber+RandomNumberGenrator.h"

@implementation MaskedImages

+(UIImage *)generateImage:(CGSize)imgSize effectId:(int)effectId{
    UIImage *img            =   [UIImage imageNamed:[NSString stringWithFormat:@"m%d.png",effectId]];
    float rndValue          =   [NSNumber randomFloatInLimit:0.98f endLimit:1.08f];
    //NSLog(@"before == %@",NSStringFromCGSize(img.size));
   // img                     =   [self imageByCroppingImage:img toSize:CGSizeMake(img.size.width *rndValue, img.size.height*rndValue)];
   // NSLog(@"after == %@",NSStringFromCGSize(img.size));

    CGSize imageSize        =   img.size;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imgSize.width/2, imgSize.height/2), YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //[img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    
    NSArray *colorsArr = [RandomObjects getRandomGradientColorArray];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef mountainGrad = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colorsArr, NULL);
    
    int randomValueForGradientType = 2;
    
    if(randomValueForGradientType % 2 == 0){
        CGContextDrawLinearGradient(ctx, mountainGrad, CGPointMake(0,0), CGPointMake(0, imageSize.height), 0);
    }
    else{
        CGPoint startPoint = CGPointMake(imageSize.width/2, imageSize.height/2);
        
        CGContextDrawRadialGradient(ctx, mountainGrad, startPoint, 0, startPoint, imageSize.width, 0);
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef maskRef = img.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([result CGImage], mask);
    CGImageRelease(mask);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:masked];
    
    CGImageRelease(masked);
    return maskedImage;
}

+(UIImage *)generateImage1:(CGSize)imgSize effectId:(int)effectId{
    UIImage *img            =   [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",effectId]];
    CGSize imageSize        =   img.size;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imgSize.width/2, imgSize.height/2), YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //[img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    
    NSArray *colorsArr = [RandomObjects getRandomGradientColorArray];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef mountainGrad = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colorsArr, NULL);
    
    CGContextDrawLinearGradient(ctx, mountainGrad, CGPointMake(0,0), CGPointMake(0, imageSize.height), 0);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef maskRef = img.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([result CGImage], mask);
    CGImageRelease(mask);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:masked];
    
    CGImageRelease(masked);
    return maskedImage;
}

@end
