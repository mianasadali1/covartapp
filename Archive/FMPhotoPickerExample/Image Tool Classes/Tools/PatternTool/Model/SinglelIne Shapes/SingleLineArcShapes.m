//
//  SingleLineArcShapes.m
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 05/12/15.
//  Copyright © 2015 Kanwarpal Singh. All rights reserved.
//

#import "SingleLineArcShapes.h"
#import <UIKit/UIKit.h>
#import "NSNumber+RandomNumberGenrator.h"
#import "RandomObjects.h"
#import "UIColor+HexColors.h"
#import "NSString+RandomStringGenrator.h"
#import "UIImage+Utility.h"

@implementation SingleLineArcShapes

#pragma mark Arc shapes

//****************************************** create Arc shapes at boundaries***************************************//

+(UIImage *)generateImage:(CGSize)imageSize effectId:(int)effectId{
    //34
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(ctx, (254.0/255.0), (254.0/255.0), 254.0/255.0, 1.0);
    CGContextFillRect(ctx, CGRectMake(0, 0, imageSize.width, imageSize.height));
    
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float randomValueCofficeint = [NSNumber randomFloatInLimit:0.20 endLimit:0.40];
    
    float rndArcHeight = imageSize.height*randomValueCofficeint;
    
    float randomRadiousCofficeint = [RandomObjects getRandomArcRadiusSize];
    
    float rndRadiousHeight = rndArcHeight*randomRadiousCofficeint * 2 ;
    
    int rndArcNumbers = [NSNumber randomIntInLimit:1 endLimit:10];
    
    if(rndArcNumbers %2 == 0){
        rndArcHeight = rndArcHeight / 1.5;
        rndRadiousHeight = rndRadiousHeight /1.5;
        //Top Arc
        float topStartYPt =  rndArcHeight;
        
        CGPathMoveToPoint(curvs, nil, 0, topStartYPt);
        
        CGPathAddQuadCurveToPoint(curvs, nil, imageSize.width/2, topStartYPt - rndRadiousHeight, imageSize.width, topStartYPt);
        
        CGPathAddLineToPoint(curvs, nil, imageSize.width + 20, topStartYPt);
        
        CGPathAddLineToPoint(curvs, nil, imageSize.width + 20, - 20);
        
        CGPathAddLineToPoint(curvs, nil, - 20, -20);
        
        CGPathAddLineToPoint(curvs, nil, - 20, topStartYPt);
        
        
        //Bottom arc
        
        float bottomStartYPt = imageSize.height - rndArcHeight;
        
        CGPathMoveToPoint(curvs, nil, 0, bottomStartYPt);
        
        CGPathAddQuadCurveToPoint(curvs, nil, imageSize.width/2, bottomStartYPt + rndRadiousHeight, imageSize.width, bottomStartYPt);
        
        CGPathAddLineToPoint(curvs, nil, imageSize.width + 20, bottomStartYPt);
        
        CGPathAddLineToPoint(curvs, nil, imageSize.width + 20, imageSize.height + 20);
        
        CGPathAddLineToPoint(curvs, nil, - 20, imageSize.height + 20);
        
        CGPathAddLineToPoint(curvs, nil, - 20, bottomStartYPt);
        
    }
    else{
        
        int rndArcPosition = [NSNumber randomIntInLimit:1 endLimit:10];
        
        if(rndArcPosition %2 == 0){
            //Top Arc
            float startYPt =  rndArcHeight;
            
            CGPathMoveToPoint(curvs, nil, 0, startYPt);
            
            CGPathAddQuadCurveToPoint(curvs, nil, imageSize.width/2, startYPt - rndRadiousHeight, imageSize.width, startYPt);
            
            CGPathAddLineToPoint(curvs, nil, imageSize.width + 20, startYPt);
            
            CGPathAddLineToPoint(curvs, nil, imageSize.width + 20, - 20);
            
            CGPathAddLineToPoint(curvs, nil, - 20, -20);
            
            CGPathAddLineToPoint(curvs, nil, - 20, startYPt);
        }
        else{
            
            float startYPt = imageSize.height - rndArcHeight;
            
            CGPathMoveToPoint(curvs, nil, 0, startYPt);
            
            CGPathAddQuadCurveToPoint(curvs, nil, imageSize.width/2, startYPt + rndRadiousHeight, imageSize.width, startYPt);
            
            CGPathAddLineToPoint(curvs, nil, imageSize.width + 20, startYPt);
            
            CGPathAddLineToPoint(curvs, nil, imageSize.width + 20, imageSize.height + 20);
            
            CGPathAddLineToPoint(curvs, nil, - 20, imageSize.height + 20);
            
            CGPathAddLineToPoint(curvs, nil, - 20, startYPt);
        }
    }
    
    CGPathCloseSubpath(curvs);
    
    CGContextAddPath(ctx, curvs);
    //CGContextClip(ctx);
    
    NSArray *gradientColorArr = [RandomObjects getRandomGradientColorArray];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef pantagon = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) gradientColorArr, NULL);
    
    CGContextClip(ctx);
   
    int randomValueForGradientType = 2;
    
    if(randomValueForGradientType % 2 == 0){
        CGContextDrawLinearGradient(ctx, pantagon, CGPointMake(0,0), CGPointMake(0, imageSize.height), 0);
    }
    else{
        CGPoint startPoint = CGPointMake(imageSize.width/2, imageSize.height/2);
        
        CGContextDrawRadialGradient(ctx, pantagon, startPoint, 0, startPoint, imageSize.width, 0);
    }
//    float rndValue = [NSNumber randomFloatInLimit:4.0f endLimit:15.0f];
    float rndValue = [NSNumber randomFloatInLimit:imageSize.width/75 endLimit:imageSize.width/20];
    CGContextSetLineWidth(ctx, rndValue);
    
    // Background Mountain Stroking
    CGContextAddPath(ctx, curvs);
    
    UIColor *borderColor = [UIColor colorWithHexString:[NSString randomHexString]];
    
    CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *img = [UIImage removeGradientColor:result];
    
    return img;
}

@end
