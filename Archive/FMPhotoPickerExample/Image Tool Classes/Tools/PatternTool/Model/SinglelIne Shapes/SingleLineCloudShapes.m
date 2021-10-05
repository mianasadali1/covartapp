//
//  SingleLineCloudShapes.m
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 05/12/15.
//  Copyright © 2015 Kanwarpal Singh. All rights reserved.
//

#import "SingleLineCloudShapes.h"
#import <UIKit/UIKit.h>
#import "NSNumber+RandomNumberGenrator.h"
#import "RandomObjects.h"
#import "UIColor+HexColors.h"
#import "NSString+RandomStringGenrator.h"
#import "UIImage+Utility.h"

@implementation SingleLineCloudShapes

//****************************************** create cloude shapes at boundaries ***************************************//

+(UIImage *)generateImageAsWindow:(CGSize)imageSize effectId:(NSUInteger)effectId{
    //35
    
    int rndSquarePosition = [NSNumber randomIntInLimit:1 endLimit:10];
    
    UIImage *img;
    
    if(rndSquarePosition % 2 == 0){
        img = [self createVerticalCloud:imageSize asWindow:YES];
    }
    else{
        img = [self createHorizontalCloud:imageSize asWindow:YES];
    }
    
    return img;
}

+(UIImage *)generateImage:(CGSize)imageSize effectId:(NSUInteger)effectId{
    //13
    int rndSquarePosition = [NSNumber randomIntInLimit:1 endLimit:10];
    
    UIImage *img;
    
    if(rndSquarePosition % 2 == 0){
        int isWindowRnd = [NSNumber randomIntInLimit:1 endLimit:10];

        if(isWindowRnd % 2 == 0){
            img = [self createVerticalCloud:imageSize asWindow:NO];
        }
        else{
            img = [self createVerticalCloud:imageSize asWindow:NO];
        }
    }
    else{
        int isWindowRnd = [NSNumber randomIntInLimit:1 endLimit:10];
        
        if(isWindowRnd % 2 == 0){
            img = [self createHorizontalCloud:imageSize asWindow:NO];
        }
        else{
            img = [self createHorizontalCloud:imageSize asWindow:NO];
        }
    }
    
    return img;
}

