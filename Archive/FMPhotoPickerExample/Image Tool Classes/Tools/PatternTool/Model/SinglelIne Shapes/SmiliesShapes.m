//
//  SmiliesShapes.m
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 22/12/15.
//  Copyright © 2015 Kanwarpal Singh. All rights reserved.
//

#import "SmiliesShapes.h"
#import "RandomObjects.h"
#import "UIColor+HexColors.h"
#import "NSNumber+RandomNumberGenrator.h"
#import "GradientView.h"

@implementation SmiliesShapes

+(UIImage *)generateImage:(CGSize)imageSize{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    NSArray *colorsArr = [RandomObjects getRandomGradientColorArray];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef mountainGrad = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colorsArr, NULL);
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    int randomValueForGradientType = 2;
    
    if(randomValueForGradientType % 2 == 0){
        CGContextDrawLinearGradient(ctx, mountainGrad, CGPointMake(0,0), CGPointMake(0, imageSize.height), 0);
    }
    else{
        CGPoint startPoint = CGPointMake(imageSize.width/2, imageSize.height/2);
        
        CGContextDrawRadialGradient(ctx, mountainGrad, startPoint, 0, startPoint, imageSize.width, 0);
    }
    CGContextSetFillColorWithColor(ctx, RANDOM_COLOR.CGColor);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
    CGContextStrokePath(ctx);
    
    int randomNum = [NSNumber randomIntInLimit:0 endLimit:7];
    
    if(randomNum == 0){
        [self smily1:imageSize onContext:ctx];
    }
    else if(randomNum == 1){
        [self smily2:imageSize onContext:ctx];
    }
    else if(randomNum == 2){
        [self smily3:imageSize onContext:ctx];
    }
    else if(randomNum == 3){
        [self smily4:imageSize onContext:ctx];
    }
    else if(randomNum == 4){
        [self smily5:imageSize onContext:ctx];
    }
    else{
        [self smily1:imageSize onContext:ctx];
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+(void)smily1:(CGSize)imageSize onContext:(CGContextRef)ctx{
    CGRect leftRect = CGRectMake(200, 200, 200, 200);
    CGRect rightRect = CGRectMake(imageSize.width - 400, 200, 200, 200);
    
    float rndValue = [NSNumber randomFloatInLimit:5.0f endLimit:50.0f];
    CGContextSetLineWidth(ctx, rndValue);
    CGContextFillEllipseInRect(ctx, leftRect);
    CGContextAddEllipseInRect(ctx, leftRect);
    
    // use below line to draw color on same shape more than one
    CGContextStrokePath(ctx);
    
    CGContextFillEllipseInRect(ctx, rightRect);
    CGContextAddEllipseInRect(ctx, rightRect);
    
    CGContextMoveToPoint(ctx, 350, 700);
    CGContextAddQuadCurveToPoint(ctx, imageSize.width/2, 850, imageSize.width - 350, 700);
    CGContextStrokePath(ctx);

}

+(void)smily4:(CGSize)imageSize onContext:(CGContextRef)ctx{
    CGRect leftRect = CGRectMake(200, 200, 200, 200);
    CGRect rightRect = CGRectMake(imageSize.width - 400, 200, 200, 200);
    
    float rndValue = [NSNumber randomFloatInLimit:5.0f endLimit:50.0f];
    CGContextSetLineWidth(ctx, rndValue);
    CGContextFillEllipseInRect(ctx, leftRect);
    CGContextAddEllipseInRect(ctx, leftRect);
    
    // use below line to draw color on same shape more than one
    CGContextStrokePath(ctx);
    
    CGContextFillEllipseInRect(ctx, rightRect);
    CGContextAddEllipseInRect(ctx, rightRect);
    
    CGContextMoveToPoint(ctx, 350, 600);
    CGContextAddQuadCurveToPoint(ctx, imageSize.width/2, 880, imageSize.width - 350, 600);
    CGContextStrokePath(ctx);
    
}

+(void)smily5:(CGSize)imageSize onContext:(CGContextRef)ctx{
    CGRect leftRect = CGRectMake(200, 200, 200, 250);
    CGRect rightRect = CGRectMake(imageSize.width - 400, 200, 200,250);
    
    float rndValue = [NSNumber randomFloatInLimit:5.0f endLimit:50.0f];
    CGContextSetLineWidth(ctx, rndValue);
    CGContextFillEllipseInRect(ctx, leftRect);
    CGContextAddEllipseInRect(ctx, leftRect);
    
    // use below line to draw color on same shape more than one
    CGContextStrokePath(ctx);
    
    CGContextFillEllipseInRect(ctx, rightRect);
    CGContextAddEllipseInRect(ctx, rightRect);
    
    CGContextMoveToPoint(ctx, 180, 650);
    CGContextAddQuadCurveToPoint(ctx, imageSize.width/2, 980, imageSize.width - 180, 650);
    CGContextStrokePath(ctx);
    
}

+(void)smily2:(CGSize)imageSize onContext:(CGContextRef)ctx{
    CGRect leftRect = CGRectMake(200, 200, 270, 270);
    CGRect rightRect = CGRectMake(imageSize.width - 470, 200, 270, 270);
    
    float rndValue = [NSNumber randomFloatInLimit:5.0f endLimit:50.0f];
    CGContextSetLineWidth(ctx, rndValue);
    CGContextFillEllipseInRect(ctx, leftRect);
    CGContextAddEllipseInRect(ctx, leftRect);
    
    // use below line to draw color on same shape more than one
    CGContextStrokePath(ctx);
    
    CGContextFillEllipseInRect(ctx, rightRect);
    CGContextAddEllipseInRect(ctx, rightRect);
    
    float rndDistance = [NSNumber randomFloatInLimit:600  endLimit:750];
    float rndArcradius = [NSNumber randomFloatInLimit:150  endLimit:250];
    
    CGContextMoveToPoint(ctx, 350, rndDistance);
    CGContextAddQuadCurveToPoint(ctx, imageSize.width/2, rndDistance + rndArcradius, imageSize.width - 350, rndDistance);
    CGContextStrokePath(ctx);
    
}

+(void)smily3:(CGSize)imageSize onContext:(CGContextRef)ctx{
    float randomHeight = [NSNumber randomFloatInLimit:150 endLimit:400];
    CGRect leftRect = CGRectMake(200, 200, 200, randomHeight);
    CGRect rightRect = CGRectMake(imageSize.width - 400, 200, 200, randomHeight);
    
    float rndValue = [NSNumber randomFloatInLimit:5.0f endLimit:50.0f];
    CGContextSetLineWidth(ctx, rndValue);
    CGContextFillEllipseInRect(ctx, leftRect);
    CGContextAddEllipseInRect(ctx, leftRect);
    
    // use below line to draw color on same shape more than one
    CGContextStrokePath(ctx);
    
    CGContextFillEllipseInRect(ctx, rightRect);
    CGContextAddEllipseInRect(ctx, rightRect);
    
    float randomDistance = [NSNumber randomFloatInLimit:150 endLimit:400];
    
    CGContextMoveToPoint(ctx, 350, randomHeight + randomDistance + 200);
    CGContextAddQuadCurveToPoint(ctx, imageSize.width/2, 850, imageSize.width - 350, randomHeight + randomDistance + 200);
    CGContextStrokePath(ctx);
    
}


@end
