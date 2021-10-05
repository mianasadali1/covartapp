//
//  SingleLineShapes.m
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 05/12/15.
//  Copyright © 2015 Kanwarpal Singh. All rights reserved.
//

#import "SingleLineShapes.h"
#import "RandomObjects.h"
#import "UIColor+HexColors.h"
#import "NSNumber+RandomNumberGenrator.h"
#import "GradientView.h"
#import "UIImage+Utility.h"
#import "UIColor+HexColors.h"
#import "NSString+RandomStringGenrator.h"

@implementation SingleLineShapes

//****************************************** create geomatary shapes ***************************************//

#pragma mark pantagon shape

+(UIImage *)generateNoShapeImage:(CGSize)imageSize effectId:(NSUInteger)effectId{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    NSArray *colorsArr = [RandomObjects getRandomGradientColorArrayFoNoShape];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef mountainGrad = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colorsArr, NULL);
    CGContextDrawLinearGradient(ctx, mountainGrad, CGPointMake(0,0), CGPointMake(0, imageSize.height), 0);

    // CGContextClip(ctx);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // UIImage *img = [UIImage removeGradientColor:result];
    
    return result;
}

+(UIImage *)generateImageAsWindow:(CGSize)imageSize effectId:(NSUInteger)effectId{
    //int rndForShape = [NSNumber randomIntInLimit:0 endLimit:10];
    int rndForShape = effectId;
    
    UIImage *img;
    
    if(rndForShape == 6){
        //26
        img = [self createTriangleShapeWithsizeEqualToImage:imageSize];
    }
    else if(rndForShape == 7){
        //27
        img = [self createVariableTriangleShape:imageSize];
    }
    else if(rndForShape == 8){
        //28
        img = [self createFlipShape:imageSize];
    }
    else if(rndForShape == 9){
        //29
        img = [self createPageDividerShape:imageSize];
    }
    else if(rndForShape == 10){
        //31
        img = [self createDiamondShape:imageSize asWindow:NO];
    }
    else if(rndForShape == 11){
        //32
        img = [self createVariableCircleShape:imageSize];
    }
    else if(rndForShape == 12){
        //33
        img = [self createVariableOvelShape:imageSize];
    }
    else if(rndForShape == 31){
        //34
        img = [self createAllShapesWithGradientOrSingleColor:imageSize randomShapeType:1];
    }
    else if(rndForShape == 32){
        //35
        img = [self createAllShapesWithGradientOrSingleColor:imageSize randomShapeType:2];
    }
    else if(rndForShape == 33){
        //36
        img = [self createAllShapesWithGradientOrSingleColor:imageSize randomShapeType:3];
    }
    else {
        img = [self createAllShapesWithGradientOrSingleColor:imageSize randomShapeType:1];
    }
    
    return img;
}

+(UIImage *)generateImage:(CGSize)imageSize effectId:(NSUInteger)effectId{
    int rndForShape = effectId;
    //int rndForShape = 10;
    
    UIImage *img;
    
    if(rndForShape == 24){
        //16
        img = [self createPantagonShape:imageSize];
    }
    else if(rndForShape == 25){
        //17
        img = [self createHexgonShape:imageSize];
    }
    //    else if(rndForShape == 18){
    //        //18
    //        img = [self createAllShapesWithGradientOrSingleColor:imageSize randomShapeType:2];
    //    }
    else if(rndForShape == 26){
        //19
        img = [self createTwoSquareViewImage:imageSize];
    }
    else if(rndForShape == 27){
        //20
        img = [self createTriangleShape:imageSize];
    }
    else if(rndForShape == 28){
        //21
        img = [self createDiamondShape:imageSize asWindow:YES];
    }
    else if(rndForShape == 29){
        //22
        img = [self createVariableEmptyCircleShape:imageSize];
    }
    else if(rndForShape == 30){
        //23
        img = [self createVariableEmptyOvelShape:imageSize];
    }
    //    else if(rndForShape == 24){
    //        //24
    //        img = [self createAllShapesWithGradientOrSingleColor:imageSize randomShapeType:2];
    //    }
    //    else if(rndForShape == 25){
    //        //25
    //        img = [self createAllShapesWithGradientOrSingleColor:imageSize randomShapeType:3];
    //    }
    //    else {
    //        img = [self createAllShapesWithGradientOrSingleColor:imageSize randomShapeType:1];
    //    }
    
    return img;
}

//************************* Create 2 square images ***********************************//

#pragma mark - 2 square shape

+(UIImage *)createTwoSquareViewImage:(CGSize)imageSize{
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0, 0);
    
    float minSquareSize = MIN(imageSize.width, imageSize.height)/1.5;
    
    float squareSideCoficient = [RandomObjects getRandomSize:NO];
    
    float squareSide = minSquareSize*squareSideCoficient;
    
    GradientView *v = [[GradientView alloc]initWithFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    [v.layer renderInContext:ctx];
    
    float rndValue = [NSNumber randomFloatInLimit:0.0 endLimit:imageSize.width/80];
//    float rndValue = [NSNumber randomFloatInLimit:0.0f endLimit:10.0f];
    CGContextSetLineWidth(ctx, rndValue);
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
    
    float radiusRandomValue = squareSide/2;
    
    float squareStartXPt = (imageSize.width - (squareSide + squareSide/2))/2;
    float squareStartYPt = (imageSize.height - (squareSide + squareSide/2))/2;
    
    CGRect rectangle1;
    CGRect rectangle2;
    
    int rndSquarwPosition = [NSNumber randomIntInLimit:1 endLimit:10];
    
    if(rndSquarwPosition %2 == 0){
        rectangle1 = CGRectMake(squareStartXPt,squareStartYPt,squareSide,squareSide);
        rectangle2 = CGRectMake(squareStartXPt + (squareSide/2),squareStartYPt + (squareSide/2),squareSide,squareSide);
    }
    else{
        rectangle1 = CGRectMake(squareStartXPt + (squareSide/2),squareStartYPt ,squareSide,squareSide);
        rectangle2 = CGRectMake(squareStartXPt,squareStartYPt + (squareSide/2),squareSide,squareSide);
    }
    
    int randomShapeType = [NSNumber randomIntInLimit:1 endLimit:10];
    
    if(randomShapeType %2 == 0){
        [self drawRoundedCornerShapes:rectangle1 onContext:ctx withRadius1:0 withRadius2:0];
        [self drawRoundedCornerShapes:rectangle2 onContext:ctx withRadius1:0 withRadius2:0];
    }
    else {
        float getRandomWidthRadiusFloatValue = [RandomObjects getRandomRadiusSize];
        float getRandomHeightRadiusFloatValue = [RandomObjects getRandomRadiusSize];
        
        int roundRadius1 = radiusRandomValue*getRandomWidthRadiusFloatValue;
        int roundRadius2 = radiusRandomValue*getRandomHeightRadiusFloatValue;
        
        int rounConrnerType = [NSNumber randomIntInLimit:1 endLimit:7];
        
        if(rounConrnerType == 1){
            int maxRadius = MIN(roundRadius1, MIN(roundRadius1, roundRadius2));
            [self drawRoundedCornerShapes:rectangle1 onContext:ctx withRadius1:maxRadius withRadius2:maxRadius];
            [self drawRoundedCornerShapes:rectangle2 onContext:ctx withRadius1:maxRadius withRadius2:maxRadius];
        }
        if(rounConrnerType == 2){
            int randomNum = [NSNumber randomIntInLimit:1 endLimit:10];
            if(randomNum % 2 == 0){
                [self drawRoundedCornerShapes:rectangle1 onContext:ctx withRadius1:roundRadius1 withRadius2:roundRadius2];
                [self drawRoundedCornerShapes:rectangle2 onContext:ctx withRadius1:roundRadius1 withRadius2:roundRadius2];
            }
            else {
                [self drawRoundedCornerShapes:rectangle1 onContext:ctx withRadius1:roundRadius2 withRadius2:roundRadius1];
                [self drawRoundedCornerShapes:rectangle2 onContext:ctx withRadius1:roundRadius2 withRadius2:roundRadius1];
            }
        }
        if(rounConrnerType >= 3){
            int randomNum = [NSNumber randomIntInLimit:1 endLimit:10];
            if(randomNum % 2 == 0){
                [self drawRoundedCornerShapes:rectangle1 onContext:ctx withRadius1:roundRadius1 withRadius2:0];
                [self drawRoundedCornerShapes:rectangle2 onContext:ctx withRadius1:roundRadius1 withRadius2:0];
            }
            else {
                [self drawRoundedCornerShapes:rectangle1 onContext:ctx withRadius1:0 withRadius2:roundRadius1];
                [self drawRoundedCornerShapes:rectangle2 onContext:ctx withRadius1:0 withRadius2:roundRadius1];
            }
        }
    }
    
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *img = [UIImage removeWhiteColor:result];
    
    return img;
}

