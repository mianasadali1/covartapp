//
//  TextureEffects.m
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 05/12/15.
//  Copyright © 2015 Kanwarpal Singh. All rights reserved.
//

#import "TextureEffects.h"
#import "UIImage+Utility.h"
#import "NSString+RandomStringGenrator.h"

@implementation TextureEffects

+(UIImage *)generateImage:(CGSize)imageSize effectId:(int)effectId{
    int rndForShape = [NSNumber randomIntInLimit:1 endLimit:10];
    
    UIImage *img;
    
    if(effectId == 47){
        //47
        img = [self createPantagonShapeWithTexture:imageSize];
    }
    else if(effectId == 48){
        //48
        img = [self createHexgonShapeWithTexture:imageSize];
    }
    else if(effectId == 49){
        //49
        img = [self createAllShapesWithTexture:imageSize randomShapeType:1];
    }
    else if(effectId == 50){
        //50
        img = [self createAllShapesWithTexture:imageSize randomShapeType:2];
    }
    else if(effectId == 51){
        //51
        img = [self createAllShapesWithTexture:imageSize randomShapeType:3];
    }
    else if(effectId == 52){
        //52
        img = [self createTwoSquareWithTexture:imageSize];
    }
    else if(effectId == 53){
        //53
        img = [self createTriangleShape:imageSize];
    }
    else if(effectId == 54){
        //54
        img = [self createDiamondShape:imageSize];
    }
    else{
        img = [self createAllShapesWithTexture:imageSize randomShapeType:2];
    }
    
    return img;
}

+(UIImage *)createPantagonShapeWithTexture:(CGSize)imageSize{
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
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
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
   // CGContextClip(ctx);
    
    NSArray *gradientColorArr = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor, nil];
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
    float rndValue = [NSNumber randomFloatInLimit:-20.0f endLimit:50.0f];
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

+(UIImage *)createHexgonShapeWithTexture:(CGSize)imageSize{
    
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
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
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
    //CGContextClip(ctx);
    
    NSArray *gradientColorArr = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor, nil];
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
    float rndValue = [NSNumber randomFloatInLimit:-20.0f endLimit:50.0f];
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

#pragma mark texture image effect

//****************************************** create Texture image with different shappes***************************************//

