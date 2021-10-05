//
//  SingleLineCludeShapesWithTexture.m
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 10/01/16.
//  Copyright © 2016 Kanwarpal Singh. All rights reserved.
//

#import "SingleLineCludeShapesWithTexture.h"
#import <UIKit/UIKit.h>
#import "NSNumber+RandomNumberGenrator.h"
#import "RandomObjects.h"
#import "UIColor+HexColors.h"
#import "NSString+RandomStringGenrator.h"
#import "UIImage+Utility.h"

@implementation SingleLineCludeShapesWithTexture

+(UIImage *)generateImageAsWindow:(CGSize)imageSize effectId:(int)effectId{
    //45
    int rndSquarePosition = 1;
    
    UIImage *img;
    
    if(rndSquarePosition % 2 == 0){
        img = [self createVerticalCloud:imageSize asWindow:YES];
    }
    else{
        img = [self createHorizontalCloud:imageSize asWindow:YES];
    }
    
    return img;
}

+(UIImage *)generateImage:(CGSize)imageSize effectId:(int)effectId{
    //18
    int rndSquarePosition = 1;
    
    UIImage *img;
    
    if(rndSquarePosition % 2 == 0){
        img = [self createVerticalCloud:imageSize asWindow:NO];
    }
    else{
        img = [self createHorizontalCloud:imageSize asWindow:NO];
    }
    
    return img;
}

