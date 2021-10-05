//
//  SingleLineSpikes.m
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 05/12/15.
//  Copyright © 2015 Kanwarpal Singh. All rights reserved.
//

#import "SingleLineSpikes.h"
#import <UIKit/UIKit.h>
#import "NSNumber+RandomNumberGenrator.h"
#import "RandomObjects.h"
#import "UIColor+HexColors.h"
#import "NSString+RandomStringGenrator.h"
#import "UIImage+Utility.h"

@implementation SingleLineSpikes

//****************************************** create spikes shapes at boundaries ***************************************//

#pragma mark spikes shapes

+(UIImage *)generateImageAsWindow:(CGSize)imageSize effectId:(NSUInteger)effectId{
    //36
    int rndSquarePosition = [NSNumber randomIntInLimit:1 endLimit:10];
    
    UIImage *img;
    
    if(rndSquarePosition % 2 == 0){
        int isWindowRnd = [NSNumber randomIntInLimit:1 endLimit:10];
        
        if(isWindowRnd % 2 == 0){
            img = [self createVerticalSpikes:imageSize asWindow:NO];
        }
        else{
            img = [self createVerticalSpikes:imageSize asWindow:YES];
        }
    }
    else{
        int isWindowRnd = [NSNumber randomIntInLimit:1 endLimit:10];
        
        if(isWindowRnd % 2 == 0){
            img = [self createHorizontalSpikes:imageSize asWindow:NO];
        }
        else{
            img = [self createHorizontalSpikes:imageSize asWindow:YES];
        }
    }
    
    return img;
}

+(UIImage *)generateImage:(CGSize)imageSize effectId:(NSUInteger)effectId{
    //14
    int rndSquarePosition = [NSNumber randomIntInLimit:1 endLimit:10];
    
    UIImage *img;
    
    if(rndSquarePosition % 2 == 0){
        int isWindowRnd = [NSNumber randomIntInLimit:1 endLimit:10];
        
        if(isWindowRnd % 2 == 0){
            img = [self createVerticalSpikes:imageSize asWindow:NO];
        }
        else{
            img = [self createVerticalSpikes:imageSize asWindow:YES];
        }
    }
    else{
        int isWindowRnd = [NSNumber randomIntInLimit:1 endLimit:10];
        
        if(isWindowRnd % 2 == 0){
            img = [self createHorizontalSpikes:imageSize asWindow:NO];
        }
        else{
            img = [self createHorizontalSpikes:imageSize asWindow:YES];
        }
    }
    
    return img;
}