+(UIImage *)createFlipShape:(CGSize)imageSize{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
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
    
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    int isBorderRequired = [NSNumber randomIntInLimit:0 endLimit:2];
    
    if(isBorderRequired){
        int rndValue = [NSNumber randomIntInLimit:0 endLimit:10];
        CGContextSetLineWidth(ctx, rndValue);
        [self drawflip:imageSize onCurv:curvs lineWidth:rndValue];
    }
    else{
        [self drawflip:imageSize onCurv:curvs lineWidth:0];
    }
    
    UIColor *borderColor = [UIColor colorWithHexString:[NSString randomHexString]];
    
    CGPathCloseSubpath(curvs);
    
    CGContextAddPath(ctx, curvs);
   // CGContextClip(ctx);
    
    NSArray *gradientColorArr = [RandomObjects getRandomGradientColorArray];
    CGGradientRef pantagon = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) gradientColorArr, NULL);
    
    CGContextClip(ctx);
    
    if(randomValueForGradientType % 2 == 0){
        CGContextDrawLinearGradient(ctx, pantagon, CGPointMake(0,0), CGPointMake(0, imageSize.height), 0);
    }
    else{
        CGPoint startPoint = CGPointMake(imageSize.width/2, imageSize.height/2);
        
        CGContextDrawRadialGradient(ctx, mountainGrad, startPoint, 0, startPoint, imageSize.width, 0);
    }
    // Background Mountain Stroking
    CGContextAddPath(ctx, curvs);
    
    CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+(UIImage *)createPageDividerShape:(CGSize)imageSize{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
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
    //CGMutablePathRef curvs = CGPathCreateMutable();
    
    int isBorderRequired = 1;
    
    if(isBorderRequired){
        int rndValue = [NSNumber randomIntInLimit:0 endLimit:10];
        CGContextSetLineWidth(ctx, rndValue);
        CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
        CGRect lowerPartRect = CGRectMake(-rndValue, imageSize.height/2, imageSize.width + rndValue, imageSize.height/2 + rndValue);
        CGRect topPartRect = CGRectMake(-rndValue, -rndValue, imageSize.width +rndValue, imageSize.height/2);
        CGRect leftPartRect = CGRectMake(-rndValue, -rndValue, imageSize.width/2, imageSize.height +rndValue);
        CGRect rightPartRect = CGRectMake(imageSize.width/2, -rndValue, imageSize.width/2 + rndValue, imageSize.height + rndValue);
        
        int randomPosition = [NSNumber randomIntInLimit:0 endLimit:5];
        
        if(randomPosition == 1){
            [self drawSquareAtRect:topPartRect onContext:ctx] ;
        }
        else if(randomPosition == 2){
            [self drawSquareAtRect:lowerPartRect onContext:ctx] ;
        }
        else if(randomPosition == 3){
            [self drawSquareAtRect:leftPartRect onContext:ctx] ;
        }
        else{
            [self drawSquareAtRect:rightPartRect onContext:ctx] ;
        }
    }
    else{
        CGRect lowerPartRect = CGRectMake(0, imageSize.height/2, imageSize.width, imageSize.height/2);
        CGRect topPartRect = CGRectMake(0, 0, imageSize.width, imageSize.height/2);
        CGRect leftPartRect = CGRectMake(0, 0, imageSize.width/2, imageSize.height);
        CGRect rightPartRect = CGRectMake(imageSize.width/2, 0, imageSize.width/2, imageSize.height);
        
        int randomPosition = [NSNumber randomIntInLimit:0 endLimit:5];
        
        if(randomPosition == 1){
            [self drawSquareAtRect:topPartRect onContext:ctx] ;
        }
        else if(randomPosition == 2){
            [self drawSquareAtRect:lowerPartRect onContext:ctx] ;
        }
        else if(randomPosition == 3){
            [self drawSquareAtRect:leftPartRect onContext:ctx] ;
        }
        else{
            [self drawSquareAtRect:rightPartRect onContext:ctx] ;
        }
        
    }
    
    // CGPathCloseSubpath(curvs);
    
    //CGContextAddPath(ctx, curvs);
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+(void)drawSquareAtRect:(CGRect)rect onContext:(CGContextRef)ctx{
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
    CGContextSetFillColorWithColor(ctx, RANDOM_COLOR.CGColor);
    CGContextFillRect(ctx, rect);
}

+(void)drawflip:(CGSize)imageSize onCurv:(CGMutablePathRef)curvs lineWidth:(float)lineWidth{
    int randomPosition = [NSNumber randomIntInLimit:0 endLimit:2];
    
    if(randomPosition == 1){
        float topEdgeStartXPt           =   -lineWidth ;
        float topEdgeStartYPt           =   -lineWidth ;
        
        float bottonLeftEdgeStartXPt    =   -lineWidth ;
        float bottonLeftEdgeStartYPt    =   imageSize.height + lineWidth ;
        
        float bottonRightEdgeStartXPt    =   imageSize.width + lineWidth;
        float bottonRightEdgeStartYPt    =   imageSize.height + lineWidth;
        
        CGPathMoveToPoint(curvs, nil, topEdgeStartXPt, topEdgeStartYPt);
        CGPathAddLineToPoint(curvs, nil, bottonLeftEdgeStartXPt, bottonLeftEdgeStartYPt);
        CGPathAddLineToPoint(curvs, nil, bottonRightEdgeStartXPt, bottonRightEdgeStartYPt);
        CGPathAddLineToPoint(curvs, nil, topEdgeStartXPt, topEdgeStartYPt);
    }
    else{
        float topEdgeStartXPt           =   imageSize.width + lineWidth;
        float topEdgeStartYPt           =   - lineWidth;
        
        float bottonLeftEdgeStartXPt    =   - lineWidth ;
        float bottonLeftEdgeStartYPt    =   imageSize.height + lineWidth;
        
        float bottonRightEdgeStartXPt    =   imageSize.width + lineWidth;
        float bottonRightEdgeStartYPt    =   imageSize.height + lineWidth;
        
        CGPathMoveToPoint(curvs, nil, topEdgeStartXPt, topEdgeStartYPt);
        CGPathAddLineToPoint(curvs, nil, bottonLeftEdgeStartXPt, bottonLeftEdgeStartYPt);
        CGPathAddLineToPoint(curvs, nil, bottonRightEdgeStartXPt, bottonRightEdgeStartYPt);
        CGPathAddLineToPoint(curvs, nil, topEdgeStartXPt, topEdgeStartYPt);
    }
}

+(UIImage *)createVariableCircleShape:(CGSize)imageSize{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
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

    CGContextSetFillColorWithColor(ctx, RANDOM_COLOR.CGColor);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
   // float rndValue = [NSNumber randomFloatInLimit:5.0f endLimit:20.0f];
    float rndValue = [NSNumber randomFloatInLimit:imageSize.width/75 endLimit:imageSize.width/20];
    CGContextSetLineWidth(ctx, rndValue);
    
    float getRandomCoffFloatValue   =   [NSNumber randomFloatInLimit:0.55 endLimit:2.10];
    int randomPosition = [NSNumber randomIntInLimit:0 endLimit:5];
    
    float rndLineWidthValue = [NSNumber randomFloatInLimit:1.0f endLimit:5.0f];
    CGRect rectangle;
    
    if(randomPosition == 1){
        float radiusRandomValue    =   imageSize.height*getRandomCoffFloatValue;
        
        rectangle = CGRectMake(0,-radiusRandomValue/2,imageSize.width,radiusRandomValue);
        
    }
    else if(randomPosition == 2){
        float radiusRandomValue    =   imageSize.height*getRandomCoffFloatValue;
        rectangle = CGRectMake(0,imageSize.height - radiusRandomValue/2,imageSize.width,radiusRandomValue);
        
    }
    else if(randomPosition == 3){
        float radiusRandomValue    =   imageSize.width*getRandomCoffFloatValue;
        rectangle = CGRectMake(-radiusRandomValue/2,0,radiusRandomValue,imageSize.height);
        
    }
    else{
        float radiusRandomValue    =   imageSize.width*getRandomCoffFloatValue;
        rectangle = CGRectMake(imageSize.width - radiusRandomValue/2,0,radiusRandomValue,imageSize.height);
    }
    
    CGContextSetLineWidth(ctx, rndLineWidthValue);
    CGContextFillEllipseInRect(ctx, rectangle);
    CGContextAddEllipseInRect(ctx, rectangle);
    
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+(UIImage *)createVariableEmptyCircleShape:(CGSize)imageSize{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
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
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    //CGContextSetFillColorWithColor(ctx, RANDOM_COLOR.CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
    
//    float rndValue = [NSNumber randomFloatInLimit:5.0f endLimit:20.0f];
    float rndValue = [NSNumber randomFloatInLimit:imageSize.width/75 endLimit:imageSize.width/20];
    CGContextSetLineWidth(ctx, rndValue);
    
    float getRandomCoffFloatValue   =   [NSNumber randomFloatInLimit:1.25 endLimit:2.10];
    int randomPosition = [NSNumber randomIntInLimit:0 endLimit:5];
    
    float rndLineWidthValue = [NSNumber randomFloatInLimit:1.0f endLimit:5.0f];
    CGRect rectangle;
    
    if(randomPosition == 1){
        float radiusRandomValue    =   imageSize.height*getRandomCoffFloatValue;
        rectangle = CGRectMake(0,imageSize.height - radiusRandomValue/2,imageSize.width,radiusRandomValue);
        
    }
    else if(randomPosition == 2){
        float radiusRandomValue    =   imageSize.width*getRandomCoffFloatValue;
        rectangle = CGRectMake(-radiusRandomValue/2,0,radiusRandomValue,imageSize.height);
        
    }
    else{
        float radiusRandomValue    =   imageSize.width*getRandomCoffFloatValue;
        rectangle = CGRectMake(imageSize.width - radiusRandomValue/2,0,radiusRandomValue,imageSize.height);
    }
    
    CGContextSetLineWidth(ctx, rndLineWidthValue);
    CGContextFillEllipseInRect(ctx, rectangle);
    CGContextAddEllipseInRect(ctx, rectangle);
    
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    result = [UIImage removeWhiteColor:result];
    UIGraphicsEndImageContext();
    return result;
}


+(UIImage *)createVariableOvelShape:(CGSize)imageSize{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
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

    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    CGContextSetFillColorWithColor(ctx, RANDOM_COLOR.CGColor);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
    
//    float rndValue = [NSNumber randomFloatInLimit:5.0f endLimit:20.0f];
    float rndValue = [NSNumber randomFloatInLimit:imageSize.width/75 endLimit:imageSize.width/20];
    CGContextSetLineWidth(ctx, rndValue);
    
    float getRandomCoffFloatValue   =   [NSNumber randomFloatInLimit:0.55 endLimit:2.10];
    float getRandomCoffFloatValue1  =   [NSNumber randomFloatInLimit:1.00 endLimit:1.50];
    
    int randomPosition = [NSNumber randomIntInLimit:0 endLimit:5];
    
    float rndLineWidthValue = [NSNumber randomFloatInLimit:1.0f endLimit:5.0f];
    CGRect rectangle;
    
    if(randomPosition == 1){
        float radiusRandomValue    =   imageSize.height*getRandomCoffFloatValue;
        float radiusRandomValue1    =   imageSize.width*getRandomCoffFloatValue1;
        
        rectangle = CGRectMake(0,-radiusRandomValue/2,radiusRandomValue1,radiusRandomValue);
    }
    else if(randomPosition == 2){
        float radiusRandomValue    =   imageSize.height*getRandomCoffFloatValue;
        float radiusRandomValue1    =   imageSize.width*getRandomCoffFloatValue1;
        rectangle = CGRectMake(0,imageSize.height - radiusRandomValue/2,radiusRandomValue1,radiusRandomValue);
        
    }
    else if(randomPosition == 3){
        float radiusRandomValue    =   imageSize.width*getRandomCoffFloatValue;
        float radiusRandomValue1    =   imageSize.height*getRandomCoffFloatValue1;
        rectangle = CGRectMake(-radiusRandomValue/2,0,radiusRandomValue,radiusRandomValue1);
    }
    else{
        float radiusRandomValue    =   imageSize.width*getRandomCoffFloatValue;
        float radiusRandomValue1    =   imageSize.height*getRandomCoffFloatValue1;
        rectangle = CGRectMake(imageSize.width - radiusRandomValue/2,0,radiusRandomValue,radiusRandomValue1);
    }
    
    CGContextSetLineWidth(ctx, rndLineWidthValue);
    CGContextFillEllipseInRect(ctx, rectangle);
    CGContextAddEllipseInRect(ctx, rectangle);
    
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+(UIImage *)createVariableEmptyOvelShape:(CGSize)imageSize{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    NSArray *colorsArr = [RandomObjects getRandomGradientColorArray];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef mountainGrad = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colorsArr, NULL);
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    //CGContextClip(ctx);

    int randomValueForGradientType = 2;
    
    if(randomValueForGradientType % 2 == 0){
        CGContextDrawLinearGradient(ctx, mountainGrad, CGPointMake(0,0), CGPointMake(0, imageSize.height), 0);
    }
    else{
        CGPoint startPoint = CGPointMake(imageSize.width/2, imageSize.height/2);
        
        CGContextDrawRadialGradient(ctx, mountainGrad, startPoint, 0, startPoint, imageSize.width, 0);
    }

    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
    
//    float rndValue = [NSNumber randomFloatInLimit:5.0f endLimit:20.0f];
    float rndValue = [NSNumber randomFloatInLimit:imageSize.width/75 endLimit:imageSize.width/20];
    CGContextSetLineWidth(ctx, rndValue);
    
    float getRandomCoffFloatValue   =   [NSNumber randomFloatInLimit:1.0 endLimit:2.10];
    float getRandomCoffFloatValue1  =   [NSNumber randomFloatInLimit:1.20 endLimit:1.50];
    
    int randomPosition = [NSNumber randomIntInLimit:0 endLimit:5];
    
    float rndLineWidthValue = [NSNumber randomFloatInLimit:1.0f endLimit:5.0f];
    CGRect rectangle;
    
    if(randomPosition == 1){
        float radiusRandomValue    =   imageSize.height*getRandomCoffFloatValue;
        float radiusRandomValue1    =   imageSize.width*getRandomCoffFloatValue1;
        rectangle = CGRectMake(0,imageSize.height - radiusRandomValue/2,radiusRandomValue1,radiusRandomValue);
        
    }
    else if(randomPosition == 2){
        float radiusRandomValue    =   imageSize.width*getRandomCoffFloatValue;
        float radiusRandomValue1    =   imageSize.height*getRandomCoffFloatValue1;
        rectangle = CGRectMake(-radiusRandomValue/2,0,radiusRandomValue,radiusRandomValue1);
    }
    else{
        float radiusRandomValue    =   imageSize.width*getRandomCoffFloatValue;
        float radiusRandomValue1    =   imageSize.height*getRandomCoffFloatValue1;
        rectangle = CGRectMake(imageSize.width - radiusRandomValue/2,0,radiusRandomValue,radiusRandomValue1);
    }
    
    CGContextSetLineWidth(ctx, rndLineWidthValue);
    CGContextFillEllipseInRect(ctx, rectangle);
    CGContextAddEllipseInRect(ctx, rectangle);
    
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    result = [UIImage removeWhiteColor:result];
    UIGraphicsEndImageContext();
    return result;
}

+(UIImage *)createVariableTriangleShape:(CGSize)imageSize{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
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

    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float randomHeightForTriangle = [NSNumber randomFloatInLimit:80.0f endLimit:imageSize.height *1.5];
    
    int randomPositionForTriangle = [NSNumber randomIntInLimit:0 endLimit:5];
    
    if(randomPositionForTriangle == 1){
        [self drawFourTriangleOnContext:ctx onCurv:curvs firstPt:CGPointMake(0, 0) secontPt:CGPointMake(imageSize.width, 0) thirdPt:CGPointMake(imageSize.width/2, randomHeightForTriangle) imgSize:imageSize];
    }
    else if(randomPositionForTriangle == 2){
        [self drawFourTriangleOnContext:ctx onCurv:curvs firstPt:CGPointMake(0, 0) secontPt:CGPointMake(randomHeightForTriangle, imageSize.height/2) thirdPt:CGPointMake(0, imageSize.height) imgSize:imageSize];
    }
    else if(randomPositionForTriangle == 3){
        [self drawFourTriangleOnContext:ctx onCurv:curvs firstPt:CGPointMake(0, imageSize.height) secontPt:CGPointMake(imageSize.width/2, imageSize.height - randomHeightForTriangle) thirdPt:CGPointMake(imageSize.width, imageSize.height) imgSize:imageSize];
    }
    else{
        [self drawFourTriangleOnContext:ctx onCurv:curvs firstPt:CGPointMake(imageSize.width, imageSize.height) secontPt:CGPointMake(imageSize.width - randomHeightForTriangle, imageSize.height/2) thirdPt:CGPointMake(imageSize.width, 0) imgSize:imageSize];
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+(void)drawFourTriangleOnContext:(CGContextRef)ctx onCurv:(CGMutablePathRef)curvs firstPt:(CGPoint)firstPt secontPt:(CGPoint)secontPt thirdPt:(CGPoint)thirdPt imgSize:(CGSize)imgSize{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    float topLeftEdgeStartXPt           =   firstPt.x ;
    float topLeftEdgeStartYPt           =   firstPt.y;
    
    float topRightEdgeStartXPt          =   secontPt.x;
    float topRightEdgeStartYPt          =   secontPt.y;
    
    float centerXPoint                  =   thirdPt.x;
    float centerYPoint                  =   thirdPt.y;
    
    CGPathMoveToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topRightEdgeStartXPt, topRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, centerXPoint, centerYPoint);
    CGPathAddLineToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGPathCloseSubpath(curvs);
    CGContextAddPath(ctx, curvs);
    CGContextClip(ctx);
    
    NSArray *colorsArr = [RandomObjects getRandomGradientColorArray];
    NSArray *gradientColorArr = colorsArr;
    CGGradientRef pantagon = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) gradientColorArr, NULL);
    
    
    int randomValueForGradientType = 2;
    
    if(randomValueForGradientType % 2 == 0){
        CGContextDrawLinearGradient(ctx, pantagon, CGPointMake(0,0), CGPointMake(0, imgSize.height), 0);
    }
    else{
        CGPoint startPoint = CGPointMake(imgSize.width/2, imgSize.height/2);
        
        CGContextDrawRadialGradient(ctx, pantagon, startPoint, 0, startPoint, imgSize.width, 0);
    }

    
    CGContextStrokePath(ctx);
}

+(UIImage *)createThreeTriangleShape:(CGSize)imageSize{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self createBottomTriangle:imageSize randomCoff:1 onContext:ctx] ;
    [self createLeftSideTriangleLikePart:imageSize randomCoff:1 onContext:ctx] ;
    [self createRightSideTriangleLikePart:imageSize randomCoff:1 onContext:ctx] ;
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+(UIImage *)createTriangleShape:(CGSize)imageSize{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
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
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    int randomNumberForTriangleType = [NSNumber randomIntInLimit:0 endLimit:5];
    
    if (randomNumberForTriangleType == 1) {
        float randomValueCofficeint = [NSNumber randomFloatInLimit:1.0 endLimit:1.50];
        [self createBottomTriangle:imageSize onCurv:curvs randomCoff:randomValueCofficeint];
    }
    else if(randomNumberForTriangleType == 2){
        [self createTopTriangle:imageSize onCurv:curvs];
    }
    else {
        float randomValueCofficeint = [NSNumber randomFloatInLimit:1.00 endLimit:1.50];
        [self createBottomTriangle:imageSize onCurv:curvs randomCoff:randomValueCofficeint];
    }
    
    UIColor *borderColor = [UIColor colorWithHexString:[NSString randomHexString]];
    
    CGPathCloseSubpath(curvs);
    
    CGContextAddPath(ctx, curvs);
    CGContextClip(ctx);
    
    NSArray *gradientColorArr = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor, nil];
    CGGradientRef pantagon = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) gradientColorArr, NULL);
    
    
    if(randomValueForGradientType % 2 == 0){
        CGContextDrawLinearGradient(ctx, pantagon, CGPointMake(0,0), CGPointMake(0, imageSize.height), 0);
    }
    else{
        CGPoint startPoint = CGPointMake(imageSize.width/2, imageSize.height/2);
        
        CGContextDrawRadialGradient(ctx, mountainGrad, startPoint, 0, startPoint, imageSize.width, 0);
    }
    
    //float rndValue = [NSNumber randomFloatInLimit:0.0f endLimit:20.0f];
    float rndValue = [NSNumber randomFloatInLimit:0.0 endLimit:imageSize.width/60];
    CGContextSetLineWidth(ctx, rndValue);
    
    // Background Mountain Stroking
    CGContextAddPath(ctx, curvs);
    
    CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *img = [UIImage removeGradientColor:result];
    
    return img;
}