+(UIImage *)createVerticalCloud:(CGSize)imageSize asWindow:(BOOL)asWindow{
    
   // NSString *imgPath = [appDelegate getRandomImage];
    NSString *imgPath = @"";

    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:imgPath]];
    
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0, 0);
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    v.backgroundColor = color;
    [v.layer renderInContext:ctx];
    
    int rndValueForCurveCount = [NSNumber randomIntInLimit:5 endLimit:15];
    
    int height = imageSize.height;
    int subheight = height/rndValueForCurveCount;
    
    int rndValueForShape = [NSNumber randomIntInLimit:0 endLimit:10];
    
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float rndStartPoint = [NSNumber randomFloatInLimit:imageSize.width*(0.10) endLimit:imageSize.width*(0.20)];
    
    float tempLeftXPt = rndStartPoint;
    float tempRightXPt = imageSize.height - rndStartPoint;
    
    int rndValueCurveWidth = [NSNumber randomIntInLimit:5 endLimit:rndStartPoint/2];
   // int rndValueremoveGradientColor = [NSNumber randomIntInLimit:0 endLimit:10];
    // for Bezier Curv
    if(rndValueForShape %2 == 0 ){
        CGPathMoveToPoint(curvs, nil, tempLeftXPt, -10);
        CGPoint leftStartPt  = CGPointMake(tempLeftXPt, 0);
        CGPoint rightStartPt = CGPointMake(tempRightXPt, 0);
        float lastYPoint  = leftStartPt.y + subheight;
        for(int i = 0;  i < (rndValueForCurveCount/3)+1; i++){
            
            CGPathAddCurveToPoint(curvs, nil, leftStartPt.x + rndValueCurveWidth, lastYPoint , leftStartPt.x - rndValueCurveWidth,lastYPoint + subheight, leftStartPt.x , lastYPoint + (subheight*2));
            lastYPoint = lastYPoint + (subheight*3);
        }
        
        CGPathAddLineToPoint(curvs, nil, tempLeftXPt, lastYPoint + 20);
        CGPathAddLineToPoint(curvs, nil, imageSize.width/2, lastYPoint + 20);
        CGPathAddLineToPoint(curvs, nil, tempRightXPt, lastYPoint + 20);
    
        lastYPoint  = imageSize.height + 10;
        
        for(int i = 0;  i < (rndValueForCurveCount/3)+1; i++){
            
            CGPathAddCurveToPoint(curvs, nil, rightStartPt.x + rndValueCurveWidth, lastYPoint , rightStartPt.x - rndValueCurveWidth,lastYPoint - subheight, rightStartPt.x , lastYPoint - (subheight*2));
            lastYPoint = lastYPoint - (subheight*3);
        }
        
        CGPathAddLineToPoint(curvs, nil, tempRightXPt, lastYPoint - 20);
        CGPathAddLineToPoint(curvs, nil, imageSize.width/2, lastYPoint - 20);
        CGPathMoveToPoint(curvs, nil, tempLeftXPt, -10);
        
        NSArray *gradientColorArr ;
        if(asWindow){
            gradientColorArr = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor, nil];
        }
        else{
            gradientColorArr = [RandomObjects getRandomGradientColorArray];
        }
        
        NSArray *colorsArr = gradientColorArr;

        UIColor *borderColor = [UIColor colorWithHexString:[NSString randomHexString]];
        
        [self colorCloudBackground:ctx withcolors:colorsArr img:imageSize path:curvs border:borderColor];
    }
    // for Quard Curv
    else{
        float lastYPt = 0;
        
        CGPathMoveToPoint(curvs, nil, tempLeftXPt, -10);
        
        for(int i = 0;  i < (rndValueForCurveCount/2)+1; i++){
            float tempXPt = 0;
            
            if(i%2 == 0 ){
                tempXPt = tempLeftXPt - rndValueCurveWidth;
            }
            else{
                tempXPt = tempLeftXPt + rndValueCurveWidth;
            }
            
            CGPathAddQuadCurveToPoint(curvs, nil, tempXPt, lastYPt + subheight, tempLeftXPt, lastYPt + (subheight*2));
            lastYPt = lastYPt + (subheight*2);
        }
        
        CGPathAddLineToPoint(curvs, nil, tempLeftXPt, lastYPt + 10);
        //CGPathAddLineToPoint(curvs, nil,imageSize.width/2, lastYPt + 10);
        //CGPathAddLineToPoint(curvs, nil, imageSize.width/2, -20);
        
        lastYPt = imageSize.height;
        CGPathAddLineToPoint(curvs, nil, tempRightXPt, lastYPt + 10);
        
        for(int i = 0;  i < (rndValueForCurveCount/2)+1; i++){
            float tempXPt = 0;
            
            if(i%2 == 0 ){
                tempXPt = tempRightXPt - rndValueCurveWidth;
            }
            else{
                tempXPt = tempRightXPt + rndValueCurveWidth;
            }
            
            CGPathAddQuadCurveToPoint(curvs, nil, tempXPt, lastYPt - subheight, tempRightXPt, lastYPt - (subheight*2));
            lastYPt = lastYPt - (subheight*2);
        }
        
        CGPathAddLineToPoint(curvs, nil, tempRightXPt, - 10);
        CGPathAddLineToPoint(curvs, nil, tempLeftXPt, - 10);
        //CGPathAddLineToPoint(curvs, nil, tempRightXPt + rndStartPoint + 20, -20);
        NSArray *gradientColorArr ;
        if(asWindow){
            gradientColorArr = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor, nil];
        }
        else{
            gradientColorArr = [RandomObjects getRandomGradientColorArray];
        }
        
        NSArray *colorsArr = gradientColorArr;
        UIColor *borderColor = [UIColor colorWithHexString:[NSString randomHexString]];
        
        [self colorCloudBackground:ctx withcolors:colorsArr img:imageSize path:curvs border:borderColor];
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(asWindow)
        result = [UIImage removeWhiteColor:result];
    
    return result;
}