+(UIImage *)createAllShapesWithTexture:(CGSize)imageSize randomShapeType:(int)randomShapeType{
    
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
    
    float rndValue = [NSNumber randomFloatInLimit:-20.0f endLimit:50.0f];
    CGContextSetLineWidth(ctx, rndValue);
    
    UIColor *borderColor = [UIColor colorWithHexString:[NSString randomHexString]];
    
    CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor);
    
    int rndValueForShape = [NSNumber randomIntInLimit:1 endLimit:10];
    
    if(rndValueForShape % 2 == 0){
        float getRandomWidthFloatValue = [RandomObjects getRandomSizeThatCanExceed];
        float getRandomHeightFloatValue = [RandomObjects getRandomSizeThatCanExceed];
        
        float radiusRandomValue = imageSize.width*getRandomWidthFloatValue;
        float radiusRandomValue1 = imageSize.height*getRandomHeightFloatValue;
        
        CGRect rectangle = CGRectMake((imageSize.width - radiusRandomValue)/2,(imageSize.height - radiusRandomValue1)/2,radiusRandomValue,radiusRandomValue1);
        
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
            
            int roundRadius1 = radiusRandomValue *getRandomWidthRadiusFloatValue;
            int roundRadius2 = radiusRandomValue1 *getRandomHeightRadiusFloatValue;;
            
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
            if(rounConrnerType >= 3 ){
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

+(UIImage *)createTriangleShape:(CGSize)imageSize{
    
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
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    int randomNumberForTriangleType = [NSNumber randomFloatInLimit:0 endLimit:5];
    
    if (randomNumberForTriangleType == 1) {
        [self createBottomTriangle:imageSize onCurv:curvs];
    }
    else if(randomNumberForTriangleType == 2){
        [self createTopTriangle:imageSize onCurv:curvs];
    }
    else if(randomNumberForTriangleType == 3){
        [self createLeftTriangle:imageSize onCurv:curvs];
    }
    else if(randomNumberForTriangleType == 4){
        [self createRightTriangle:imageSize onCurv:curvs];
    }
    else {
        [self createBottomTriangle:imageSize onCurv:curvs];
    }
    
    UIColor *borderColor = [UIColor colorWithHexString:[NSString randomHexString]];
    
    CGPathCloseSubpath(curvs);
    
    CGContextAddPath(ctx, curvs);
    //CGContextClip(ctx);
    
    NSArray *gradientColorArr = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor, nil];
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
    float rndValue = [NSNumber randomFloatInLimit:0.0f endLimit:50.0f];
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

+(UIImage *)createDiamondShape:(CGSize)imageSize{
    
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
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float randomValueCofficeint         =   [NSNumber randomFloatInLimit:0.90 endLimit:1.00];
    float randomValueCofficeint1        =   [NSNumber randomFloatInLimit:0.70 endLimit:0.90];
    
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
    //CGContextClip(ctx);
    
    NSArray *gradientColorArr = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor, nil];
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
    float rndValue = [NSNumber randomFloatInLimit:0.0f endLimit:50.0f];
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

+(void)createTopTriangle:(CGSize)imageSize onCurv:(CGMutablePathRef)curvs{
    float randomValueCofficeint = [NSNumber randomFloatInLimit:0.80 endLimit:1.50];
    
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

+(void)createBottomTriangle:(CGSize)imageSize onCurv:(CGMutablePathRef)curvs{
    float randomValueCofficeint = [NSNumber randomFloatInLimit:0.80 endLimit:1.50];
    
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
    float randomValueCofficeint = [NSNumber randomFloatInLimit:0.80 endLimit:1.50];
    
    float rndShapeHorizontalWidth   = imageSize.width*randomValueCofficeint;
    
    float rndShapeVerticalHeight    = imageSize.height*randomValueCofficeint;;
    
    float leftEdgeStartXPt          =   (imageSize.width - rndShapeHorizontalWidth)/2;
    float leftEdgeStartYPt          =   imageSize.height/2;
    
    float topRightEdgeStartXPt      =   leftEdgeStartXPt +  rndShapeHorizontalWidth;
    float topRightEdgeStartYPt      =   (imageSize.height - rndShapeVerticalHeight)/2 ;
    
    float bottonRightEdgeStartXPt   =   topRightEdgeStartYPt +  rndShapeVerticalHeight;
    float bottonRightEdgeStartYPt   =   topRightEdgeStartXPt;
    
    CGPathMoveToPoint(curvs, nil, leftEdgeStartXPt, leftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topRightEdgeStartXPt, topRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottonRightEdgeStartXPt, bottonRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, leftEdgeStartXPt, leftEdgeStartYPt);
}

+(void)createRightTriangle:(CGSize)imageSize onCurv:(CGMutablePathRef)curvs{
    float randomValueCofficeint = [NSNumber randomFloatInLimit:0.80 endLimit:1.50];
    
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

//************************* Create 2 square images ***********************************//

#pragma mark - 2 square shape

+(UIImage *)createTwoSquareWithTexture:(CGSize)imageSize{
    
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
    
    float minSquareSize = MIN(imageSize.width, imageSize.height)/1.5;
    
    float squareSideCoficient = [RandomObjects getRandomSize:NO];
    
    float squareSide = minSquareSize*squareSideCoficient;
    
    
    float rndValue = [NSNumber randomFloatInLimit:-20.0f endLimit:50.0f];
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

//****************************************** Draw Circle or eclipe ******************************************//


+(void)drawCirculerShapes:(CGRect)rect onContext:(CGContextRef)ctx{
    CGContextBeginPath(ctx);
    float rndValue = [NSNumber randomFloatInLimit:-20.0f endLimit:50.0f];
    CGContextSetLineWidth(ctx, rndValue);
    CGContextFillEllipseInRect(ctx, rect);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

+(void)drawRoundedCornerShapes:(CGRect)rect onContext:(CGContextRef)context withRadius1:(CGFloat)radius1 withRadius2:(CGFloat)radius2 {
    float rndValue = [NSNumber randomFloatInLimit:-20.0f endLimit:50.0f];
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


@end