+(UIImage *)createTriangleShapeWithsizeEqualToImage:(CGSize)imageSize{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
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
    
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    int randomNumberForTriangleType = [NSNumber randomIntInLimit:0 endLimit:5];
    
    if (randomNumberForTriangleType == 1) {
        [self createBottomTriangle:imageSize onCurv:curvs randomCoff:1];
    }
    else if(randomNumberForTriangleType == 2){
        [self createTopTriangle:imageSize onCurv:curvs randomCoff:1];
    }
    else if(randomNumberForTriangleType == 3){
        [self createLeftTriangle:imageSize onCurv:curvs randomCoff:1];
    }
    else if(randomNumberForTriangleType == 4){
        [self createRightTriangle:imageSize onCurv:curvs randomCoff:1];
    }
    else {
        float randomValueCofficeint = 1;
        [self createBottomTriangle:imageSize onCurv:curvs randomCoff:randomValueCofficeint];
    }
    
    UIColor *borderColor = [UIColor colorWithHexString:[NSString randomHexString]];
    
    CGPathCloseSubpath(curvs);
    
    CGContextAddPath(ctx, curvs);
    CGContextClip(ctx);
    
    NSArray *gradientColorArr = [RandomObjects getRandomGradientColorArray];
    CGGradientRef pantagon = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) gradientColorArr, NULL);
    
    
    if(randomValueForGradientType % 2 == 0){
        CGContextDrawLinearGradient(ctx, pantagon, CGPointMake(0,0), CGPointMake(0, imageSize.height), 0);
    }
    else{
        CGPoint startPoint = CGPointMake(imageSize.width/2, imageSize.height/2);
        
        CGContextDrawRadialGradient(ctx, mountainGrad, startPoint, 0, startPoint, imageSize.width, 0);
    }
    
    // Background Mountain Stroking
    CGContextAddPath(ctx, curvs);
    
    CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // UIImage *img = [UIImage removeGradientColor:result];
    
    return result;
}

