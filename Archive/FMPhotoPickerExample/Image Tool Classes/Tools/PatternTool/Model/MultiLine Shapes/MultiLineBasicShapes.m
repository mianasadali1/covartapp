//
//  MultiLineBasicShapes.m
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 05/12/15.
//  Copyright © 2015 Kanwarpal Singh. All rights reserved.
//

#import "MultiLineBasicShapes.h"
#import "UIImage+Utility.h"

@implementation MultiLineBasicShapes

#pragma mark gradient shapes with Double Lines

//************************* Create all Double line shapes with gradient or single color ***********************************//

+(UIImage *)generateImageAsWindow:(CGSize)imageSize effectId:(NSUInteger)effectId{
    UIImage *img;
    
    if(effectId == 20){
        //20
        img = [self createPantagonShapeWithDoubleLine:imageSize];
    }
    else if(effectId == 21){
        //21
        img = [self createHexgonShapeWithDoubleLine:imageSize];
    }
    else if(effectId == 22){
        //22
        img = [self createTriangleShapeWithDoubleLine:imageSize];
    }
    else if(effectId == 23){
        //23
        img = [self createDiamondShapeWithDoubleLine:imageSize];
    }
    else if(effectId == 37){
        //37
        img = [self createGradientShapesWithDoubleLines:imageSize randomShapeType:1];
    }
    else if(effectId == 38){
        //38
        img = [self createGradientShapesWithDoubleLines:imageSize randomShapeType:2];
    }
    else if(effectId == 39){
        //39
        img = [self createGradientShapesWithDoubleLines:imageSize randomShapeType:3];
    }
    else {
        img = [self createGradientShapesWithDoubleLines:imageSize randomShapeType:3];
    }

    return img;
}

+(UIImage *)generateImage:(CGSize)imageSize effectId:(NSUInteger)effectId{
    UIImage *img;
    
    if(effectId == 15){
        //1
        img = [self createPantagonShapeWithMultiLine:imageSize];
    }
    else if(effectId == 16){
        //16
        img = [self createHexgonShapeWithMultiLine:imageSize];
    }
    else if(effectId == 3){
        //3
        img = [self createTriangleShapeWithMultiLine:imageSize];
    }
    else if(effectId == 4){
        //4
        img = [self createDiamondShapeWithMultiLine:imageSize];
    }
    else if(effectId == 2){
        //2
        img = [self createGradientShapesWithMultiLines:imageSize randomShapeType:1];
    }
    else if(effectId == 17){
        //44
        img = [self createGradientShapesWithMultiLines:imageSize randomShapeType:2];
    }
    
    return img;
}

+(UIImage *)createPantagonShapeWithDoubleLine:(CGSize)imageSize{
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

    float randomValueCofficeint = [NSNumber randomFloatInLimit:0.80 endLimit:1.40];
    
    float rndShapeHorizontalWidth = imageSize.width*randomValueCofficeint;
    
    float rndShapeVerticalHeight = imageSize.height*randomValueCofficeint;
    
    float rndValue = 20;
    CGContextSetLineWidth(ctx, rndValue);
    
    float maxRadius = rndShapeHorizontalWidth > rndShapeVerticalHeight ? rndShapeHorizontalWidth : rndShapeVerticalHeight;
    
    float currentRadius = maxRadius;
    
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    [self generatePantagonWithDoubleLine:imageSize onContext:ctx withHt:currentRadius withWidth:currentRadius PATH:curvs];
    [self generatePantagonWithDoubleLine:imageSize onContext:ctx withHt:currentRadius - (5*rndValue) withWidth:currentRadius - (5*rndValue) PATH:curvs];
    
    CGPathCloseSubpath(curvs);
    
    CGContextAddPath(ctx, curvs);
    //CGContextClip(ctx);
    
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
    // Background Mountain Stroking
    CGContextAddPath(ctx, curvs);
    
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *img = [UIImage removeGradientColor:result];
    
    return img;
}

+(void)generatePantagonWithDoubleLine:(CGSize )imgSize onContext:(CGContextRef )context withHt:(float)ht withWidth:(float)width PATH:(CGMutablePathRef)curvs{
    
    CGContextSetStrokeColorWithColor(context, RANDOM_COLOR.CGColor);
    
    float rndHorizontalSegmentWidth = width/3;
    float rndVerticalSegmentHeight = ht/2;
    
    float topLineStartXPt       =   ((imgSize.width - width)/2) + rndHorizontalSegmentWidth;
    float topLineStartYPt       =   ((imgSize.height - ht)/2) ;
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
}

+(UIImage *)createHexgonShapeWithDoubleLine:(CGSize)imageSize{
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
    
    float randomValueCofficeint = [NSNumber randomFloatInLimit:0.80 endLimit:1.40];
    
    float rndShapeHorizontalWidth = imageSize.width*randomValueCofficeint;
    
    float rndShapeVerticalHeight = imageSize.height*randomValueCofficeint;;
    
    float maxRadius = rndShapeHorizontalWidth > rndShapeVerticalHeight ? rndShapeHorizontalWidth : rndShapeVerticalHeight;
    
    float currentRadius = maxRadius;
//    float rndValue = [NSNumber randomFloatInLimit:4.0f endLimit:15.0f];
    float rndValue = [NSNumber randomFloatInLimit:imageSize.width/75 endLimit:imageSize.width/20];
    CGContextSetLineWidth(ctx, rndValue);
    
    [self generateHexagonWithDoubleLine:imageSize onContext:ctx withHt:maxRadius withWidth:maxRadius onPath:curvs];
    
    [self generateHexagonWithDoubleLine:imageSize onContext:ctx withHt:currentRadius - (5*rndValue) withWidth:currentRadius - (5*rndValue) onPath:curvs];
    
    CGPathCloseSubpath(curvs);
    
    CGContextAddPath(ctx, curvs);
   // CGContextClip(ctx);
    
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
    
    // Background Mountain Stroking
    CGContextAddPath(ctx, curvs);
    
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *img = [UIImage removeGradientColor:result];
    
    return img;
}

+(void)generateHexagonWithDoubleLine:(CGSize )imgSize onContext:(CGContextRef )context withHt:(float)ht withWidth:(float)width onPath:(CGMutablePathRef)curvs{
    CGContextSetStrokeColorWithColor(context, RANDOM_COLOR.CGColor);
    
    float rndHorizontalSegmentWidth = width/3;
    float rndVerticalSegmentHeight = ht/3;
    
    float topLineStartXPt       =   ((imgSize.width - width)/2) + rndHorizontalSegmentWidth;
    float topLineStartYPt       =   ((imgSize.height - ht)/2) ;
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
}

#pragma mark gradient shapes with Multi Lines

//************************* Create all Multi line shapes with gradient or single color ***********************************//

