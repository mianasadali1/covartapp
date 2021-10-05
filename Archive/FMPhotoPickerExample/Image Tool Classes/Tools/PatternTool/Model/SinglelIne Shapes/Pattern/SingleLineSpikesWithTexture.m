//
//  SingleLineSpikesWithTexture.m
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 10/01/16.
//  Copyright © 2016 Kanwarpal Singh. All rights reserved.
//

#import "SingleLineSpikesWithTexture.h"
#import "NSNumber+RandomNumberGenrator.h"
#import "RandomObjects.h"
#import "UIColor+HexColors.h"
#import "NSString+RandomStringGenrator.h"
#import "UIImage+Utility.h"

@implementation SingleLineSpikesWithTexture

#pragma mark spikes shapes

+(UIImage *)generateImage:(CGSize)imageSize effectId:(int)effectId{
    //19
    int rndSquarePosition = [NSNumber randomIntInLimit:1 endLimit:15];
    
    UIImage *img;
    
    if(rndSquarePosition % 2 == 0){
        img = [self createVerticalSpikes:imageSize asWindow:NO];
    }
    else{
        img = [self createHorizontalSpikes:imageSize asWindow:NO];
    }
    
    return img;
}

+(UIImage *)generateImageAsWindow:(CGSize)imageSize effectId:(int)effectId{
    //46
    int rndSquarePosition = [NSNumber randomIntInLimit:1 endLimit:15];
    
    UIImage *img;
    
    if(rndSquarePosition % 2 == 0){
        img = [self createVerticalSpikes:imageSize asWindow:YES];
    }
    else{
        img = [self createHorizontalSpikes:imageSize asWindow:YES];
    }
    
    return img;
}

+(UIImage *)createVerticalSpikes:(CGSize)imageSize asWindow:(BOOL)asWindow{
    
    //NSString *imgPath = [appDelegate getRandomImage];
    NSString *imgPath = @"";

    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:imgPath]];
    
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0, 0);
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    v.backgroundColor = color;
    [v.layer renderInContext:ctx];
    
    int rndValueForCurveCount = [NSNumber randomIntInLimit:10 endLimit:15];
    //int rndValueremoveGradientColor = [NSNumber randomIntInLimit:0 endLimit:10];
    
    int height = imageSize.height;
    int subheight = height/rndValueForCurveCount;
    
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float rndStartPoint =   [NSNumber randomFloatInLimit:imageSize.width*(0.10) endLimit:imageSize.width*(0.15)];
    
    float tempLeftXPt   =   rndStartPoint ;
    float tempRightXPt  =   imageSize.height - rndStartPoint;
    
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
    
    CGPathAddLineToPoint(curvs, nil, tempLeftXPt, lastYPt + 10);
    
    int rndValueCurveStart = [NSNumber randomIntInLimit:1 endLimit:10];
    
    CGPathAddLineToPoint(curvs, nil, tempRightXPt + (rndValueCurveWidth*2), lastYPt + 10);
    
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
        
        lastYPt = lastYPt - subheight;
    }
    
    CGPathAddLineToPoint(curvs, nil, tempRightXPt, -10);
    CGPathAddLineToPoint(curvs, nil, tempLeftXPt + (rndValueCurveWidth*2), -subheight);
    
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
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(asWindow)
        result = [UIImage removeWhiteColor:result];
    
    return result;
}

+(UIImage *)createHorizontalSpikes:(CGSize)imageSize asWindow:(BOOL)asWindow{
    
    //NSString *imgPath = [appDelegate getRandomImage];
    NSString *imgPath = @"";

    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:imgPath]];
    
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0, 0);
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    v.backgroundColor = color;
    [v.layer renderInContext:ctx];
    
    int rndValueForCurveCount = [NSNumber randomIntInLimit:10 endLimit:15];
   // int rndValueremoveGradientColor = [NSNumber randomIntInLimit:0 endLimit:10];
    
    int width = imageSize.width;
    int subWidth = width/rndValueForCurveCount;
    
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float rndStartPoint = [NSNumber randomFloatInLimit:imageSize.height*(0.10) endLimit:imageSize.height*(0.15)];
    
    float tempTopYPt = rndStartPoint;
    float tempBottomYPt = imageSize.height - rndStartPoint;
    
    CGPoint topStartPt  = CGPointMake(0, tempTopYPt);
    
    int rndValueHeight = [NSNumber randomIntInLimit:5 endLimit:rndStartPoint/2];
    
    CGPathMoveToPoint(curvs, nil, -10, tempTopYPt + rndValueHeight);

    float lastXPoint  = topStartPt.x + subWidth;
    int i = 0;
    while (lastXPoint < imageSize.width) {
        float tempYPt = 0;
        
        if(i%2 == 0 ){
            tempYPt = tempTopYPt - rndValueHeight;
        }
        else{
            tempYPt = tempTopYPt + rndValueHeight;
        }
        
        CGPathAddLineToPoint(curvs, nil, lastXPoint, tempYPt);
        
        lastXPoint = lastXPoint + subWidth;
        i += 1;
    }
    
    CGPathAddLineToPoint(curvs, nil, lastXPoint + 10, tempTopYPt );
    CGPathAddLineToPoint(curvs, nil, lastXPoint + 10, tempBottomYPt);
    
    i = 0;
    while (lastXPoint + subWidth  > 0) {
        float tempYPt = 0;
        
        if(i%2 == 0 ){
            tempYPt = tempBottomYPt - rndValueHeight;
        }
        else{
            tempYPt = tempBottomYPt + rndValueHeight;
        }
        
        CGPathAddLineToPoint(curvs, nil, lastXPoint, tempYPt);
        lastXPoint = lastXPoint - subWidth;
        
        i += 1;
    }
    
    CGPathAddLineToPoint(curvs, nil, lastXPoint, tempBottomYPt);
    CGPathAddLineToPoint(curvs, nil, -10, tempBottomYPt);
    CGPathAddLineToPoint(curvs, nil, -10, tempTopYPt + rndValueHeight);
    
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