+(void)createTopTriangle:(CGSize)imageSize onCurv:(CGMutablePathRef)curvs{
    float randomValueCofficeint = [NSNumber randomFloatInLimit:1.20 endLimit:1.50];
    
    float rndShapeHorizontalWidth   = imageSize.width*randomValueCofficeint;
    
    float rndShapeVerticalHeight    = imageSize.height*randomValueCofficeint;;
    
    float topEdgeStartXPt           =   imageSize.width/2;
    float topEdgeStartYPt           =   (imageSize.height - rndShapeVerticalHeight)/2;
    
    float bottonLeftEdgeStartXPt    =   (imageSize.width - rndShapeHorizontalWidth)/2 ;
    float bottonLeftEdgeStartYPt    =   topEdgeStartYPt +  rndShapeVerticalHeight;
    
    float bottonRightEdgeStartXPt    =   bottonLeftEdgeStartXPt +  rndShapeHorizontalWidth;
    float bottonRightEdgeStartYPt    =   bottonLeftEdgeStartYPt;
    
    CGPathMoveToPoint(curvs, nil, topEdgeStartXPt, topEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottonLeftEdgeStartXPt, bottonLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottonRightEdgeStartXPt, bottonRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topEdgeStartXPt, topEdgeStartYPt);
}

