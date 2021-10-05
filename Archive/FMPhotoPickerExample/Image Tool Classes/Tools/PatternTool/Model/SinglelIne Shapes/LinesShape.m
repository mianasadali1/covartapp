//
//  LinesShape.m
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 05/12/15.
//  Copyright © 2015 Kanwarpal Singh. All rights reserved.
//

#import "LinesShape.h"
#import "UIImage+Utility.h"

@implementation LinesShape

#pragma mark Liner Effects

//************************************************************** Lines effects **************************************************************//

+(UIImage *)generateImage:(CGSize)sourceImgSzie effectId:(int)effectId{
    //15
    int rndSquarePosition = [NSNumber randomIntInLimit:1 endLimit:10];
    
    UIImage *img;
    
    if(rndSquarePosition % 2 == 0){
        img = [self verticalyLinesWithRandomSize:sourceImgSzie];
    }
    else{
        img = [self horizontalyLinesWithRandomSize:sourceImgSzie];
    }
    
    return img;
}

+(UIImage *)verticalyLinesWithRandomSize:(CGSize)sourceImgSize{
    
    CGFloat imgWidth    =   sourceImgSize.width;
    CGFloat imgHeight   =   sourceImgSize.height;
    
    int segmentNumber   =   [NSNumber randomIntInLimit:2 endLimit:10];
    
    float equalHeightValue  =   imgHeight/segmentNumber;
    
    // build merged size
    CGSize mergedSize       =   CGSizeMake(imgWidth, imgHeight);
    
    // capture image context ref
    UIGraphicsBeginImageContextWithOptions(mergedSize, YES, [[UIScreen mainScreen] scale]);

    float currentSegmentPosition    =   0;
    
    NSMutableArray *colorArr        =   [[NSMutableArray alloc]init];
    for(int i = 0; i < segmentNumber; i++){
        float imgAlpha1 = 1;
        int blendType = 0;
        
        NSString *colorHex = [NSString randomHexString];
        
        while ([colorArr containsObject:colorHex]) {
            colorHex = [NSString randomHexString];
        }
        
        UIImage *gradientImg1 = [UIImage imageFromColor:RANDOM_COLOR];
        [gradientImg1 drawInRect:CGRectMake(0, currentSegmentPosition, imgWidth, equalHeightValue) blendMode:blendType alpha:imgAlpha1];
        currentSegmentPosition += equalHeightValue;
        [colorArr addObject:colorHex];
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end context
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage *)horizontalyLinesWithRandomSize:(CGSize)sourceImgSize{
    CGFloat imgWidth = sourceImgSize.width;
    CGFloat imgHeight = sourceImgSize.height;
    
    int segmentNumber = [NSNumber randomIntInLimit:2 endLimit:10];
    
    float equalWidhValue = imgWidth/segmentNumber;
    
    // build merged size
    CGSize mergedSize = CGSizeMake(imgWidth, imgHeight);
    
    // capture image context ref
    UIGraphicsBeginImageContextWithOptions(mergedSize, YES, [[UIScreen mainScreen] scale]);

    float currentSegmentPosition = 0;

    NSMutableArray *colorArr = [[NSMutableArray alloc]init];
    for(int i = 0; i < segmentNumber; i++){
        float imgAlpha1 = 1;
        int blendType = 0;
        
        NSString *colorHex = [NSString randomHexString];
        while ([colorArr containsObject:colorHex]) {
            colorHex = [NSString randomHexString];
        }
        UIImage *gradientImg1 = [UIImage imageFromColor:RANDOM_COLOR];
        [gradientImg1 drawInRect:CGRectMake(currentSegmentPosition, 0, equalWidhValue, imgHeight) blendMode:blendType alpha:imgAlpha1];
        currentSegmentPosition += equalWidhValue;
        [colorArr addObject:colorHex];
    }
    // assign context to new UIImage
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end context
    UIGraphicsEndImageContext();
    return newImage;
}


@end
