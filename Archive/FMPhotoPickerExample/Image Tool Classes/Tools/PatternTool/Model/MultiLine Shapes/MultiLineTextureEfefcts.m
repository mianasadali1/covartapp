//
//  MultiLineTextureEfefcts.m
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 05/12/15.
//  Copyright © 2015 Kanwarpal Singh. All rights reserved.
//

#import "MultiLineTextureEfefcts.h"
#import "UIColor+HexColors.h"
#import "UIImage+Utility.h"
#import "NSString+RandomStringGenrator.h"

@implementation MultiLineTextureEfefcts

#pragma mark gradient shapes with Double Lines

//************************* Create all Double line shapes with gradient or single color ***********************************//

+(UIImage *)generateImage:(CGSize)imageSize effectId:(int)effectId{
    int rndForShape = [NSNumber randomIntInLimit:0 endLimit:4];
    //int rndForShape = 5;
    
    UIImage *img;
    
    if(effectId == 40){
        //40
        img = [self createPantagonShapeWithDoubleLineWithTexture:imageSize];
    }
    else if(effectId == 41){
        //41
        img = [self createGradientShapesWithDoubleLinesWithTexture:imageSize randomShapeType:1];
    }
    else if(effectId == 42){
        //42
        img = [self createGradientShapesWithDoubleLinesWithTexture:imageSize randomShapeType:2];
    }
    else if(effectId == 43){
        //43
        img = [self createGradientShapesWithDoubleLinesWithTexture:imageSize randomShapeType:3];
    }
    else if(effectId == 44){
        //44
        img = [self createHexgonShapeWithDoubleLineWithTexture:imageSize];
    }
    else{
        img = [self createGradientShapesWithDoubleLinesWithTexture:imageSize randomShapeType:1];
    }
    
    return img;
}

+(UIImage *)createPantagonShapeWithDoubleLineWithTexture:(CGSize)imageSize{

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
    
    float randomValueCofficeint = [NSNumber randomFloatInLimit:0.80 endLimit:1.40];
    
    float rndShapeHorizontalWidth = imageSize.width*randomValueCofficeint;
    
    float rndShapeVerticalHeight = imageSize.height*randomValueCofficeint;
    
    float rndValue = 20;
    CGContextSetLineWidth(ctx, rndValue);
    
    float maxRadius = rndShapeHorizontalWidth > rndShapeVerticalHeight ? rndShapeHorizontalWidth : rndShapeVerticalHeight;
    
    float currentRadius = maxRadius;
    
    CGMutablePathRef curvs = CGPathCreateMutable();
    
    [self generatePantagonWithDoubleLineWithTexture:imageSize onContext:ctx withHt:currentRadius withWidth:currentRadius PATH:curvs];
    [self generatePantagonWithDoubleLineWithTexture:imageSize onContext:ctx withHt:currentRadius - (5*rndValue) withWidth:currentRadius - (5*rndValue) PATH:curvs];
    
    
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
    // Background Mountain Stroking
    CGContextAddPath(ctx, curvs);
    
    
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *img = [UIImage removeGradientColor:result];
    
    return img;
}