+(void)createTopTriangle:(CGSize)imageSize onCurv:(CGMutablePathRef)curvs randomCoff:(float)randomValueCofficeint{
    float rndShapeHorizontalWidth   = imageSize.width*randomValueCofficeint;
    
    float rndShapeVerticalHeight    = imageSize.height*randomValueCofficeint;;
    
    float topEdgeStartXPt           =   imageSize.width/2;
    float topEdgeStartYPt           =   (imageSize.height - rndShapeVerticalHeight)/2;
    
    float bottonLeftEdgeStartXPt    =   (imageSize.width - rndShapeHorizontalWidth)/2 ;
    float bottonLeftEdgeStartYPt    =   topEdgeStartYPt +  rndShapeVerticalHeight;
    
    float bottonRightEdgeStartXPt    =   bottonLeftEdgeStartXPt +  rndShapeHorizontalWidth;
    float bottonRightEdgeStartYPt    =   bottonLeftEdgeStartYPt;
    
    CGPathMoveToPoint(curvs, nil, topEdgeStartXPt, topEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottonLeftEdgeStartXPt, bottonLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottonRightEdgeStartXPt, bottonRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topEdgeStartXPt, topEdgeStartYPt);
}

+(void)createBottomTriangle:(CGSize)imageSize onCurv:(CGMutablePathRef)curvs randomCoff:(float)randomValueCofficeint{
    
    float rndShapeHorizontalWidth       =   imageSize.width*randomValueCofficeint;
    
    float rndShapeVerticalHeight        =   imageSize.height*randomValueCofficeint;;
    
    float topLeftEdgeStartXPt           =   (imageSize.width - rndShapeHorizontalWidth)/2 ;
    float topLeftEdgeStartYPt           =   (imageSize.height - rndShapeVerticalHeight)/2;
    
    float topRightEdgeStartXPt          =   topLeftEdgeStartXPt +  rndShapeHorizontalWidth;
    float topRightEdgeStartYPt          =   topLeftEdgeStartYPt;
    
    float bottomEdgeStartXPt            =   imageSize.width/2;
    float bottomEdgeStartYPt            =   topLeftEdgeStartXPt + rndShapeVerticalHeight;
    
    CGPathMoveToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topRightEdgeStartXPt, topRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomEdgeStartXPt, bottomEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
}

+(void)createLeftTriangle:(CGSize)imageSize onCurv:(CGMutablePathRef)curvs{
    float randomValueCofficeint = [NSNumber randomFloatInLimit:1.20 endLimit:1.50];
    
    float rndShapeHorizontalWidth   = imageSize.width*randomValueCofficeint;
    
    float rndShapeVerticalHeight    = imageSize.height*randomValueCofficeint;;
    
    float leftEdgeStartXPt           =   (imageSize.width - rndShapeHorizontalWidth)/2;
    float leftEdgeStartYPt           =   imageSize.height/2;
    
    float topRightEdgeStartXPt      =   leftEdgeStartXPt +  rndShapeHorizontalWidth;
    float topRightEdgeStartYPt      =   (imageSize.height - rndShapeVerticalHeight)/2 ;
    
    float bottonRightEdgeStartXPt    =   topRightEdgeStartYPt +  rndShapeVerticalHeight;
    float bottonRightEdgeStartYPt    =   topRightEdgeStartXPt;
    
    CGPathMoveToPoint(curvs, nil, leftEdgeStartXPt, leftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topRightEdgeStartXPt, topRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottonRightEdgeStartXPt, bottonRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, leftEdgeStartXPt, leftEdgeStartYPt);
}

+(void)createLeftTriangle:(CGSize)imageSize onCurv:(CGMutablePathRef)curvs randomCoff:(float)randomValueCofficeint{
    
    float rndShapeHorizontalWidth   = imageSize.width*randomValueCofficeint;
    
    float rndShapeVerticalHeight    = imageSize.height*randomValueCofficeint;;
    
    float leftEdgeStartXPt           =   (imageSize.width - rndShapeHorizontalWidth)/2;
    float leftEdgeStartYPt           =   imageSize.height/2;
    
    float topRightEdgeStartXPt      =   leftEdgeStartXPt +  rndShapeHorizontalWidth;
    float topRightEdgeStartYPt      =   (imageSize.height - rndShapeVerticalHeight)/2 ;
    
    float bottonRightEdgeStartXPt    =   topRightEdgeStartYPt +  rndShapeVerticalHeight;
    float bottonRightEdgeStartYPt    =   topRightEdgeStartXPt;
    
    CGPathMoveToPoint(curvs, nil, leftEdgeStartXPt, leftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topRightEdgeStartXPt, topRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottonRightEdgeStartXPt, bottonRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, leftEdgeStartXPt, leftEdgeStartYPt);
}

+(void)createRightTriangle:(CGSize)imageSize onCurv:(CGMutablePathRef)curvs randomCoff:(float)randomValueCofficeint{
    
    float rndShapeHorizontalWidth   =   imageSize.width*randomValueCofficeint;
    
    float rndShapeVerticalHeight    =   imageSize.height*randomValueCofficeint;;
    
    float topLeftEdgeStartXPt       =   (imageSize.width - rndShapeHorizontalWidth)/2;
    float topLeftEdgeStartYPt       =   (imageSize.height - rndShapeVerticalHeight)/2;
    
    float bottomLeftEdgeStartXPt    =   (imageSize.width - rndShapeHorizontalWidth)/2;
    float bottomLeftEdgeStartYPt    =   topLeftEdgeStartYPt + rndShapeVerticalHeight;
    
    float rightEdgeStartXPt         =   topLeftEdgeStartXPt + rndShapeHorizontalWidth;
    float rightEdgeStartYPt         =   imageSize.height/2;
    
    CGPathMoveToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomLeftEdgeStartXPt, bottomLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, rightEdgeStartXPt, rightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
}

+(void)createRightTriangle:(CGSize)imageSize onCurv:(CGMutablePathRef)curvs{
    float randomValueCofficeint = [NSNumber randomFloatInLimit:1.20 endLimit:1.50];
    
    float rndShapeHorizontalWidth   =   imageSize.width*randomValueCofficeint;
    
    float rndShapeVerticalHeight    =   imageSize.height*randomValueCofficeint;;
    
    float topLeftEdgeStartXPt       =   (imageSize.width - rndShapeHorizontalWidth)/2;
    float topLeftEdgeStartYPt       =   (imageSize.height - rndShapeVerticalHeight)/2;
    
    float bottomLeftEdgeStartXPt    =   (imageSize.width - rndShapeHorizontalWidth)/2;
    float bottomLeftEdgeStartYPt    =   topLeftEdgeStartYPt + rndShapeVerticalHeight;
    
    float rightEdgeStartXPt         =   topLeftEdgeStartXPt + rndShapeHorizontalWidth;
    float rightEdgeStartYPt         =   imageSize.height/2;
    
    CGPathMoveToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomLeftEdgeStartXPt, bottomLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, rightEdgeStartXPt, rightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
}