+(UIImage *)createVerticalCloud:(CGSize)imageSize asWindow:(BOOL)asWindow{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
//    CGContextSetRGBFillColor(ctx, (254.0/255.0), (254.0/255.0), 254.0/255.0, 1.0);
    
    if(asWindow){
        CGContextSetRGBFillColor(ctx, 0.0, 0.0, 0.0, 0.0);

        CGContextFillRect(ctx, CGRectMake(0, 0, imageSize.width, imageSize.height));
    }
    else{
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
    
    int rndValueForCurveCount = [NSNumber randomIntInLimit:5 endLimit:15];
    
    int height = imageSize.height;
    int subheight = height/rndValueForCurveCount;
    
    int rndValueForShape = [NSNumber randomIntInLimit:1 endLimit:10];
    
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float rndStartPoint = [NSNumber randomFloatInLimit:imageSize.width*(0.10) endLimit:imageSize.width*(0.20)];
    
    float tempLeftXPt = rndStartPoint;
    float tempRightXPt = imageSize.height - rndStartPoint;
    
    int rndValueCurveWidth = [NSNumber randomIntInLimit:5 endLimit:rndStartPoint/2];
    
    // for Bezier Curv
    if(rndValueForShape %2 == 0 ){
        
        CGPathMoveToPoint(curvs, nil, tempLeftXPt, -rndValueCurveWidth);
        
        CGPoint leftStartPt  = CGPointMake(tempLeftXPt, 0);
        
        CGPoint rightStartPt = CGPointMake(tempRightXPt, 0);
        
        float lastYPoint  = leftStartPt.y + subheight;
        
        for(int i = 0;  i < (rndValueForCurveCount/3)+1; i++){
            
            CGPathAddCurveToPoint(curvs, nil, leftStartPt.x + rndValueCurveWidth, lastYPoint , leftStartPt.x - rndValueCurveWidth,lastYPoint + subheight, leftStartPt.x , lastYPoint + (subheight*2));
            lastYPoint = lastYPoint + (subheight*3);
        }
        
        CGPathAddLineToPoint(curvs, nil, tempLeftXPt, lastYPoint + rndValueCurveWidth);
        CGPathAddLineToPoint(curvs, nil, -rndValueCurveWidth*2, lastYPoint + rndValueCurveWidth);
        CGPathAddLineToPoint(curvs, nil, -rndValueCurveWidth*2, -rndValueCurveWidth*2);
        
        CGPathMoveToPoint(curvs, nil, tempRightXPt, -rndValueCurveWidth);
        lastYPoint  = rightStartPt.y + subheight;
        
        for(int i = 0;  i < (rndValueForCurveCount/3)+1; i++){
            
            CGPathAddCurveToPoint(curvs, nil, rightStartPt.x + rndValueCurveWidth, lastYPoint , rightStartPt.x - rndValueCurveWidth,lastYPoint + subheight, rightStartPt.x , lastYPoint + (subheight*2));
            lastYPoint = lastYPoint + (subheight*3);
        }
        
        CGPathAddLineToPoint(curvs, nil, tempRightXPt, lastYPoint + rndValueCurveWidth);
        CGPathAddLineToPoint(curvs, nil, tempRightXPt + rndStartPoint + rndValueCurveWidth, lastYPoint + rndValueCurveWidth);
        CGPathAddLineToPoint(curvs, nil, tempRightXPt + rndStartPoint + rndValueCurveWidth, -rndValueCurveWidth*2);
        
        NSArray *colorsArr = [RandomObjects getRandomGradientColorArray];
        UIColor *borderColor = [UIColor colorWithHexString:[NSString randomHexString]];
        
        [self colorCloudBackground:ctx withcolors:colorsArr img:imageSize path:curvs border:borderColor];
    }
    // for Quard Curv
    else{
        float lastYPt = 0;
        
        CGPathMoveToPoint(curvs, nil, tempLeftXPt, -rndValueCurveWidth);
        
        for(int i = 0;  i < (rndValueForCurveCount/2)+1; i++){
            float tempXPt = 0;
            
            if(i%2 == 0 ){
                tempXPt = tempLeftXPt - rndValueCurveWidth *2;
            }
            else{
                tempXPt = tempLeftXPt + rndValueCurveWidth *2;
            }
            
            CGPathAddQuadCurveToPoint(curvs, nil, tempXPt, lastYPt + subheight, tempLeftXPt, lastYPt + (subheight*2));
            lastYPt = lastYPt + (subheight*2);
        }
        
        CGPathAddLineToPoint(curvs, nil, tempLeftXPt, lastYPt + rndValueCurveWidth);
        CGPathAddLineToPoint(curvs, nil, -rndValueCurveWidth*2, lastYPt + rndValueCurveWidth);
        CGPathAddLineToPoint(curvs, nil, -rndValueCurveWidth*2, -rndValueCurveWidth*2);
        
        CGPathMoveToPoint(curvs, nil, tempRightXPt, -rndValueCurveWidth*2);
        
        lastYPt = 0;
        
        for(int i = 0;  i < (rndValueForCurveCount/2)+1; i++){
            float tempXPt = 0;
            
            if(i%2 == 0 ){
                tempXPt = tempRightXPt - rndValueCurveWidth *2;
            }
            else{
                tempXPt = tempRightXPt + rndValueCurveWidth *2;
            }
            
            CGPathAddQuadCurveToPoint(curvs, nil, tempXPt, lastYPt + subheight, tempRightXPt, lastYPt + (subheight*2));
            lastYPt = lastYPt + (subheight*2);
        }
        
        CGPathAddLineToPoint(curvs, nil, tempRightXPt, lastYPt + rndValueCurveWidth);
        CGPathAddLineToPoint(curvs, nil, tempRightXPt + rndStartPoint + rndValueCurveWidth, lastYPt + rndValueCurveWidth);
        CGPathAddLineToPoint(curvs, nil, tempRightXPt + rndStartPoint + rndValueCurveWidth, -rndValueCurveWidth*2);
        
        NSArray *colorsArr = [RandomObjects getRandomGradientColorArray];
        UIColor *borderColor = [UIColor colorWithHexString:[NSString randomHexString]];
        
        [self colorCloudBackground:ctx withcolors:colorsArr img:imageSize path:curvs border:borderColor];
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    if(asWindow){
//        UIImage *img = [UIImage removeWhiteColor:result];
//
//        NSData *pngData = UIImagePNGRepresentation(img);
//
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
//        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"]; //Add the file name
//        [pngData writeToFile:filePath atomically:YES]; //Write the file
//
//        return img;
//    }
    return result;
}

+(UIImage *)createHorizontalCloud:(CGSize)imageSize asWindow:(BOOL)asWindow{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextFillRect(ctx, CGRectMake(0, 0, imageSize.width, imageSize.height));
    
    if(asWindow){
        CGContextSetRGBFillColor(ctx, 0.0, 0.0, 0.0, 0.0);
    }
    else{
        NSArray *colorsArr = [RandomObjects getRandomGradientColorArray];
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef mountainGrad = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colorsArr, NULL);
        
       // CGContextClip(ctx);
        int randomValueForGradientType = 2;
        
        if(randomValueForGradientType % 2 == 0){
            CGContextDrawLinearGradient(ctx, mountainGrad, CGPointMake(0,0), CGPointMake(0, imageSize.height), 0);
        }
        else{
            CGPoint startPoint = CGPointMake(imageSize.width/2, imageSize.height/2);
            
            CGContextDrawRadialGradient(ctx, mountainGrad, startPoint, 0, startPoint, imageSize.width, 0);
        }
    }

    
    int rndValueForCurveCount = [NSNumber randomIntInLimit:5 endLimit:20];
    
    int width = imageSize.width;
    int subWidth = width/rndValueForCurveCount;
    
    int rndValueForShape = [NSNumber randomIntInLimit:1 endLimit:10];
    
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float rndStartPoint = [NSNumber randomFloatInLimit:imageSize.height*(0.10) endLimit:imageSize.height*(0.20)];
    
    int rndValueHeight = [NSNumber randomIntInLimit:5 endLimit:rndStartPoint/2];

    float tempTopYPt = rndStartPoint;
    float tempBottomYPt = imageSize.height - rndStartPoint;
    
    CGPathMoveToPoint(curvs, nil, -rndValueHeight, tempTopYPt);
    
    CGPoint topStartPt  = CGPointMake(-rndValueHeight, tempTopYPt);
    CGPoint bottomStartPt = CGPointMake(-rndValueHeight, tempBottomYPt);
    
    
    // for Bezier Curv
    if(rndValueForShape %2 == 0){
        int rndValueForBorder = [NSNumber randomIntInLimit:1 endLimit:4];
        
        if(rndValueForBorder == 1 || rndValueForBorder == 3){
            float lastXPoint  = topStartPt.x + subWidth;
            for(int i = 0;  i < (rndValueForCurveCount/3)+1; i++){
                CGPathAddCurveToPoint(curvs, nil, lastXPoint, topStartPt.y + rndValueHeight, lastXPoint + subWidth,topStartPt.y - rndValueHeight, lastXPoint + (subWidth *2), topStartPt.y);
                lastXPoint = lastXPoint + (subWidth *3);
            }
            
            CGPathAddLineToPoint(curvs, nil, lastXPoint, -rndValueHeight);
            CGPathAddLineToPoint(curvs, nil, -rndValueHeight, -rndValueHeight);
            CGPathAddLineToPoint(curvs, nil, -rndValueHeight, topStartPt.y);
        }
        
        if(rndValueForBorder == 2 || rndValueForBorder == 3){
            float lastXPoint  = bottomStartPt.x + subWidth;
            CGPathMoveToPoint(curvs, nil, 0, tempBottomYPt);
            
            for(int i = 0;  i < (rndValueForCurveCount/3)+1; i++){
                CGPathAddCurveToPoint(curvs, nil, lastXPoint, bottomStartPt.y + rndValueHeight, lastXPoint + subWidth,bottomStartPt.y - rndValueHeight, lastXPoint + (subWidth *2), bottomStartPt.y);
                lastXPoint = lastXPoint + (subWidth *3);
            }
            
            CGPathAddLineToPoint(curvs, nil, lastXPoint, imageSize.height + rndValueHeight);
            CGPathAddLineToPoint(curvs, nil, -rndValueHeight, imageSize.height + rndValueHeight);
            CGPathAddLineToPoint(curvs, nil, -rndValueHeight, bottomStartPt.y);
        }
        
        NSArray *colorsArr = [RandomObjects getRandomGradientColorArray];
        UIColor *borderColor = [UIColor colorWithHexString:[NSString randomHexString]];
        
        [self colorCloudBackground:ctx withcolors:colorsArr img:imageSize path:curvs border:borderColor];
    }
    // for Quard Curv
    else{
        int rndValueForBorder = [NSNumber randomIntInLimit:1 endLimit:4];
        float lastXPt = 0;
        
        if(rndValueForBorder == 1 || rndValueForBorder == 3){
            CGPathMoveToPoint(curvs, nil, 0, tempTopYPt);
            
            for(int i = 0;  i < (rndValueForCurveCount/2)+1; i++){
                float tempYPt = 0;
                
                if(i%2 == 0 ){
                    tempYPt = tempTopYPt - rndValueHeight;
                }
                else{
                    tempYPt = tempTopYPt + rndValueHeight;
                }
                
                CGPathAddQuadCurveToPoint(curvs, nil, lastXPt + subWidth, tempYPt, lastXPt + (subWidth*2), tempTopYPt);
                lastXPt = lastXPt + (subWidth*2);
            }
            CGPathAddLineToPoint(curvs, nil, lastXPt, -rndValueHeight);
            CGPathAddLineToPoint(curvs, nil, -rndValueHeight, -rndValueHeight);
            CGPathAddLineToPoint(curvs, nil, -rndValueHeight, topStartPt.y);
        }
        if(rndValueForBorder == 2 || rndValueForBorder == 3){
            float lastXPt = 0;
            CGPathMoveToPoint(curvs, nil, 0, tempBottomYPt);
            for(int i = 0;  i < (rndValueForCurveCount/2)+1; i++){
                float tempYPt = 0;
                
                if(i%2 == 0 ){
                    tempYPt = tempBottomYPt - rndValueHeight;
                }
                else{
                    tempYPt = tempBottomYPt + rndValueHeight;
                }
                
                CGPathAddQuadCurveToPoint(curvs, nil, lastXPt + subWidth, tempYPt, lastXPt + (subWidth*2), tempBottomYPt);
                lastXPt = lastXPt + (subWidth*2);
                
            }
            CGPathAddLineToPoint(curvs, nil, lastXPt, imageSize.height + rndValueHeight);
            CGPathAddLineToPoint(curvs, nil, -rndValueHeight, imageSize.height + rndValueHeight);
            CGPathAddLineToPoint(curvs, nil, -rndValueHeight, bottomStartPt.y);
        }
        
        NSArray *colorsArr = [RandomObjects getRandomGradientColorArray];
        UIColor *borderColor = [UIColor colorWithHexString:[NSString randomHexString]];
        
        [self colorCloudBackground:ctx withcolors:colorsArr img:imageSize path:curvs border:borderColor];
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    if(asWindow){
//        UIImage *img = [UIImage removeWhiteColor:result];
//
//        NSData *pngData = UIImagePNGRepresentation(img);
//
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
//        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"]; //Add the file name
//        [pngData writeToFile:filePath atomically:YES]; //Write the file
//
//        return img;
//    }
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
