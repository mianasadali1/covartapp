//
//  SingleLineArcShapeWithTexture.m
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 10/01/16.
//  Copyright © 2016 Kanwarpal Singh. All rights reserved.
//

#import "SingleLineArcShapeWithTexture.h"
#import "RandomObjects.h"
#import "NSNumber+RandomNumberGenrator.h"
#import "UIColor+HexColors.h"
#import "NSString+RandomStringGenrator.h"
#import "UIImage+Utility.h"

@implementation SingleLineArcShapeWithTexture

+(UIImage *)generateImage:(CGSize)imageSize effectId:(int)effectId{
    //55    
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
    
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float randomValueCofficeint = [NSNumber randomFloatInLimit:0.20 endLimit:0.40];
    
    float rndArcHeight = imageSize.height*randomValueCofficeint;
    
    float randomRadiousCofficeint = [RandomObjects getRandomArcRadiusSize];
    
    float rndRadiousHeight = rndArcHeight*randomRadiousCofficeint * 2 ;
    
    int rndArcNumbers = [NSNumber randomIntInLimit:0 endLimit:10];
    
    float rndValue = [NSNumber randomFloatInLimit:4.0f endLimit:15.0f];
    CGContextSetLineWidth(ctx, rndValue);
    
    if(rndArcNumbers %2 == 0){
        rndArcHeight = rndArcHeight / 1.5;
        rndRadiousHeight = rndRadiousHeight /1.5;
        //Top Arc
        float topStartYPt =  rndArcHeight;
        
        CGPathMoveToPoint(curvs, nil, -rndValue, topStartYPt);
        
        CGPathAddQuadCurveToPoint(curvs, nil, imageSize.width/2, topStartYPt - rndRadiousHeight, imageSize.width + rndValue, topStartYPt);
        
        float bottomStartYPt = imageSize.height - rndArcHeight;
        
        CGPathAddLineToPoint(curvs, nil, imageSize.width + rndValue, bottomStartYPt);
        
        CGPathAddQuadCurveToPoint(curvs, nil, imageSize.width/2, bottomStartYPt + rndRadiousHeight, -rndValue, bottomStartYPt);
        
        CGPathAddLineToPoint(curvs, nil,-rndValue, topStartYPt);
    }
    else{
        
        int rndArcPosition = [NSNumber randomIntInLimit:1 endLimit:10];
        
        if(rndArcPosition %2 == 0){
            //Top Arc
            float startYPt =  rndArcHeight;
            
            CGPathMoveToPoint(curvs, nil, 0, startYPt);
            
            CGPathAddQuadCurveToPoint(curvs, nil, imageSize.width/2, startYPt - rndRadiousHeight, imageSize.width, startYPt);
            
            CGPathAddLineToPoint(curvs, nil, imageSize.width + 20, startYPt);
            
            CGPathAddLineToPoint(curvs, nil, imageSize.width + 20, imageSize.height + 20);
            
            CGPathAddLineToPoint(curvs, nil, - 20, imageSize.height + 20);
            
            CGPathAddLineToPoint(curvs, nil, - 20, startYPt);
        }
        else{
            
            float startYPt = imageSize.height - rndArcHeight;
            
            CGPathMoveToPoint(curvs, nil, 0, startYPt);
            
            CGPathAddQuadCurveToPoint(curvs, nil, imageSize.width/2, startYPt + rndRadiousHeight, imageSize.width, startYPt);
            
            CGPathAddLineToPoint(curvs, nil, imageSize.width + 20, startYPt);
            
            CGPathAddLineToPoint(curvs, nil, imageSize.width + 20, - 20);
            
            CGPathAddLineToPoint(curvs, nil, - 20, - 20);
            
            CGPathAddLineToPoint(curvs, nil, - 20, startYPt);
        }
    }
    
    CGPathCloseSubpath(curvs);
    
    CGContextAddPath(ctx, curvs);
   // CGContextClip(ctx);
    
    NSArray *gradientColorArr = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor, nil];
    
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