+(void)createBottomTriangle:(CGSize)imageSize randomCoff:(float)randomValueCofficeint onContext:(CGContextRef)ctx{
    NSArray *colorsArr = [RandomObjects getRandomGradientColorArray];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float rndShapeHorizontalWidth       =   imageSize.width*randomValueCofficeint;
    
    float rndShapeVerticalHeight        =   imageSize.height*randomValueCofficeint;
    
    float topLeftEdgeStartXPt           =   (imageSize.width - rndShapeHorizontalWidth)/2 ;
    float topLeftEdgeStartYPt           =   (imageSize.height - rndShapeVerticalHeight)/2;
    
    float topRightEdgeStartXPt          =   topLeftEdgeStartXPt +  rndShapeHorizontalWidth;
    float topRightEdgeStartYPt          =   topLeftEdgeStartYPt;
    
    float bottomEdgeStartXPt            =   imageSize.width/2;
    float bottomEdgeStartYPt            =   topLeftEdgeStartXPt + rndShapeVerticalHeight;
    
    CGPathMoveToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topRightEdgeStartXPt, topRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomEdgeStartXPt, bottomEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGPathCloseSubpath(curvs);
    
    NSArray *gradientColorArr = colorsArr;
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
    
    CGContextAddPath(ctx, curvs);
    CGContextClip(ctx);
    CGContextStrokePath(ctx);
}

+(void)createLeftSideTriangleLikePart:(CGSize)imageSize randomCoff:(float)randomValueCofficeint onContext:(CGContextRef)ctx{
    
    NSArray *gradientColorArr = [RandomObjects getRandomGradientColorArray];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float topLeftEdgeStartXPt           =   0;
    float topLeftEdgeStartYPt           =   0;
    
    float bottomLeftEdgeStartXPt        =   0;
    float bottomLeftEdgeStartYPt        =   imageSize.height;
    
    float bottomCenterEdgeStartXPt      =   imageSize.width/2;
    float bottomCenterEdgeStartYPt      =   imageSize.height;
    
    CGPathMoveToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomLeftEdgeStartXPt, bottomLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomCenterEdgeStartXPt, bottomCenterEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGPathCloseSubpath(curvs);
    
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

    
    CGContextAddPath(ctx, curvs);
    CGContextClip(ctx);
    CGContextStrokePath(ctx);
}

+(void)createRightSideTriangleLikePart:(CGSize)imageSize randomCoff:(float)randomValueCofficeint onContext:(CGContextRef)ctx{
    
    NSArray *gradientColorArr = [RandomObjects getRandomGradientColorArray];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float topLeftEdgeStartXPt           =   imageSize.width;
    float topLeftEdgeStartYPt           =   0;
    
    float bottomRightEdgeStartXPt       =   imageSize.width;
    float bottomRightEdgeStartYPt       =   imageSize.height;
    
    float bottomCenterEdgeStartXPt      =   imageSize.width/2;
    float bottomCenterEdgeStartYPt      =   imageSize.height;
    
    CGPathMoveToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomRightEdgeStartXPt, bottomRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomCenterEdgeStartXPt, bottomCenterEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGPathCloseSubpath(curvs);
    
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

    
    CGContextAddPath(ctx, curvs);
    CGContextClip(ctx);
    CGContextStrokePath(ctx);
}

+(UIImage *)createDiamondShape:(CGSize)imageSize asWindow:(BOOL)asWindow{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
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
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float randomValueCofficeint;
    float randomValueCofficeint1;
    
    int randomNumber = [NSNumber randomFloatInLimit:0 endLimit:4];
    
    if(randomNumber == 0){
        randomValueCofficeint         =   [NSNumber randomFloatInLimit:0.90 endLimit:1.50];
        randomValueCofficeint1        =   [NSNumber randomFloatInLimit:0.90 endLimit:2.00];
    }
    else if(randomNumber == 1){
        randomValueCofficeint         =   [NSNumber randomFloatInLimit:0.80 endLimit:1.00];
        randomValueCofficeint1        =   [NSNumber randomFloatInLimit:0.90 endLimit:2.00];
    }
    else if(randomNumber == 2){
        randomValueCofficeint1        =   [NSNumber randomFloatInLimit:0.80 endLimit:1.00];
        randomValueCofficeint         =   [NSNumber randomFloatInLimit:0.90 endLimit:2.00];
    }
    else{
        randomValueCofficeint1        =   [NSNumber randomFloatInLimit:0.80 endLimit:1.00];
        randomValueCofficeint         =   [NSNumber randomFloatInLimit:0.90 endLimit:1.00];
    }
    
    float rndShapeHorizontalWidth       =   imageSize.width*randomValueCofficeint1;
    
    float rndShapeVerticalHeight        =   imageSize.height*randomValueCofficeint;
    
    float topEdgeStartXPt               =   imageSize.width/2 ;
    float topEdgeStartYPt               =   (imageSize.height - rndShapeVerticalHeight)/2;
    
    float leftEdgeStartXPt              =   (imageSize.width - rndShapeHorizontalWidth)/2;
    float leftEdgeStartYPt              =   imageSize.height/2;
    
    float rightEdgeStartXPt             =   leftEdgeStartXPt + rndShapeHorizontalWidth;
    float rightEdgeStartYPt             =   leftEdgeStartYPt;
    
    float bottomEdgeStartXPt            =   imageSize.width/2;
    float bottomEdgeStartYPt            =   topEdgeStartYPt + rndShapeVerticalHeight;
    
    CGPathMoveToPoint(curvs, nil, topEdgeStartXPt, topEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, leftEdgeStartXPt, leftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomEdgeStartXPt, bottomEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, rightEdgeStartXPt, rightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topEdgeStartXPt, topEdgeStartYPt);
    
    UIColor *borderColor = [UIColor colorWithHexString:[NSString randomHexString]];
    
    CGPathCloseSubpath(curvs);
    
    CGContextAddPath(ctx, curvs);
   // CGContextClip(ctx);
    
    //int randomNumber1 = [NSNumber randomFloatInLimit:0 endLimit:10];
    
    if(asWindow){
        NSArray *gradientColorArr = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor, nil];
        CGGradientRef pantagon = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) gradientColorArr, NULL);
        
        CGContextClip(ctx);
        
        if(randomValueForGradientType % 2 == 0){
            CGContextDrawLinearGradient(ctx, pantagon, CGPointMake(0,0), CGPointMake(0, imageSize.height), 0);
        }
        else{
            CGPoint startPoint = CGPointMake(imageSize.width/2, imageSize.height/2);
            
            CGContextDrawRadialGradient(ctx, mountainGrad, startPoint, 0, startPoint, imageSize.width, 0);
        }
        
        //float rndValue = [NSNumber randomFloatInLimit:0.0f endLimit:20.0f];
        float rndValue = [NSNumber randomFloatInLimit:0.0 endLimit:imageSize.width/60];
        CGContextSetLineWidth(ctx, rndValue);
    }
    else{
        NSArray *gradientColorArr = [RandomObjects getRandomGradientColorArray];
        CGGradientRef pantagon = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) gradientColorArr, NULL);
        
        CGContextClip(ctx);
        
        if(randomValueForGradientType % 2 == 0){
            CGContextDrawLinearGradient(ctx, pantagon, CGPointMake(0,0), CGPointMake(0, imageSize.height), 0);
        }
        else{
            CGPoint startPoint = CGPointMake(imageSize.width/2, imageSize.height/2);
            
            CGContextDrawRadialGradient(ctx, mountainGrad, startPoint, 0, startPoint, imageSize.width, 0);
        }
    }
    
    // Background Mountain Stroking
    CGContextAddPath(ctx, curvs);
    
    CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(asWindow){
        UIImage *img = [UIImage removeGradientColor:result];
        
        return img;
    }
    
    return result;
}