+(UIImage *)createHorizontalCloud:(CGSize)imageSize asWindow:(BOOL)asWindow{
    
   // NSString *imgPath = [appDelegate getRandomImage];
    NSString *imgPath = @"";

    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:imgPath]];
    
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0, 0);
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    v.backgroundColor = color;
    [v.layer renderInContext:ctx];
    
    int rndValueForCurveCount = [NSNumber randomIntInLimit:5 endLimit:20];
    
    int width = imageSize.width;
    int subWidth = width/rndValueForCurveCount;
    
    int rndValueForShape = 1;
    
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float rndStartPoint = [NSNumber randomFloatInLimit:imageSize.height*(0.10) endLimit:imageSize.height*(0.20)];
    
    float tempTopYPt = rndStartPoint;
    float tempBottomYPt = imageSize.height - rndStartPoint;
    
    CGPathMoveToPoint(curvs, nil, -10, tempTopYPt);
    
    CGPoint topStartPt  = CGPointMake(-10, tempTopYPt);
    CGPoint bottomStartPt = CGPointMake(-10, tempBottomYPt);
    
    int rndValueHeight = [NSNumber randomIntInLimit:5 endLimit:rndStartPoint/2];
    //int rndValueremoveGradientColor = [NSNumber randomIntInLimit:0 endLimit:10];
    
    // for Bezier Curv
    if(rndValueForShape %2 == 0){
       // int rndValueForBorder = [NSNumber randomIntInLimit:1 endLimit:4];
        
        float lastXPoint  = topStartPt.x + subWidth;
        for(int i = 0;  i < (rndValueForCurveCount/3)+1; i++){
            CGPathAddCurveToPoint(curvs, nil, lastXPoint, topStartPt.y + rndValueHeight, lastXPoint + subWidth,topStartPt.y - rndValueHeight, lastXPoint + (subWidth *2), topStartPt.y);
            lastXPoint = lastXPoint + (subWidth *3);
        }
        
        CGPathAddLineToPoint(curvs, nil, lastXPoint, tempBottomYPt);
        
        for(int i = 0;  i < (rndValueForCurveCount/3)+1; i++){
            CGPathAddCurveToPoint(curvs, nil, lastXPoint, bottomStartPt.y + rndValueHeight, lastXPoint - subWidth,bottomStartPt.y - rndValueHeight, lastXPoint - (subWidth *2), bottomStartPt.y);
            lastXPoint = lastXPoint - (subWidth *3);
        }
        
        CGPathAddLineToPoint(curvs, nil, -10, tempBottomYPt);
        CGPathAddLineToPoint(curvs, nil, -10, tempTopYPt);
        
        NSArray *gradientColorArr ;
        if(asWindow){
            gradientColorArr = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor, nil];
        }
        else{
            gradientColorArr = [RandomObjects getRandomGradientColorArray];
        }
        
        NSArray *colorsArr = gradientColorArr;
        UIColor *borderColor = [UIColor colorWithHexString:[NSString randomHexString]];
        
        [self colorCloudBackground:ctx withcolors:colorsArr img:imageSize path:curvs border:borderColor];
    }
    // for Quard Curv
    else{
       // int rndValueForBorder = [NSNumber randomIntInLimit:1 endLimit:4];
        float lastXPt = 0;
        
        //if(rndValueForBorder == 1 || rndValueForBorder == 3){
            CGPathMoveToPoint(curvs, nil, -10, tempTopYPt);
            
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
            CGPathAddLineToPoint(curvs, nil, lastXPt, tempBottomYPt);
            //CGPathAddLineToPoint(curvs, nil, -20, -20);
            //CGPathAddLineToPoint(curvs, nil, -20, topStartPt.y);
       // }
       // if(rndValueForBorder == 2 || rndValueForBorder == 3){
            //lastXPt = 0;
           // CGPathMoveToPoint(curvs, nil, 0, tempBottomYPt);
            for(int i = 0;  i < (rndValueForCurveCount/2)+1; i++){
                float tempYPt = 0;
                
                if(i%2 == 0 ){
                    tempYPt = tempBottomYPt - rndValueHeight;
                }
                else{
                    tempYPt = tempBottomYPt + rndValueHeight;
                }
                
                CGPathAddQuadCurveToPoint(curvs, nil, lastXPt - subWidth, tempYPt, lastXPt - (subWidth*2), tempBottomYPt);
                lastXPt = lastXPt - (subWidth*2);
                
            }
            CGPathAddLineToPoint(curvs, nil, -10, tempBottomYPt);
            CGPathAddLineToPoint(curvs, nil, -10, tempTopYPt);
           // CGPathAddLineToPoint(curvs, nil, -20, bottomStartPt.y);
      //  }
        
        NSArray *gradientColorArr ;
        if(asWindow){
            gradientColorArr = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor, nil];
        }
        else{
            gradientColorArr = [RandomObjects getRandomGradientColorArray];
        }
        
        NSArray *colorsArr = gradientColorArr;
        
        UIColor *borderColor = [UIColor colorWithHexString:[NSString randomHexString]];
        
        [self colorCloudBackground:ctx withcolors:colorsArr img:imageSize path:curvs border:borderColor];
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(asWindow)
        result = [UIImage removeWhiteColor:result];
    
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
    
    float rndValue = [NSNumber randomFloatInLimit:4.0f endLimit:15.0f];
    CGContextSetLineWidth(ctx, rndValue);
    
    // Background Mountain Stroking
    CGContextAddPath(ctx, curve);
    
    CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
    CGContextStrokePath(ctx);
}


@end