+(void)generatePantagonWithDoubleLineWithTexture:(CGSize )imgSize onContext:(CGContextRef )context withHt:(float)ht withWidth:(float)width PATH:(CGMutablePathRef)curvs{
    
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

+(UIImage *)createHexgonShapeWithDoubleLineWithTexture:(CGSize)imageSize{
    
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
    
    float maxRadius = rndShapeHorizontalWidth > rndShapeVerticalHeight ? rndShapeHorizontalWidth : rndShapeVerticalHeight;
    
    float currentRadius = maxRadius;
    //float rndValue = [NSNumber randomFloatInLimit:4.0f endLimit:15.0f];
    float rndValue = [NSNumber randomFloatInLimit:imageSize.width/600 endLimit:imageSize.width/170];

    CGContextSetLineWidth(ctx, rndValue);
    
    [self generateHexagonWithDoubleLineWithTexture:imageSize onContext:ctx withHt:maxRadius withWidth:maxRadius onPath:curvs];
    
    [self generateHexagonWithDoubleLineWithTexture:imageSize onContext:ctx withHt:currentRadius - (5*rndValue) withWidth:currentRadius - (5*rndValue) onPath:curvs];
    
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
    // Background Mountain Stroking
    CGContextAddPath(ctx, curvs);
    
    
    CGContextStrokePath(ctx);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *img = [UIImage removeGradientColor:result];
    
    return img;
}

+(void)generateHexagonWithDoubleLineWithTexture:(CGSize )imgSize onContext:(CGContextRef )context withHt:(float)ht withWidth:(float)width onPath:(CGMutablePathRef)curvs{
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

+(UIImage *)createGradientShapesWithDoubleLinesWithTexture:(CGSize)imageSize randomShapeType:(int)randomShapeType{
    
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
    
   // float rndValue = [NSNumber randomFloatInLimit:5.0f endLimit:20.0f];
    float rndValue   =   [NSNumber randomFloatInLimit:imageSize.width/500 endLimit:imageSize.width/80];
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
                 
                
                [self drawSpaceColor:color onContext:ctx];
                
                [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:maxRadius withRadius2:maxRadius];
                
                [self drawRemoveableContextColor:ctx];
                
                [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle2 onContext:ctx withRadius1:maxRadius withRadius2:maxRadius];
            }
            if(rounConrnerType == 2){
                int randomNum = [NSNumber randomIntInLimit:1 endLimit:10];
                if(randomNum % 2 == 0){
                     
                    
                    [self drawSpaceColor:color onContext:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:roundXRadius withRadius2:roundYRadius];
                    
                    [self drawRemoveableContextColor:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:roundXRadius withRadius2:roundYRadius];
                }
                else {
                     
                    
                    [self drawSpaceColor:color onContext:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:roundYRadius withRadius2:roundXRadius];
                    
                    [self drawRemoveableContextColor:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle2 onContext:ctx withRadius1:roundYRadius withRadius2:roundXRadius];
                }
            }
            if(rounConrnerType >= 3){
                int randomNum = [NSNumber randomIntInLimit:1 endLimit:10];
                if(randomNum % 2 == 0){
                    
                     
                    
                    [self drawSpaceColor:color onContext:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:roundXRadius withRadius2:0];
                    
                    [self drawRemoveableContextColor:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle2 onContext:ctx withRadius1:roundXRadius withRadius2:0];
                }
                else {
                     
                    
                    [self drawSpaceColor:color onContext:ctx];
                    
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
        
        //int randomShapeType = [NSNumber randomIntInLimit:1 endLimit:4];
        if(randomShapeType == 1){
            //draw circles or ellipse
            
            [self drawSpaceColor:color onContext:ctx];
            
            [self drawCirculerShapes:rectangle1 onContext:ctx];
            
            [self drawRemoveableContextColor:ctx];
            
            [self drawCirculerShapes:rectangle2 onContext:ctx];
        }
        else if(randomShapeType == 2){
             
            
            [self drawSpaceColor:color onContext:ctx];
            
            [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:0 withRadius2:0];
            
            [self drawRemoveableContextColor:ctx];
            
            [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle2 onContext:ctx withRadius1:0 withRadius2:0];
        }
        else if(randomShapeType == 3){
             
            
            [self drawSpaceColor:color onContext:ctx];
            
            float getRandomWidthRadiusFloatValue = [RandomObjects getRandomRadiusSize];
            float getRandomHeightRadiusFloatValue = [RandomObjects getRandomRadiusSize];
            
            int roundRadius1 = radiusRandomValue*getRandomWidthRadiusFloatValue;
            int roundRadius2 = radiusRandomValue*getRandomHeightRadiusFloatValue;
            
            int rounConrnerType = [NSNumber randomIntInLimit:1 endLimit:7];
            
            if(rounConrnerType == 1){
                int maxRadius = MIN(roundRadius1, MIN(roundRadius1, roundRadius2));
                
                 
                
                [self drawSpaceColor:color onContext:ctx];
                
                [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:maxRadius withRadius2:maxRadius];
                
                [self drawRemoveableContextColor:ctx];
                
                [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle2 onContext:ctx withRadius1:maxRadius withRadius2:maxRadius];
            }
            if(rounConrnerType == 2){
                int randomNum = [NSNumber randomIntInLimit:1 endLimit:10];
                if(randomNum % 2 == 0){
                     
                    
                    [self drawSpaceColor:color onContext:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:roundRadius1 withRadius2:roundRadius2];
                    
                    [self drawRemoveableContextColor:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle2 onContext:ctx withRadius1:roundRadius1 withRadius2:roundRadius2];
                }
                else {
                     
                    
                    [self drawSpaceColor:color onContext:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:roundRadius2 withRadius2:roundRadius1];
                    
                    [self drawRemoveableContextColor:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle2 onContext:ctx withRadius1:roundRadius2 withRadius2:roundRadius1];
                }
            }
            if(rounConrnerType >= 3){
                int randomNum = [NSNumber randomIntInLimit:1 endLimit:10];
                if(randomNum % 2 == 0){
                     
                    
                    [self drawSpaceColor:color onContext:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle1 onContext:ctx withRadius1:roundRadius1 withRadius2:0];
                    
                    [self drawRemoveableContextColor:ctx];
                    
                    [self drawRoundedCornerShapesWithoutSettingStrokColor:rectangle2 onContext:ctx withRadius1:roundRadius1 withRadius2:0];
                }
                else {
                     
                    
                    [self drawSpaceColor:color onContext:ctx];
                    
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
    CGContextBeginPath(ctx);
    float rndValue = [NSNumber randomFloatInLimit:5.0f endLimit:20.0f];
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