+(UIImage *)createPantagonShape:(CGSize)imageSize{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    NSArray *colorsArr = [RandomObjects getRandomGradientColorArray];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef mountainGrad = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colorsArr, NULL);
    
  //  CGContextClip(ctx);
    int randomValueForGradientType = 2;

    if(randomValueForGradientType % 2 == 0){
        CGContextDrawLinearGradient(ctx, mountainGrad, CGPointMake(0,0), CGPointMake(0, imageSize.height), 0);
    }
    else{
        CGPoint startPoint = CGPointMake(imageSize.width/2, imageSize.height/2);
        
        CGContextDrawRadialGradient(ctx, mountainGrad, startPoint, 0, startPoint, imageSize.width, 0);
    }
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float randomValueCofficeint = [NSNumber randomFloatInLimit:0.80 endLimit:1.40];
    
    float rndShapeHorizontalWidth = imageSize.width*randomValueCofficeint;
    
    float rndShapeVerticalHeight = imageSize.height*randomValueCofficeint;;
    
    float rndHorizontalSegmentWidth = rndShapeHorizontalWidth/3;
    float rndVerticalSegmentHeight = rndShapeVerticalHeight/2;
    
    float topLineStartXPt       =   ((imageSize.width - rndShapeHorizontalWidth)/2) + rndHorizontalSegmentWidth;
    float topLineStartYPt       =   ((imageSize.height - rndShapeVerticalHeight)/2) ;
    float topLineEndXPt         =   topLineStartXPt + rndHorizontalSegmentWidth;
    
    float middleLineEndXPt      =   topLineEndXPt + rndHorizontalSegmentWidth;
    float middleLineYPt         =   topLineStartYPt + rndVerticalSegmentHeight;
    
    CGPathMoveToPoint(curvs, nil, topLineStartXPt, topLineStartYPt);
    CGPathAddLineToPoint(curvs, nil, topLineEndXPt, topLineStartYPt);
    CGPathAddLineToPoint(curvs, nil, middleLineEndXPt, middleLineYPt);
    CGPathAddLineToPoint(curvs, nil, topLineEndXPt, middleLineYPt+ rndVerticalSegmentHeight);
    CGPathAddLineToPoint(curvs, nil, topLineStartXPt, middleLineYPt+ rndVerticalSegmentHeight);
    CGPathAddLineToPoint(curvs, nil, topLineStartXPt - rndHorizontalSegmentWidth, middleLineYPt);
    CGPathAddLineToPoint(curvs, nil, topLineStartXPt, topLineStartYPt);
    
    UIColor *borderColor = [UIColor colorWithHexString:[NSString randomHexString]];
    
    CGPathCloseSubpath(curvs);
    
    CGContextAddPath(ctx, curvs);
    CGContextClip(ctx);
    
    NSArray *gradientColorArr = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor, nil];
    CGGradientRef pantagon = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) gradientColorArr, NULL);
    
   // CGContextClip(ctx);
    
    if(randomValueForGradientType % 2 == 0){
        CGContextDrawLinearGradient(ctx, pantagon, CGPointMake(0,0), CGPointMake(0, imageSize.height), 0);
    }
    else{
        CGPoint startPoint = CGPointMake(imageSize.width/2, imageSize.height/2);
        
        CGContextDrawRadialGradient(ctx, mountainGrad, startPoint, 0, startPoint, imageSize.width, 0);
    }
   // float rndValue = [NSNumber randomFloatInLimit:4.0f endLimit:15.0f];
    float rndValue = [NSNumber randomFloatInLimit:imageSize.width/75 endLimit:imageSize.width/20];
    CGContextSetLineWidth(ctx, rndValue);
    
    // Background Mountain Stroking
    CGContextAddPath(ctx, curvs);
    
    CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *img = [UIImage removeGradientColor:result];
    
    return img;
}

#pragma mark Hexagon shape

+(UIImage *)createHexgonShape:(CGSize)imageSize{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
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

    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float randomValueCofficeint = [NSNumber randomFloatInLimit:0.80 endLimit:1.40];
    
    float rndShapeHorizontalWidth = imageSize.width*randomValueCofficeint;
    
    float rndShapeVerticalHeight = imageSize.height*randomValueCofficeint;;
    
    float rndHorizontalSegmentWidth = rndShapeHorizontalWidth/3;
    float rndVerticalSegmentHeight = rndShapeVerticalHeight/3;
    
    float topLineStartXPt       =   ((imageSize.width - rndShapeHorizontalWidth)/2) + rndHorizontalSegmentWidth;
    float topLineStartYPt       =   ((imageSize.height - rndShapeVerticalHeight)/2) ;
    float topLineEndXPt         =   topLineStartXPt + rndHorizontalSegmentWidth;
    
    float middleLineEndXPt      =   topLineEndXPt + rndHorizontalSegmentWidth;
    float middleLineTopYPt      =   topLineStartYPt ;
    float middleLineMiddle1YPt  =   topLineStartYPt + rndVerticalSegmentHeight ;
    float middleLineMiddle2YPt  =   topLineStartYPt + (rndVerticalSegmentHeight *2);
    float middleLineBottomYPt   =   topLineStartYPt + (rndVerticalSegmentHeight *3);
    
    CGPathMoveToPoint(curvs, nil, topLineStartXPt, topLineStartYPt);
    CGPathAddLineToPoint(curvs, nil, topLineEndXPt, middleLineTopYPt);
    
    CGPathAddLineToPoint(curvs, nil, middleLineEndXPt, middleLineMiddle1YPt);
    
    CGPathAddLineToPoint(curvs, nil, middleLineEndXPt ,middleLineMiddle2YPt);
    
    CGPathAddLineToPoint(curvs, nil, topLineEndXPt, middleLineBottomYPt);
    
    CGPathAddLineToPoint(curvs, nil, topLineStartXPt, middleLineBottomYPt);
    
    CGPathAddLineToPoint(curvs, nil, topLineStartXPt - rndHorizontalSegmentWidth, middleLineMiddle2YPt );
    
    CGPathAddLineToPoint(curvs, nil, topLineStartXPt - rndHorizontalSegmentWidth, middleLineMiddle1YPt );
    
    CGPathAddLineToPoint(curvs, nil, topLineStartXPt, middleLineTopYPt);
    
    UIColor *borderColor = [UIColor colorWithHexString:[NSString randomHexString]];
    
    CGPathCloseSubpath(curvs);
    
    CGContextAddPath(ctx, curvs);
    CGContextClip(ctx);
    
    NSArray *gradientColorArr = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor, nil];
    CGGradientRef pantagon = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) gradientColorArr, NULL);
    
    //CGContextClip(ctx);
    
    if(randomValueForGradientType % 2 == 0){
        CGContextDrawLinearGradient(ctx, pantagon, CGPointMake(0,0), CGPointMake(0, imageSize.height), 0);
    }
    else{
        CGPoint startPoint = CGPointMake(imageSize.width/2, imageSize.height/2);
        
        CGContextDrawRadialGradient(ctx, mountainGrad, startPoint, 0, startPoint, imageSize.width, 0);
    }
   // float rndValue = [NSNumber randomFloatInLimit:4.0f endLimit:15.0f];
    float rndValue = [NSNumber randomFloatInLimit:imageSize.width/75 endLimit:imageSize.width/20];
    CGContextSetLineWidth(ctx, rndValue);
    
    // Background Mountain Stroking
    CGContextAddPath(ctx, curvs);
    
    CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *img = [UIImage removeGradientColor:result];
    
    return img;
}

#pragma mark gradient shapes

//************************* Create all shapes with gradient or single color ***********************************//