+(UIImage *)createPantagonShapeWithMultiLine:(CGSize)imageSize{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    float rndShapeHorizontalWidth = imageSize.width*2;
    
    float rndShapeVerticalHeight = imageSize.height*2;
    
    //float rndValue = [NSNumber randomFloatInLimit:300.0f endLimit:500.0f];
    float rndValue = [NSNumber randomFloatInLimit:imageSize.width/2 endLimit:imageSize.width/10];
    CGContextSetLineWidth(ctx, rndValue);
    
    float maxRadius = rndShapeHorizontalWidth > rndShapeVerticalHeight ? rndShapeHorizontalWidth : rndShapeVerticalHeight;
    
    float currentRadius = maxRadius;
    [self generatePantagonWithMultiLine:imageSize onContext:ctx withHt:maxRadius withWidth:maxRadius];
    
    while (currentRadius > 0) {
        currentRadius -= (rndValue);
        [self generatePantagonWithMultiLine:imageSize onContext:ctx withHt:currentRadius withWidth:currentRadius];
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *img = [UIImage removeGradientColor:result];
    
    return img;
}

+(void)generatePantagonWithMultiLine:(CGSize )imgSize onContext:(CGContextRef )context withHt:(float)ht withWidth:(float)width{
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float rndHorizontalSegmentWidth = width/3;
    float rndVerticalSegmentHeight = ht/2;
    
    float topLineStartXPt       =   ((imgSize.width - width)/2) + rndHorizontalSegmentWidth;
    float topLineStartYPt       =   ((imgSize.height - ht)/2) ;
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
    
    CGPathCloseSubpath(curvs);
    
    CGContextAddPath(context, curvs);
    CGContextClip(context);
    
    CGContextAddPath(context, curvs);
    
    CGContextSetStrokeColorWithColor(context, RANDOM_COLOR.CGColor);
    CGContextStrokePath(context);
}

#pragma mark Hexagon shape

+(UIImage *)createHexgonShapeWithMultiLine:(CGSize)imageSize{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    float rndShapeHorizontalWidth = imageSize.width*2;
    
    float rndShapeVerticalHeight = imageSize.height*2;;
    
    float maxRadius = rndShapeHorizontalWidth > rndShapeVerticalHeight ? rndShapeHorizontalWidth : rndShapeVerticalHeight;
    
    float currentRadius = maxRadius;
    [self generateHexagonWithMultiLine:imageSize onContext:ctx withHt:maxRadius withWidth:maxRadius];
    
   // float rndValue = [NSNumber randomFloatInLimit:300.0f endLimit:500.0f];
    float rndValue = [NSNumber randomFloatInLimit:imageSize.width/2 endLimit:imageSize.width*2];

    CGContextSetLineWidth(ctx, rndValue);
    
    while (currentRadius > 0) {
        currentRadius -= (rndValue);
        [self generateHexagonWithMultiLine:imageSize onContext:ctx withHt:currentRadius withWidth:currentRadius];
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *img = [UIImage removeGradientColor:result];
    
    return img;
}

+(void)generateHexagonWithMultiLine:(CGSize )imgSize onContext:(CGContextRef )context withHt:(float)ht withWidth:(float)width{
    CGMutablePathRef curvs = CGPathCreateMutable();
    float rndHorizontalSegmentWidth = width/3;
    float rndVerticalSegmentHeight = ht/3;
    
    float topLineStartXPt       =   ((imgSize.width - width)/2) + rndHorizontalSegmentWidth;
    float topLineStartYPt       =   ((imgSize.height - ht)/2) ;
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
    
    CGPathCloseSubpath(curvs);
    
    CGContextAddPath(context, curvs);
    CGContextClip(context);
    
    CGContextAddPath(context, curvs);
    
    CGContextSetStrokeColorWithColor(context, RANDOM_COLOR.CGColor);
    CGContextStrokePath(context);
}

+(UIImage *)createGradientShapesWithDoubleLines:(CGSize)imageSize randomShapeType:(int)randomShapeType{
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
    
//    float rndValue = [NSNumber randomFloatInLimit:5.0f endLimit:20.0f];
    float rndValue = [NSNumber randomFloatInLimit:imageSize.width/75 endLimit:imageSize.width/20];

    CGContextSetLineWidth(ctx, rndValue);
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    int rndValueForShapeWithDifferentRadius = [NSNumber randomIntInLimit:1 endLimit:10];
    
    if(rndValueForShapeWithDifferentRadius % 2 == 0){
        float getRandomWidthFloatValue = [RandomObjects getRandomSizeThatCanExceed];
        float getRandomHeightFloatValue = [RandomObjects getRandomSizeThatCanExceed];
        
        float xRadiusRandomValue = imageSize.width*getRandomWidthFloatValue;
        float yRadiusRandomValue = imageSize.height*getRandomHeightFloatValue;
        
        float getRandomSpace    = [RandomObjects getRandomSpaceForDoubleLine];
        
        CGRect rectangle1 = CGRectMake((imageSize.width - xRadiusRandomValue)/2,(imageSize.height - yRadiusRandomValue)/2,xRadiusRandomValue,yRadiusRandomValue);
        
        CGRect rectangle2 = CGRectMake(((imageSize.width - xRadiusRandomValue)/2) + getRandomSpace ,((imageSize.height - yRadiusRandomValue)/2) + getRandomSpace,xRadiusRandomValue - (getRandomSpace*2),yRadiusRandomValue - (getRandomSpace*2));
        
        //int randomShapeType = [NSNumber randomIntInLimit:1 endLimit:4];
        if(randomShapeType == 1){
            //draw circles or ellipse
            
            [self drawSpaceColor:RANDOM_COLOR onContext:ctx];
            
            [self drawCirculerShapes:rectangle1 onContext:ctx];
            
            [self drawRemoveableContextColor:ctx];
            
            [self drawCirculerShapes:rectangle2 onContext:ctx];
        }
        else if(randomShapeType == 2){
            
            // both side round corner for square shapes
            [self drawSpaceColor:RANDOM_COLOR onContext:ctx];
            
            [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:0 withRadius2:0];
            
            [self drawRemoveableContextColor:ctx];
            
            [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle2 onContext:ctx withRadius1:0 withRadius2:0];
        }
        else if(randomShapeType == 3){
            
            // one side round corner for square shapes
            
            float getRandomWidthRadiusFloatValue = [RandomObjects getRandomRadiusSize];
            float getRandomHeightRadiusFloatValue = [RandomObjects getRandomRadiusSize];
            
            int roundXRadius = xRadiusRandomValue*getRandomWidthRadiusFloatValue;
            int roundYRadius = yRadiusRandomValue*getRandomHeightRadiusFloatValue;
            
            int rounConrnerType = [NSNumber randomIntInLimit:1 endLimit:7];
            
            if(rounConrnerType == 1){
                int maxRadius = MIN(roundXRadius, MIN(roundXRadius, roundYRadius));
                [self drawSpaceColor:RANDOM_COLOR onContext:ctx];
                
                [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:maxRadius withRadius2:maxRadius];
                
                [self drawRemoveableContextColor:ctx];
                
                [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle2 onContext:ctx withRadius1:maxRadius withRadius2:maxRadius];
            }
            if(rounConrnerType == 2){
                int randomNum = [NSNumber randomIntInLimit:1 endLimit:10];
                if(randomNum % 2 == 0){
                    
                    [self drawSpaceColor:RANDOM_COLOR onContext:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:roundXRadius withRadius2:roundYRadius];
                    
                    [self drawRemoveableContextColor:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:roundXRadius withRadius2:roundYRadius];
                }
                else {
                    [self drawSpaceColor:RANDOM_COLOR onContext:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:roundYRadius withRadius2:roundXRadius];
                    
                    [self drawRemoveableContextColor:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle2 onContext:ctx withRadius1:roundYRadius withRadius2:roundXRadius];
                }
            }
            if(rounConrnerType >= 3){
                int randomNum = [NSNumber randomIntInLimit:1 endLimit:10];
                if(randomNum % 2 == 0){
                    
                    [self drawSpaceColor:RANDOM_COLOR onContext:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:roundXRadius withRadius2:0];
                    
                    [self drawRemoveableContextColor:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle2 onContext:ctx withRadius1:roundXRadius withRadius2:0];
                }
                else {
                    [self drawSpaceColor:RANDOM_COLOR onContext:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:0 withRadius2:roundXRadius];
                    
                    [self drawRemoveableContextColor:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle2 onContext:ctx withRadius1:0 withRadius2:roundXRadius];
                }
            }
        }
    }
    else{
        float getRandomWidthFloatValue = [RandomObjects getRandomSizeThatCanExceed];
        float getRandomSpace    = [RandomObjects getRandomSpaceForDoubleLine];
        
        float radiusRandomValue = imageSize.width*getRandomWidthFloatValue;
        
        CGRect rectangle1 = CGRectMake((imageSize.width - radiusRandomValue)/2,(imageSize.height - radiusRandomValue)/2,radiusRandomValue,radiusRandomValue);
        
        CGRect rectangle2 = CGRectMake(((imageSize.width - radiusRandomValue)/2) + getRandomSpace,((imageSize.height - radiusRandomValue)/2) + getRandomSpace,radiusRandomValue - (getRandomSpace*2),radiusRandomValue - (getRandomSpace*2));
        
       // int randomShapeType = [NSNumber randomIntInLimit:1 endLimit:4];
        if(randomShapeType == 1){
            //draw circles or ellipse
            
            [self drawSpaceColor:RANDOM_COLOR onContext:ctx];
            
            [self drawCirculerShapes:rectangle1 onContext:ctx];
            
            [self drawRemoveableContextColor:ctx];
            
            [self drawCirculerShapes:rectangle2 onContext:ctx];
        }
        else if(randomShapeType == 2){
            [self drawSpaceColor:RANDOM_COLOR onContext:ctx];
            
            [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:0 withRadius2:0];
            
            [self drawRemoveableContextColor:ctx];
            
            [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle2 onContext:ctx withRadius1:0 withRadius2:0];
        }
        else if(randomShapeType == 3){
            [self drawSpaceColor:RANDOM_COLOR onContext:ctx];
            
            float getRandomWidthRadiusFloatValue = [RandomObjects getRandomRadiusSize];
            float getRandomHeightRadiusFloatValue = [RandomObjects getRandomRadiusSize];
            
            int roundRadius1 = radiusRandomValue*getRandomWidthRadiusFloatValue;
            int roundRadius2 = radiusRandomValue*getRandomHeightRadiusFloatValue;
            
            int rounConrnerType = [NSNumber randomIntInLimit:1 endLimit:7];
            
            if(rounConrnerType == 1){
                int maxRadius = MIN(roundRadius1, MIN(roundRadius1, roundRadius2));
                
                [self drawSpaceColor:RANDOM_COLOR onContext:ctx];
                
                [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:maxRadius withRadius2:maxRadius];
                
                [self drawRemoveableContextColor:ctx];
                
                [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle2 onContext:ctx withRadius1:maxRadius withRadius2:maxRadius];
            }
            if(rounConrnerType == 2){
                int randomNum = [NSNumber randomIntInLimit:1 endLimit:10];
                if(randomNum % 2 == 0){
                    [self drawSpaceColor:RANDOM_COLOR onContext:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:roundRadius1 withRadius2:roundRadius2];
                    
                    [self drawRemoveableContextColor:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle2 onContext:ctx withRadius1:roundRadius1 withRadius2:roundRadius2];
                }
                else {
                    [self drawSpaceColor:RANDOM_COLOR onContext:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:roundRadius2 withRadius2:roundRadius1];
                    
                    [self drawRemoveableContextColor:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle2 onContext:ctx withRadius1:roundRadius2 withRadius2:roundRadius1];
                }
            }
            if(rounConrnerType >= 3){
                int randomNum = [NSNumber randomIntInLimit:1 endLimit:10];
                if(randomNum % 2 == 0){
                    
                    [self drawSpaceColor:RANDOM_COLOR onContext:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:roundRadius1 withRadius2:0];
                    
                    [self drawRemoveableContextColor:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle2 onContext:ctx withRadius1:roundRadius1 withRadius2:0];
                }
                else {
                    
                    [self drawSpaceColor:RANDOM_COLOR onContext:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:0 withRadius2:roundRadius1];
                    
                    [self drawRemoveableContextColor:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle2 onContext:ctx withRadius1:0 withRadius2:roundRadius1];
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


+(UIImage *)createGradientShapesWithMultiLines:(CGSize)imageSize randomShapeType:(int)randomShapeType{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //float rndLineWidth = [NSNumber randomIntInLimit:20.0 endLimit:100.0];
    float rndLineWidth = [NSNumber randomIntInLimit:imageSize.width/4 endLimit:imageSize.width/3];

    CGContextSetLineWidth(ctx, rndLineWidth);
    CGContextSetStrokeColorWithColor(ctx, [RANDOM_COLOR CGColor]);

    int rndValueForShapeWithDifferentRadius = [NSNumber randomIntInLimit:1 endLimit:10];
    
//    if(rndValueForShapeWithDifferentRadius % 2 == 0){
//        
//        float xRadiusRandomValue = imageSize.width*1.5;
//        float yRadiusRandomValue = imageSize.height*1.5;
//        
//        CGRect rectangle1 = CGRectMake((imageSize.width - xRadiusRandomValue)/2,(imageSize.height - yRadiusRandomValue)/2,xRadiusRandomValue,yRadiusRandomValue);
//
//        //int randomShapeType = [NSNumber randomIntInLimit:1 endLimit:4];
//        
//        if(randomShapeType == 1){
//            
//            [self drawRoundedCornerShapesWithoutSettingStrokColorForMultiLine:rectangle1 onContext:ctx withRadius1:0 withRadius2:0 lineWidth:rndLineWidth]
//            ;
//            while (xRadiusRandomValue > (rndLineWidth*2) && yRadiusRandomValue > (rndLineWidth*2)) {
//                
//                CGRect rectangle = CGRectMake(((imageSize.width - xRadiusRandomValue)/2) + rndLineWidth ,((imageSize.height - yRadiusRandomValue)/2) + rndLineWidth,xRadiusRandomValue - (rndLineWidth*2),yRadiusRandomValue - (rndLineWidth*2));
//                
//                // [self drawCirculerShapesForMultiLine:rectangle onContext:ctx lineWidth:rndLineWidth];
//                [self drawRoundedCornerShapesWithoutSettingStrokColorForMultiLine:rectangle onContext:ctx withRadius1:0 withRadius2:0 lineWidth:rndLineWidth]
//                ;
//                yRadiusRandomValue = yRadiusRandomValue - (rndLineWidth*2);
//                xRadiusRandomValue = xRadiusRandomValue - (rndLineWidth*2);
//            }
//        }
//        else{
//            //draw circles or ellipse
//            [self drawCirculerShapesForMultiLine:rectangle1 onContext:ctx lineWidth:rndLineWidth];
//            
//            while (xRadiusRandomValue > (rndLineWidth*2) && yRadiusRandomValue > (rndLineWidth*2)) {
//                
//                CGRect rectangle = CGRectMake(((imageSize.width - xRadiusRandomValue)/2) + rndLineWidth ,((imageSize.height - yRadiusRandomValue)/2) + rndLineWidth,xRadiusRandomValue - (rndLineWidth*2),yRadiusRandomValue - (rndLineWidth*2));
//                
//                [self drawCirculerShapesForMultiLine:rectangle onContext:ctx lineWidth:rndLineWidth];
//                
//                yRadiusRandomValue = yRadiusRandomValue - (rndLineWidth*2);
//                xRadiusRandomValue = xRadiusRandomValue - (rndLineWidth*2);
//            }
//            
//        }
//    }
//    else{
        float radiusRandomValue = imageSize.width*1.5;
        CGRect rectangle = CGRectMake((imageSize.width - radiusRandomValue)/2,(imageSize.height - radiusRandomValue)/2,radiusRandomValue,radiusRandomValue);
        
        if(randomShapeType == 1){
            
            [self drawRoundedCornerShapesWithoutSettingStrokColorForMultiLine:rectangle onContext:ctx withRadius1:0 withRadius2:0 lineWidth:rndLineWidth]
            ;
            while (radiusRandomValue > rndLineWidth*2 ) {
                
                CGRect rectangle = CGRectMake(((imageSize.width - radiusRandomValue)/2) + rndLineWidth ,((imageSize.height - radiusRandomValue)/2) + rndLineWidth,radiusRandomValue - (rndLineWidth*2),radiusRandomValue - (rndLineWidth*2));
                
                [self drawRoundedCornerShapesWithoutSettingStrokColorForMultiLine:rectangle onContext:ctx withRadius1:0 withRadius2:0 lineWidth:rndLineWidth];
                
                radiusRandomValue = radiusRandomValue - rndLineWidth;
            }
        }
        else{
            
            [self drawCirculerShapesForMultiLine:rectangle onContext:ctx lineWidth:rndLineWidth];
        
            while (radiusRandomValue > rndLineWidth*2 ) {
                
                CGRect rectangle = CGRectMake(((imageSize.width - radiusRandomValue)/2) + rndLineWidth ,((imageSize.height - radiusRandomValue)/2) + rndLineWidth,radiusRandomValue - (rndLineWidth*2),radiusRandomValue - (rndLineWidth*2));
                
                [self drawCirculerShapesForMultiLine:rectangle onContext:ctx lineWidth:rndLineWidth];
                
                radiusRandomValue = radiusRandomValue - rndLineWidth;
            }
        }
 //   }
    
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

#pragma mark diamond shapes

+(UIImage *)createDiamondShapeWithDoubleLine:(CGSize)imageSize{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    NSArray *colorsArr = [RandomObjects getRandomGradientColorArray];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef mountainGrad = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colorsArr, NULL);
    
//    CGContextClip(ctx);
    int randomValueForGradientType = 2;
    
    if(randomValueForGradientType % 2 == 0){
        CGContextDrawLinearGradient(ctx, mountainGrad, CGPointMake(0,0), CGPointMake(0, imageSize.height), 0);
    }
    else{
        CGPoint startPoint = CGPointMake(imageSize.width/2, imageSize.height/2);
        
        CGContextDrawRadialGradient(ctx, mountainGrad, startPoint, 0, startPoint, imageSize.width, 0);
    }
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float randomValueCofficeint         =   [NSNumber randomFloatInLimit:0.90 endLimit:1.00];
    float randomValueCofficeint1         =   [NSNumber randomFloatInLimit:0.70 endLimit:0.90];
    
    float rndShapeHorizontalWidth       =   imageSize.width*randomValueCofficeint1;
    
    float rndShapeVerticalHeight        =   imageSize.height*randomValueCofficeint;
    
    //float rndValue = [NSNumber randomFloatInLimit:0.0f endLimit:40.0f];
    float rndValue = [NSNumber randomFloatInLimit:0.0 endLimit:imageSize.width/20];

    CGContextSetLineWidth(ctx, rndValue);
    
    [self drawDiamondShape:imageSize onCurv:curvs width:rndShapeHorizontalWidth height:rndShapeVerticalHeight onContext:ctx];
    
    [self drawDiamondShape:imageSize onCurv:curvs width:rndShapeHorizontalWidth - (rndValue + imageSize.width/8) height:rndShapeVerticalHeight - (rndValue + imageSize.width/8) onContext:ctx];
    
    UIColor *borderColor = [UIColor colorWithHexString:[NSString randomHexString]];
    
    CGPathCloseSubpath(curvs);
    
    CGContextAddPath(ctx, curvs);
   // CGContextClip(ctx);
    
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
    // Background Mountain Stroking
    CGContextAddPath(ctx, curvs);
    
    CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *img = [UIImage removeGradientColor:result];
    
    return img;
}

#pragma mark diamond multiline

+(UIImage *)createDiamondShapeWithMultiLine:(CGSize)imageSize{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    float rndShapeHorizontalWidth       =   imageSize.width*1.70;
    float rndShapeVerticalHeight        =   imageSize.height*1.70;
    
//    float rndValue = [NSNumber randomFloatInLimit:300.0f endLimit:500.0f];
    float rndValue = [NSNumber randomFloatInLimit:imageSize.width/4 endLimit:imageSize.width*1.2];

    CGContextSetLineWidth(ctx, rndValue);
    
    while (rndShapeHorizontalWidth > -rndValue && rndShapeVerticalHeight > -rndValue) {
        [self drawDiamondShapeWithMultiLine:imageSize width:rndShapeHorizontalWidth height:rndShapeVerticalHeight onContext:ctx];
        
        rndShapeHorizontalWidth = rndShapeHorizontalWidth - rndValue;
        rndShapeVerticalHeight = rndShapeVerticalHeight - rndValue;
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *img = [UIImage removeGradientColor:result];
    
    return img;
}

+(void)drawDiamondShape:(CGSize)imageSize onCurv:(CGMutablePathRef)curvs width:(float)rndShapeHorizontalWidth height:(float)rndShapeVerticalHeight onContext:(CGContextRef)ctx{
    
    float topEdgeStartXPt               =   imageSize.width/2 ;
    float topEdgeStartYPt               =   (imageSize.height - rndShapeVerticalHeight)/2;
    
    float leftEdgeStartXPt              =   (imageSize.width - rndShapeHorizontalWidth)/2;
    float leftEdgeStartYPt              =   imageSize.height/2;
    
    float rightEdgeStartXPt             =   leftEdgeStartXPt + rndShapeHorizontalWidth;
    float rightEdgeStartYPt             =   leftEdgeStartYPt;
    
    float bottomEdgeStartXPt            =   imageSize.width/2;
    float bottomEdgeStartYPt            =   topEdgeStartYPt + rndShapeVerticalHeight;
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGPathMoveToPoint(curvs, nil, topEdgeStartXPt, topEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, leftEdgeStartXPt, leftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomEdgeStartXPt, bottomEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, rightEdgeStartXPt, rightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topEdgeStartXPt, topEdgeStartYPt);
}

+(void)drawDiamondShapeWithMultiLine:(CGSize)imageSize width:(float)rndShapeHorizontalWidth height:(float)rndShapeVerticalHeight onContext:(CGContextRef)ctx{
    
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
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    float topEdgeStartXPt               =   imageSize.width/2 ;
    float topEdgeStartYPt               =   (imageSize.height - rndShapeVerticalHeight)/2;
    
    float leftEdgeStartXPt              =   (imageSize.width - rndShapeHorizontalWidth)/2;
    float leftEdgeStartYPt              =   imageSize.height/2;
    
    float rightEdgeStartXPt             =   leftEdgeStartXPt + rndShapeHorizontalWidth;
    float rightEdgeStartYPt             =   leftEdgeStartYPt;
    
    float bottomEdgeStartXPt            =   imageSize.width/2;
    float bottomEdgeStartYPt            =   topEdgeStartYPt + rndShapeVerticalHeight;
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGPathMoveToPoint(curvs, nil, topEdgeStartXPt, topEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, leftEdgeStartXPt, leftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomEdgeStartXPt, bottomEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, rightEdgeStartXPt, rightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topEdgeStartXPt, topEdgeStartYPt);
    
    CGPathCloseSubpath(curvs);
    
    CGContextAddPath(ctx, curvs);
    CGContextClip(ctx);
    CGContextStrokePath(ctx);
}

#pragma mark triangle shapes

+(UIImage *)createTriangleShapeWithDoubleLine:(CGSize)imageSize{
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
    
   // float rndWidthValue = [NSNumber randomFloatInLimit:0.0f endLimit:25.0f];
    float rndWidthValue = [NSNumber randomFloatInLimit:0.0 endLimit:imageSize.width/15];

    CGContextSetLineWidth(ctx, rndWidthValue);
    
    int randomNumberForTriangleType = [NSNumber randomIntInLimit:0 endLimit:5];
    
    if (randomNumberForTriangleType == 1) {
        [self createBottomTriangleWithDoubleLine:imageSize onCurv:curvs lineWidth:rndWidthValue onContext:ctx];
    }
    else if(randomNumberForTriangleType == 2){
        [self createTopTriangleWithDoubleLine:imageSize onCurv:curvs lineWidth:rndWidthValue onContext:ctx];
    }
    else if(randomNumberForTriangleType == 3){
        [self createLeftTriangleWithDoubleLine:imageSize onCurv:curvs lineWidth:rndWidthValue onContext:ctx];
    }
    else if(randomNumberForTriangleType == 4){
        [self createRightTriangleWithDoubleLine:imageSize onCurv:curvs lineWidth:rndWidthValue onContext:ctx];
    }
    else {
        [self createBottomTriangleWithDoubleLine:imageSize onCurv:curvs lineWidth:rndWidthValue onContext:ctx];
    }
    
    CGPathCloseSubpath(curvs);
    
    CGContextAddPath(ctx, curvs);
    //CGContextClip(ctx);
    
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
    // Background Mountain Stroking
    CGContextAddPath(ctx, curvs);
    
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *img = [UIImage removeGradientColor:result];
    
    return img;
}

+(void)createTopTriangleWithDoubleLine:(CGSize)imageSize onCurv:(CGMutablePathRef)curvs lineWidth:(float)width onContext:(CGContextRef)ctx{
    float randomValueCofficeint     =   [NSNumber randomFloatInLimit:0.90 endLimit:2.00];
    float randomValueForSpace       =   width + [NSNumber randomFloatInLimit:20.00 endLimit:40.00];
    
    float rndShapeHorizontalWidth   = imageSize.width*randomValueCofficeint;
    
    float rndShapeVerticalHeight    = imageSize.height*randomValueCofficeint;;
    
    float topEdgeStartXPt           =   imageSize.width/2;
    float topEdgeStartYPt           =   (imageSize.height - rndShapeVerticalHeight)/2;
    
    float topEdgeStartXPt1           =   imageSize.width/2;
    float topEdgeStartYPt1           =   (imageSize.height - rndShapeVerticalHeight)/2 + randomValueForSpace;
    
    float bottonLeftEdgeStartXPt    =   (imageSize.width - rndShapeHorizontalWidth)/2 ;
    float bottonLeftEdgeStartYPt    =   topEdgeStartYPt +  rndShapeVerticalHeight ;
    
    float bottonLeftEdgeStartXPt1    =   (imageSize.width - rndShapeHorizontalWidth)/2 + randomValueForSpace;
    float bottonLeftEdgeStartYPt1    =   topEdgeStartYPt +  rndShapeVerticalHeight - randomValueForSpace/2;
    
    float bottonRightEdgeStartXPt    =   bottonLeftEdgeStartXPt +  rndShapeHorizontalWidth;
    float bottonRightEdgeStartYPt    =   bottonLeftEdgeStartYPt;
    
    float bottonRightEdgeStartXPt1    =   bottonLeftEdgeStartXPt +  rndShapeHorizontalWidth - randomValueForSpace;
    float bottonRightEdgeStartYPt1    =   bottonLeftEdgeStartYPt - randomValueForSpace/2;
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGPathMoveToPoint(curvs, nil, topEdgeStartXPt, topEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottonLeftEdgeStartXPt, bottonLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottonRightEdgeStartXPt, bottonRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topEdgeStartXPt, topEdgeStartYPt);
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGPathMoveToPoint(curvs, nil, topEdgeStartXPt1, topEdgeStartYPt1);
    CGPathAddLineToPoint(curvs, nil, bottonLeftEdgeStartXPt1, bottonLeftEdgeStartYPt1);
    CGPathAddLineToPoint(curvs, nil, bottonRightEdgeStartXPt1, bottonRightEdgeStartYPt1);
    CGPathAddLineToPoint(curvs, nil, topEdgeStartXPt1, topEdgeStartYPt1);
}

+(void)createBottomTriangleWithDoubleLine:(CGSize)imageSize onCurv:(CGMutablePathRef)curvs lineWidth:(float)width onContext:(CGContextRef)ctx{
    float randomValueCofficeint     =   [NSNumber randomFloatInLimit:0.90 endLimit:2.00];
    float randomValueForSpace       =   width + [NSNumber randomFloatInLimit:20.00 endLimit:40.00];
    
    float rndShapeHorizontalWidth   =   imageSize.width*randomValueCofficeint;
    
    float rndShapeVerticalHeight    =   imageSize.height*randomValueCofficeint;;
    
    float topLeftEdgeStartXPt           =   (imageSize.width - rndShapeHorizontalWidth)/2 ;
    float topLeftEdgeStartYPt           =   (imageSize.height - rndShapeVerticalHeight)/2;
    
    float topLeftEdgeStartXPt1           =   (imageSize.width - rndShapeHorizontalWidth)/2 + randomValueForSpace;
    float topLeftEdgeStartYPt1           =   (imageSize.height - rndShapeVerticalHeight)/2 + randomValueForSpace/2;
    
    float topRightEdgeStartXPt          =   topLeftEdgeStartXPt + rndShapeHorizontalWidth;
    float topRightEdgeStartYPt          =   topLeftEdgeStartYPt;
    
    float topRightEdgeStartXPt1          =   topLeftEdgeStartXPt + rndShapeHorizontalWidth - randomValueForSpace;
    float topRightEdgeStartYPt1          =   topLeftEdgeStartYPt + randomValueForSpace/2;
    
    float bottomEdgeStartXPt            =   imageSize.width/2;
    float bottomEdgeStartYPt            =   topLeftEdgeStartXPt + rndShapeVerticalHeight;
    
    float bottomEdgeStartXPt1            =   imageSize.width/2 ;
    float bottomEdgeStartYPt1            =   topLeftEdgeStartXPt + rndShapeVerticalHeight - randomValueForSpace;
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGPathMoveToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topRightEdgeStartXPt, topRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomEdgeStartXPt, bottomEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGPathMoveToPoint(curvs, nil, topLeftEdgeStartXPt1, topLeftEdgeStartYPt1);
    CGPathAddLineToPoint(curvs, nil, topRightEdgeStartXPt1, topRightEdgeStartYPt1);
    CGPathAddLineToPoint(curvs, nil, bottomEdgeStartXPt1, bottomEdgeStartYPt1);
    CGPathAddLineToPoint(curvs, nil, topLeftEdgeStartXPt1, topLeftEdgeStartYPt1);
}

+(void)createLeftTriangleWithDoubleLine:(CGSize)imageSize onCurv:(CGMutablePathRef)curvs lineWidth:(float)width onContext:(CGContextRef)ctx{
    float randomValueCofficeint     =   [NSNumber randomFloatInLimit:0.90 endLimit:2.00];
    float randomValueForSpace       =   width + [NSNumber randomFloatInLimit:20.00 endLimit:40.00];
    
    float rndShapeHorizontalWidth   = imageSize.width*randomValueCofficeint;
    
    float rndShapeVerticalHeight    = imageSize.height*randomValueCofficeint;;
    
    float leftEdgeStartXPt           =   (imageSize.width - rndShapeHorizontalWidth)/2;
    float leftEdgeStartYPt           =   imageSize.height/2;
    
    float leftEdgeStartXPt1           =   (imageSize.width - rndShapeHorizontalWidth)/2 + randomValueForSpace;
    float leftEdgeStartYPt1           =   imageSize.height/2;
    
    float topRightEdgeStartXPt      =   leftEdgeStartXPt +  rndShapeHorizontalWidth;
    float topRightEdgeStartYPt      =   (imageSize.height - rndShapeVerticalHeight)/2 ;
    
    float topRightEdgeStartXPt1      =   leftEdgeStartXPt +  rndShapeHorizontalWidth - randomValueForSpace/2;
    float topRightEdgeStartYPt1      =   (imageSize.height - rndShapeVerticalHeight)/2 + randomValueForSpace;
    
    float bottonRightEdgeStartXPt    =   topRightEdgeStartYPt +  rndShapeVerticalHeight;
    float bottonRightEdgeStartYPt    =   topRightEdgeStartXPt;
    
    float bottonRightEdgeStartXPt1    =   topRightEdgeStartYPt +  rndShapeVerticalHeight - randomValueForSpace/2;
    float bottonRightEdgeStartYPt1    =   topRightEdgeStartXPt - randomValueForSpace;
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGPathMoveToPoint(curvs, nil, leftEdgeStartXPt, leftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topRightEdgeStartXPt, topRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottonRightEdgeStartXPt, bottonRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, leftEdgeStartXPt, leftEdgeStartYPt);
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGPathMoveToPoint(curvs, nil, leftEdgeStartXPt1, leftEdgeStartYPt1);
    CGPathAddLineToPoint(curvs, nil, topRightEdgeStartXPt1, topRightEdgeStartYPt1);
    CGPathAddLineToPoint(curvs, nil, bottonRightEdgeStartXPt1, bottonRightEdgeStartYPt1);
    CGPathAddLineToPoint(curvs, nil, leftEdgeStartXPt1, leftEdgeStartYPt1);
}

+(void)createRightTriangleWithDoubleLine:(CGSize)imageSize onCurv:(CGMutablePathRef)curvs lineWidth:(float)width onContext:(CGContextRef)ctx{
    float randomValueCofficeint     =   [NSNumber randomFloatInLimit:0.90 endLimit:2.00];
    float randomValueForSpace       =   width + [NSNumber randomFloatInLimit:20.00 endLimit:40.00];
    
    float rndShapeHorizontalWidth   =   imageSize.width*randomValueCofficeint;
    
    float rndShapeVerticalHeight    =   imageSize.height*randomValueCofficeint;;
    
    float topLeftEdgeStartXPt       =   (imageSize.width - rndShapeHorizontalWidth)/2;
    float topLeftEdgeStartYPt       =   (imageSize.height - rndShapeVerticalHeight)/2;
    
    float topLeftEdgeStartXPt1       =   (imageSize.width - rndShapeHorizontalWidth)/2 + randomValueForSpace/2;
    float topLeftEdgeStartYPt1       =   (imageSize.height - rndShapeVerticalHeight)/2 + randomValueForSpace;
    
    float bottomLeftEdgeStartXPt    =   (imageSize.width - rndShapeHorizontalWidth)/2;
    float bottomLeftEdgeStartYPt    =   topLeftEdgeStartYPt + rndShapeVerticalHeight;
    
    float bottomLeftEdgeStartXPt1    =   (imageSize.width - rndShapeHorizontalWidth)/2 + randomValueForSpace/2;
    float bottomLeftEdgeStartYPt1    =   topLeftEdgeStartYPt + rndShapeVerticalHeight - randomValueForSpace;
    
    float rightEdgeStartXPt         =   topLeftEdgeStartXPt + rndShapeHorizontalWidth;
    float rightEdgeStartYPt         =   imageSize.height/2;
    
    float rightEdgeStartXPt1         =   topLeftEdgeStartXPt + rndShapeHorizontalWidth - randomValueForSpace;
    float rightEdgeStartYPt1         =   imageSize.height/2;
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGPathMoveToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomLeftEdgeStartXPt, bottomLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, rightEdgeStartXPt, rightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGPathMoveToPoint(curvs, nil, topLeftEdgeStartXPt1, topLeftEdgeStartYPt1);
    CGPathAddLineToPoint(curvs, nil, bottomLeftEdgeStartXPt1, bottomLeftEdgeStartYPt1);
    CGPathAddLineToPoint(curvs, nil, rightEdgeStartXPt1, rightEdgeStartYPt1);
    CGPathAddLineToPoint(curvs, nil, topLeftEdgeStartXPt1, topLeftEdgeStartYPt1);
}

+(UIImage *)createTriangleShapeWithMultiLine:(CGSize)imageSize{
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //float rndWidthValue = [NSNumber randomFloatInLimit:0.0f endLimit:25.0f];
    float rndWidthValue = [NSNumber randomFloatInLimit:imageSize.width/100 endLimit:imageSize.width/150];

    CGContextSetLineWidth(ctx, rndWidthValue);
    
    int randomNumberForTriangleType = [NSNumber randomIntInLimit:0 endLimit:5];
    
    if (randomNumberForTriangleType == 1) {
//        float randomSpace   =   [NSNumber randomFloatInLimit:280.90 endLimit:400.00];
        float randomSpace = [NSNumber randomFloatInLimit:imageSize.width/4 endLimit:imageSize.width*1];

        float randomSpace1   =   randomSpace;
        randomSpace = imageSize.height + imageSize.height/2;
        
        while(randomSpace + randomSpace1 > 0){
            [self createBottomTriangleWithMultiLine:imageSize edgePoint:randomSpace lineWidth:rndWidthValue onContext:ctx randomSpace:randomSpace1];
            randomSpace = randomSpace - randomSpace1;
        }
    }
    else if(randomNumberForTriangleType == 2){
        
//        float randomSpace       =   [NSNumber randomFloatInLimit:280.90 endLimit:400.00];
        float randomSpace       =   [NSNumber randomFloatInLimit:imageSize.width/4 endLimit:imageSize.width*1];

        float randomSpace1      =   randomSpace;
        randomSpace             =   - imageSize.height/2;
        
        while(randomSpace - randomSpace1 < imageSize.height){
            [self createTopTriangleWithMultiLine:imageSize edgePoint:randomSpace lineWidth:rndWidthValue onContext:ctx randomSpace:randomSpace1];
            randomSpace = randomSpace + randomSpace1;
        }
    }
    else if(randomNumberForTriangleType == 3){
        
//        float randomSpace       =   [NSNumber randomFloatInLimit:280.90 endLimit:400.00];
        float randomSpace       =   [NSNumber randomFloatInLimit:imageSize.width/4 endLimit:imageSize.width*1];

        float randomSpace1      =   randomSpace;
        randomSpace = - imageSize.width/2;
        
        while(randomSpace - randomSpace1 <imageSize.width){
            [self createLeftTriangleWithMultiLine:imageSize edgePoint:randomSpace lineWidth:rndWidthValue onContext:ctx randomSpace:randomSpace1];
            randomSpace = randomSpace + randomSpace1;
        }
    }
    
    else if(randomNumberForTriangleType == 4){
//        float randomSpace       =   [NSNumber randomFloatInLimit:280.90 endLimit:400.00];
        float randomSpace       =   [NSNumber randomFloatInLimit:imageSize.width/4 endLimit:imageSize.width*1];

        float randomSpace1      =   randomSpace;
        randomSpace =  imageSize.width + imageSize.width/2;
        
        while(randomSpace + randomSpace1 > 0){
            [self createRightTriangleWithMultiLine:imageSize edgePoint:randomSpace lineWidth:rndWidthValue onContext:ctx randomSpace:randomSpace1];
            randomSpace = randomSpace - randomSpace1;
        }
    }
    else {
//        float randomSpace   =   [NSNumber randomFloatInLimit:280.90 endLimit:400.00];
        float randomSpace   =   [NSNumber randomFloatInLimit:imageSize.width/4 endLimit:imageSize.width*1];

        float randomSpace1   =   randomSpace;
        randomSpace = imageSize.height + imageSize.height/2;
        
        while(randomSpace + randomSpace1 > 0){
            [self createBottomTriangleWithMultiLine:imageSize edgePoint:randomSpace lineWidth:rndWidthValue onContext:ctx randomSpace:randomSpace1];
            randomSpace = randomSpace - randomSpace1;
        }
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+(void)createBottomTriangleWithMultiLine:(CGSize)imageSize edgePoint:(float)edgePoint lineWidth:(float)width onContext:(CGContextRef)ctx randomSpace:(float)space{
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
    
    float rndShapeHorizontalWidth   =   imageSize.width;
    
    float topLeftEdgeStartXPt           =   0;
    float topLeftEdgeStartYPt           =   0;
    
    float topRightEdgeStartXPt          =   rndShapeHorizontalWidth;
    float topRightEdgeStartYPt          =   0;
    
    float bottomLeftEdgeStartXPt           =   0;
    float bottomLeftEdgeStartYPt           =   edgePoint - space;
    
    float bottomRightEdgeStartXPt          =   rndShapeHorizontalWidth;
    float bottomRightEdgeStartYPt          =   edgePoint - space;
    
    float bottomMiddleStartXPt            =   imageSize.width/2;
    float bottomMiddleStartYPt            =   edgePoint;
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGPathMoveToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topRightEdgeStartXPt, topRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomRightEdgeStartXPt, bottomRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomMiddleStartXPt, bottomMiddleStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomLeftEdgeStartXPt, bottomLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
    
    CGPathCloseSubpath(curvs);
    
    CGContextAddPath(ctx, curvs);
    CGContextClip(ctx);
    
    CGContextStrokePath(ctx);
}

+(void)createTopTriangleWithMultiLine:(CGSize)imageSize edgePoint:(float)edgePoint lineWidth:(float)width onContext:(CGContextRef)ctx randomSpace:(float)space{
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
    
    float rndShapeHorizontalWidth   =   imageSize.width;
    
    float topMiddleStartXPt         =   imageSize.width/2;
    float topMiddleStartYPt         =   edgePoint;
    
    float topLeftEdgeStartXPt       =   0;
    float topLeftEdgeStartYPt       =   topMiddleStartYPt + space;
    
    float topRightEdgeStartXPt      =   rndShapeHorizontalWidth;
    float topRightEdgeStartYPt      =   topMiddleStartYPt + space;
    
    float bottomLeftEdgeStartXPt    =   0;
    float bottomLeftEdgeStartYPt    =   imageSize.height;
    
    float bottomRightEdgeStartXPt   =   rndShapeHorizontalWidth;
    float bottomRightEdgeStartYPt   =   imageSize.height;
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGPathMoveToPoint(curvs, nil, topMiddleStartXPt, topMiddleStartYPt);
    CGPathAddLineToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomLeftEdgeStartXPt, bottomLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomRightEdgeStartXPt, bottomRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topRightEdgeStartXPt, topRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topMiddleStartXPt, topMiddleStartYPt);
    
    CGPathCloseSubpath(curvs);
    
    CGContextAddPath(ctx, curvs);
    CGContextClip(ctx);
    
    CGContextStrokePath(ctx);
}

+(void)createLeftTriangleWithMultiLine:(CGSize)imageSize edgePoint:(float)edgePoint lineWidth:(float)width onContext:(CGContextRef)ctx randomSpace:(float)space{
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
    
    float middleStartXPt            =   edgePoint;
    float middleStartYPt            =   imageSize.height/2;
    
    float topLeftEdgeStartXPt       =   middleStartXPt + space;
    float topLeftEdgeStartYPt       =   0;
    
    float topRightEdgeStartXPt      =   imageSize.width;
    float topRightEdgeStartYPt      =   0;
    
    float bottomRightEdgeStartXPt   =   imageSize.width;
    float bottomRightEdgeStartYPt   =   imageSize.height;
    
    float bottomLeftEdgeStartXPt    =   middleStartXPt + space;
    float bottomLeftEdgeStartYPt    =   imageSize.height;
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGPathMoveToPoint(curvs, nil, middleStartXPt, middleStartYPt);
    CGPathAddLineToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topRightEdgeStartXPt, topRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomRightEdgeStartXPt, bottomRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomLeftEdgeStartXPt, bottomLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, middleStartXPt, middleStartYPt);
    
    CGPathCloseSubpath(curvs);
    
    CGContextAddPath(ctx, curvs);
    CGContextClip(ctx);
    
    CGContextStrokePath(ctx);
}

+(void)createRightTriangleWithMultiLine:(CGSize)imageSize edgePoint:(float)edgePoint lineWidth:(float)width onContext:(CGContextRef)ctx randomSpace:(float)space{
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
    
    float rndShapeHorizontalHeight   =   imageSize.height;
    
    float middleStartXPt         =   edgePoint;
    float middleStartYPt         =   imageSize.height/2;
    
    float topLeftEdgeStartXPt       =   0;
    float topLeftEdgeStartYPt       =   0;
    
    float topRightEdgeStartXPt      =   middleStartXPt - space;
    float topRightEdgeStartYPt      =   0;
    
    float bottomLeftEdgeStartXPt    =   0;
    float bottomLeftEdgeStartYPt    =   imageSize.height;
    
    float bottomRightEdgeStartXPt   =   middleStartXPt - space;
    float bottomRightEdgeStartYPt   =   imageSize.height;
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGPathMoveToPoint(curvs, nil, middleStartXPt, middleStartYPt);
    CGPathAddLineToPoint(curvs, nil, topRightEdgeStartXPt, topRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, topLeftEdgeStartXPt, topLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomLeftEdgeStartXPt, bottomLeftEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, bottomRightEdgeStartXPt, bottomRightEdgeStartYPt);
    CGPathAddLineToPoint(curvs, nil, middleStartXPt, middleStartYPt);
    
    CGPathCloseSubpath(curvs);
    
    CGContextAddPath(ctx, curvs);
    CGContextClip(ctx);
    
    CGContextStrokePath(ctx);
}

+(void)drawSpaceColor:(UIColor *)color onContext:(CGContextRef )ctx{
    int rndValueForShape = [NSNumber randomIntInLimit:1 endLimit:10];
    
    if(rndValueForShape % 2 == 0){
        CGContextSetFillColorWithColor(ctx, color.CGColor);
    }
    else
    {
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor);
    }
    
    CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
}

+(void)drawRemoveableContextColor:(CGContextRef )ctx{
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
}

//****************************************** Draw Circle or eclipe ******************************************//


+(void)drawCirculerShapes:(CGRect)rect onContext:(CGContextRef)ctx{
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);

    CGContextBeginPath(ctx);
    float rndValue = [NSNumber randomFloatInLimit:5.0f endLimit:20.0f];
//    float randomSpace   =   [NSNumber randomFloatInLimit:imageSize.width/4 endLimit:imageSize.width*1];

    CGContextSetLineWidth(ctx, rndValue);
    CGContextFillEllipseInRect(ctx, rect);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

+(void)drawCirculerShapesForMultiLine:(CGRect)rect onContext:(CGContextRef)ctx lineWidth:(float)width{
    CGContextBeginPath(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    
    CGContextSetLineWidth(ctx, width);
    //CGContextFillEllipseInRect(ctx, rect);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

/*
 ******************
 */

+(void)drawRoundedCornerShapesWithoutSettingStrokColor:(CGRect)rect onContext:(CGContextRef)context withRadius1:(CGFloat)radius1 withRadius2:(CGFloat)radius2 {
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

+(void)drawRoundedCornerShapesWithoutSettingStrokColorForMultiLine:(CGRect)rect onContext:(CGContextRef)context withRadius1:(CGFloat)radius1 withRadius2:(CGFloat)radius2 lineWidth:(float)width{
    CGContextSetLineWidth(context, width);
    
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