+(UIImage *)createVerticalSpikes:(CGSize)imageSize asWindow:(BOOL)asWindow{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
   // int rndValueForClearOrGradientShape = [NSNumber randomIntInLimit:0 endLimit:10];
    
    if(asWindow){
        CGContextSetRGBFillColor(ctx, (254.0/255.0), (254.0/255.0), 254.0/255.0, 1.0);
        CGContextFillRect(ctx, CGRectMake(0, 0, imageSize.width, imageSize.height));
    }
    else{
        CGContextFillRect(ctx, CGRectMake(0, 0, imageSize.width, imageSize.height));
        NSArray *colorsArr = [RandomObjects getRandomGradientColorArray];
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef mountainGrad = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colorsArr, NULL);
        
        //CGContextClip(ctx);
        
        int randomValueForGradientType = 2;
        
        if(randomValueForGradientType % 2 == 0){
            CGContextDrawLinearGradient(ctx, mountainGrad, CGPointMake(0,0), CGPointMake(0, imageSize.height), 0);
        }
        else{
            CGPoint startPoint = CGPointMake(imageSize.width/2, imageSize.height/2);
            
            CGContextDrawRadialGradient(ctx, mountainGrad, startPoint, 0, startPoint, imageSize.width, 0);
        }
    }
    
    int rndValueForCurveCount = [NSNumber randomIntInLimit:10 endLimit:15];
    
    int height = imageSize.height;
    int subheight = height/rndValueForCurveCount;
    
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float rndStartPoint = [NSNumber randomFloatInLimit:imageSize.width*(0.10) endLimit:imageSize.width*(0.15)];
    
    float tempLeftXPt = rndStartPoint ;
    float tempRightXPt = imageSize.height - rndStartPoint;
    
    int rndValueCurveWidth = [NSNumber randomIntInLimit:5 endLimit:rndStartPoint/2];
    
    CGPathMoveToPoint(curvs, nil, tempLeftXPt + (rndValueCurveWidth*2), -subheight);
    
    float lastYPt = 0;
    
    for(int i = 0;  i < rndValueForCurveCount+1; i++){
        float tempXPt = 0;
        
        if(i%2 == 0 ){
            tempXPt = tempLeftXPt - rndValueCurveWidth;
        }
        else{
            tempXPt = tempLeftXPt + rndValueCurveWidth;
        }
        
        CGPathAddLineToPoint(curvs, nil, tempXPt, lastYPt + subheight);
        
        lastYPt = lastYPt + subheight;
    }
    
    CGPathAddLineToPoint(curvs, nil, tempLeftXPt, lastYPt + rndValueCurveWidth);
    CGPathAddLineToPoint(curvs, nil, -rndValueCurveWidth, lastYPt + rndValueCurveWidth);
    CGPathAddLineToPoint(curvs, nil, -rndValueCurveWidth, -rndValueCurveWidth);
    
    lastYPt = 0;
    
    int rndValueCurveStart = [NSNumber randomIntInLimit:1 endLimit:10];
    
    CGPathMoveToPoint(curvs, nil, tempRightXPt + (rndValueCurveWidth*2), -subheight);
    
    for(int i = 0;  i < rndValueForCurveCount+1; i++){
        float tempXPt = 0;
        
        if(i%2 == 0 ){
            if(rndValueCurveStart % 2 == 0)
                tempXPt = tempRightXPt - rndValueCurveWidth;
            else
                tempXPt = tempRightXPt + rndValueCurveWidth;
        }
        else{
            if(rndValueCurveStart % 2 == 0)
                tempXPt = tempRightXPt + rndValueCurveWidth;
            else
                tempXPt = tempRightXPt - rndValueCurveWidth;
        }
        
        CGPathAddLineToPoint(curvs, nil, tempXPt, lastYPt );
        
        lastYPt = lastYPt + subheight;
    }
    
    CGPathAddLineToPoint(curvs, nil, imageSize.width + rndValueCurveWidth, lastYPt + rndValueCurveWidth);
    CGPathAddLineToPoint(curvs, nil, imageSize.width + rndValueCurveWidth, lastYPt + rndValueCurveWidth);
    CGPathAddLineToPoint(curvs, nil, imageSize.width + rndValueCurveWidth, -rndValueCurveWidth);
    
    NSArray *colorsArr = [RandomObjects getRandomGradientColorArray];
    UIColor *borderColor = [UIColor colorWithHexString:[NSString randomHexString]];
    
    [self colorCloudBackground:ctx withcolors:colorsArr img:imageSize path:curvs border:borderColor];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(asWindow){
        UIImage *img = [UIImage removeWhiteColor:result];
        return img;
    }
    return result;
}

