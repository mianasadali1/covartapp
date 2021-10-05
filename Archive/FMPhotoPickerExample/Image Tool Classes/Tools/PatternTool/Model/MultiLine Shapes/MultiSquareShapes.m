//
//  MultiSquareShapes.m
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 15/12/15.
//  Copyright © 2015 Kanwarpal Singh. All rights reserved.
//

#import "MultiSquareShapes.h"
#import "NSString+RandomStringGenrator.h"

@implementation MultiSquareShapes

+(UIImage *)generateImage:(CGSize)imageSize effectId:(NSUInteger)effectId{
    //5
    
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0, 0);
    
    int rndSquareNumbers = [NSNumber randomIntInLimit:2 endLimit:6];
    
    float squareHeight  = imageSize.height/rndSquareNumbers;
    float squareWidth   = imageSize.width/rndSquareNumbers;

    int squareStrXPt = 0;
    int squareStrYPt = 0;
    
    while (squareStrYPt < imageSize.height) {
        while (squareStrXPt < imageSize.width) {
            CGRect rectangle = CGRectMake(squareStrXPt,squareStrYPt,squareWidth,squareHeight);
            [self drawSquareAtRect:rectangle onContext:ctx];
            squareStrXPt = squareStrXPt + squareWidth + 1;
        }
        squareStrXPt = 0;
        squareStrYPt = squareStrYPt + squareHeight + 1;
    }

    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+(void)drawSquareAtRect:(CGRect)rect onContext:(CGContextRef)ctx{
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
    CGContextSetStrokeColorWithColor(ctx, RANDOM_COLOR.CGColor);
    CGContextSetFillColorWithColor(ctx, RANDOM_COLOR.CGColor);
    CGContextFillRect(ctx, rect);
}

@end