+(UIImage *)createAllShapesWithGradientOrSingleColor:(CGSize)imageSize randomShapeType:(int)randomShapeType{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
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
    float rndValue = [NSNumber randomFloatInLimit:imageSize.width/75 endLimit:imageSize.width/20];
    CGContextSetLineWidth(ctx, rndValue);
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
    
    int rndValueForShapeWithDifferentRadius = [NSNumber randomIntInLimit:1 endLimit:10];
    
    if(rndValueForShapeWithDifferentRadius % 2 == 0){
        
        //Draw shapes that will have different radius on both side
        
        float getRandomWidthFloatValue = [RandomObjects getRandomSizeThatCanExceed];
        float getRandomHeightFloatValue = [RandomObjects getRandomSizeThatCanExceed];
        
        float radiusRandomValue     =   imageSize.width*getRandomWidthFloatValue;
        float radiusRandomValue1    =   imageSize.height*getRandomHeightFloatValue;
        
        CGRect rectangle = CGRectMake((imageSize.width - radiusRandomValue)/2,(imageSize.height - radiusRandomValue1)/2,radiusRandomValue,radiusRandomValue1);
        
        //int randomShapeType = [NSNumber randomIntInLimit:1 endLimit:4];
        if(randomShapeType == 1){
            //draw circles and ellipse
            [self drawCirculerShapes:rectangle onContext:ctx];
        }
        else if(randomShapeType == 2){
            [self drawRoundedCornerShapes:rectangle onContext:ctx withRadius1:0 withRadius2:0];
        }
        else if(randomShapeType == 3){
            float getRandomWidthRadiusFloatValue = [RandomObjects getRandomRadiusSize];
            float getRandomHeightRadiusFloatValue = [RandomObjects getRandomRadiusSize];
            
            int roundRadius1 = radiusRandomValue*getRandomWidthRadiusFloatValue;
            int roundRadius2 = radiusRandomValue1*getRandomHeightRadiusFloatValue;
            
            int rounConrnerType = [NSNumber randomIntInLimit:1 endLimit:7];
            
            if(rounConrnerType == 1){
                int maxRadius = MIN(roundRadius1, MIN(roundRadius1, roundRadius2));
                [self drawRoundedCornerShapes:rectangle onContext:ctx withRadius1:maxRadius withRadius2:maxRadius];
            }
            if(rounConrnerType == 2){
                int randomNum = [NSNumber randomIntInLimit:1 endLimit:10];
                if(randomNum % 2 == 0){
                    [self drawRoundedCornerShapes:rectangle onContext:ctx withRadius1:roundRadius1 withRadius2:roundRadius2];
                }
                else {
                    [self drawRoundedCornerShapes:rectangle onContext:ctx withRadius1:roundRadius2 withRadius2:roundRadius1];
                }
            }
            if(rounConrnerType >= 3){
                int randomNum = [NSNumber randomIntInLimit:1 endLimit:10];
                if(randomNum % 2 == 0){
                    [self drawRoundedCornerShapes:rectangle onContext:ctx withRadius1:roundRadius1 withRadius2:0];
                }
                else {
                    [self drawRoundedCornerShapes:rectangle onContext:ctx withRadius1:0 withRadius2:roundRadius1];
                }
            }
        }
    }
    else{
        
        //Draw shapes that will have same radius on both side
        
        float getRandomWidthFloatValue = [RandomObjects getRandomSizeThatCanExceed];
        float radiusRandomValue = imageSize.width*getRandomWidthFloatValue;
        
        CGRect rectangle = CGRectMake((imageSize.width - radiusRandomValue)/2,(imageSize.height - radiusRandomValue)/2,radiusRandomValue,radiusRandomValue);
        
        // int randomShapeType = [NSNumber randomIntInLimit:1 endLimit:4];
        if(randomShapeType == 1){
            //draw circles or ellipse
            [self drawCirculerShapes:rectangle onContext:ctx];
        }
        else if(randomShapeType == 2){
            [self drawRoundedCornerShapes:rectangle onContext:ctx withRadius1:0 withRadius2:0];
        }
        else if(randomShapeType == 3){
            float getRandomWidthRadiusFloatValue = [RandomObjects getRandomRadiusSize];
            float getRandomHeightRadiusFloatValue = [RandomObjects getRandomRadiusSize];
            
            int roundRadius1 = radiusRandomValue*getRandomWidthRadiusFloatValue;
            int roundRadius2 = radiusRandomValue*getRandomHeightRadiusFloatValue;
            
            int rounConrnerType = [NSNumber randomIntInLimit:1 endLimit:7];
            
            if(rounConrnerType == 1){
                int maxRadius = MIN(roundRadius1, MIN(roundRadius1, roundRadius2));
                [self drawRoundedCornerShapes:rectangle onContext:ctx withRadius1:maxRadius withRadius2:maxRadius];
            }
            if(rounConrnerType == 2){
                int randomNum = [NSNumber randomIntInLimit:1 endLimit:10];
                if(randomNum % 2 == 0){
                    [self drawRoundedCornerShapes:rectangle onContext:ctx withRadius1:roundRadius1 withRadius2:roundRadius2];
                }
                else {
                    [self drawRoundedCornerShapes:rectangle onContext:ctx withRadius1:roundRadius2 withRadius2:roundRadius1];
                }
            }
            if(rounConrnerType >= 3){
                int randomNum = [NSNumber randomIntInLimit:1 endLimit:10];
                if(randomNum % 2 == 0){
                    [self drawRoundedCornerShapes:rectangle onContext:ctx withRadius1:roundRadius1 withRadius2:0];
                }
                else {
                    [self drawRoundedCornerShapes:rectangle onContext:ctx withRadius1:0 withRadius2:roundRadius1];
                }
            }
        }
    }
    
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *img = [UIImage removeWhiteColor:result];
    
    return img;
}


//****************************************** Draw Round colorners on square shapes ******************************************//

+(void)drawRoundedCornerShapes:(CGRect)rect onContext:(CGContextRef)context withRadius1:(CGFloat)radius1 withRadius2:(CGFloat)radius2 {
    float rndValue = [NSNumber randomFloatInLimit:5.0f endLimit:20.0f];
    CGContextSetLineWidth(context, rndValue);
    
    //now draw the rounded rectangle
    
    
    CGContextSetStrokeColorWithColor(context, [RANDOM_COLOR CGColor]);
    
    //CGContextSetFillColorWithColor(context, [UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor);
    //since I need room in my rect for the shadow, make the rounded rectangle a little smaller than frame
    CGRect rrect = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect));
    // the rest is pretty much copied from Apples example
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    
    {
        //for the shadow, save the state then draw the shadow
        CGContextSaveGState(context);
        
        // Start at 1
        CGContextMoveToPoint(context, minx, midy);
        // Add an arc through 2 to 3
        CGContextAddArcToPoint(context, minx, miny, midx, miny, radius1);
        // Add an arc through 4 to 5
        CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius2);
        // Add an arc through 6 to 7
        CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius1);
        // Add an arc through 8 to 9
        CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius2);
        // Close the path
        CGContextClosePath(context);
        
        //CGContextSetShadow(context, CGSizeMake(4,-5), 10);
        
        CGContextSetStrokeColorWithColor(context, [RANDOM_COLOR CGColor]);
        
        // Fill & stroke the path
        CGContextDrawPath(context, kCGPathFillStroke);
        
        //for the shadow
        CGContextRestoreGState(context);
    }
    
    {
        // Start at 1
        CGContextMoveToPoint(context, minx, midy);
        // Add an arc through 2 to 3
        CGContextAddArcToPoint(context, minx, miny, midx, miny, radius1);
        // Add an arc through 4 to 5
        CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius2);
        // Add an arc through 6 to 7
        CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius1);
        // Add an arc through 8 to 9
        CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius2);
        // Close the path
        CGContextClosePath(context);
        
        
        
        CGContextSetStrokeColorWithColor(context, [RANDOM_COLOR CGColor]);
        // CGContextSetFillColorWithColor(context, [UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor);
        
        // Fill & stroke the path
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}


//****************************************** Draw Circle or eclipe ******************************************//


+(void)drawCirculerShapes:(CGRect)rect onContext:(CGContextRef)ctx{
    float rndValue = [NSNumber randomFloatInLimit:5.0f endLimit:20.0f];
    CGContextSetLineWidth(ctx, rndValue);
    CGContextFillEllipseInRect(ctx, rect);
    CGContextAddEllipseInRect(ctx, rect);
}

@end