+(UIImage *)createHorizontalSpikes:(CGSize)imageSize asWindow:(BOOL)asWindow{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //int rndValueForClearOrGradientShape = [NSNumber randomIntInLimit:0 endLimit:10];
    
    if(asWindow){
        CGContextSetRGBFillColor(ctx, (254.0/255.0), (254.0/255.0), 254.0/255.0, 1.0);
        CGContextFillRect(ctx, CGRectMake(0, 0, imageSize.width, imageSize.height));
    }
    else{
        CGContextFillRect(ctx, CGRectMake(0, 0, imageSize.width, imageSize.height));
        NSArray *colorsArr = [RandomObjects getRandomGradientColorArray];
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef mountainGrad = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colorsArr, NULL);
        
        //CGContextClip(ctx);
        int randomValueForGradientType = 2;
        
        if(randomValueForGradientType % 2 == 0){
            CGContextDrawLinearGradient(ctx, mountainGrad, CGPointMake(0,0), CGPointMake(0, imageSize.height), 0);
        }
        else{
            CGPoint startPoint = CGPointMake(imageSize.width/2, imageSize.height/2);
            
            CGContextDrawRadialGradient(ctx, mountainGrad, startPoint, 0, startPoint, imageSize.width, 0);
        }
    }
    
    int rndValueForCurveCount = [NSNumber randomIntInLimit:10 endLimit:15];
    
    int width = imageSize.width;
    int subWidth = width/rndValueForCurveCount;
    
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float rndStartPoint = [NSNumber randomFloatInLimit:imageSize.height*(0.10) endLimit:imageSize.height*(0.15)];
    
    float tempTopYPt = rndStartPoint;
    float tempBottomYPt = imageSize.height - rndStartPoint;
    
    CGPoint topStartPt  = CGPointMake(0, tempTopYPt);
    CGPoint bottomStartPt = CGPointMake(0, tempBottomYPt);
    
    int rndValueHeight = [NSNumber randomIntInLimit:5 endLimit:rndStartPoint/2];
    
    CGPathMoveToPoint(curvs, nil, 0, tempTopYPt + rndValueHeight);
    
    int rndValueForBorder = [NSNumber randomIntInLimit:1 endLimit:4];
    
    if(rndValueForBorder == 1 || rndValueForBorder == 3){
        float lastXPoint  = topStartPt.x + subWidth;
        for(int i = 0;  i < rndValueForCurveCount+1; i++){
            float tempYPt = 0;
            
            if(i%2 == 0 ){
                tempYPt = tempTopYPt - rndValueHeight;
            }
            else{
                tempYPt = tempTopYPt + rndValueHeight;
            }
            
            CGPathAddLineToPoint(curvs, nil, lastXPoint, tempYPt);
            
            lastXPoint = lastXPoint + subWidth;
        }
        
        CGPathAddLineToPoint(curvs, nil, lastXPoint, -rndValueHeight);
        CGPathAddLineToPoint(curvs, nil, -rndValueHeight, -rndValueHeight);
        CGPathAddLineToPoint(curvs, nil, -rndValueHeight, topStartPt.y);
    }
    
    CGPathMoveToPoint(curvs, nil, 0, tempBottomYPt + rndValueHeight);
    
    if(rndValueForBorder == 2 || rndValueForBorder == 3){
        float lastXPoint  = bottomStartPt.x + subWidth;
        for(int i = 0;  i < rndValueForCurveCount+1; i++){
            float tempYPt = 0;
            
            if(i%2 == 0 ){
                tempYPt = tempBottomYPt - rndValueHeight;
            }
            else{
                tempYPt = tempBottomYPt + rndValueHeight;
            }
            
            CGPathAddLineToPoint(curvs, nil, lastXPoint, tempYPt);
            
            lastXPoint = lastXPoint + subWidth;
        }
        
        CGPathAddLineToPoint(curvs, nil, lastXPoint, imageSize.height + rndValueHeight);
        CGPathAddLineToPoint(curvs, nil, -rndValueHeight, imageSize.height + rndValueHeight);
        CGPathAddLineToPoint(curvs, nil, -rndValueHeight, bottomStartPt.y);
    }
    
    NSArray *colorsArr = [RandomObjects getRandomGradientColorArray];
    UIColor *borderColor = [UIColor colorWithHexString:[NSString randomHexString]];
    
    [self colorCloudBackground:ctx withcolors:colorsArr img:imageSize path:curvs border:borderColor];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(asWindow){
        UIImage *img = [UIImage removeWhiteColor:result];
        return img;
    }
    return result;
}

+(void)colorCloudBackground:(CGContextRef)ctx withcolors:(NSArray *)colorsArr img:(CGSize)imgSize path:(CGMutablePathRef)curve border:(UIColor *)borderColor{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef mountainGrad = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colorsArr, NULL);
    
    CGPathCloseSubpath(curve);
    
    CGContextAddPath(ctx, curve);
    CGContextClip(ctx);
    int randomValueForGradientType = 2;
    
    if(randomValueForGradientType % 2 == 0){
        CGContextDrawLinearGradient(ctx, mountainGrad, CGPointMake(0,0), CGPointMake(0, imgSize.height), 0);
    }
    else{
        CGPoint startPoint = CGPointMake(imgSize.width/2, imgSize.height/2);
        
        CGContextDrawRadialGradient(ctx, mountainGrad, startPoint, 0, startPoint, imgSize.width, 0);
    }
//    float rndValue = [NSNumber randomFloatInLimit:4.0f endLimit:15.0f];
    float rndValue = [NSNumber randomFloatInLimit:imgSize.width/75 endLimit:imgSize.width/20];
    CGContextSetLineWidth(ctx, rndValue);
    
    // Background Mountain Stroking
    CGContextAddPath(ctx, curve);
    
    CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
    CGContextStrokePath(ctx);
}

@end
