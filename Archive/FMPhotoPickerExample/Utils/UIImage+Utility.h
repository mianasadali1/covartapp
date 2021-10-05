//
//  UIImage+Utility.h
//
//  Created by sho yakushiji on 2013/05/17.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#define COLOR_PART_RED(color)    (((color) >> 16) & 0xff)
#define COLOR_PART_GREEN(color)  (((color) >>  8) & 0xff)
#define COLOR_PART_BLUE(color)   ( (color)        & 0xff)

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#define RAND_0_1() ((double)arc4random() / 0x100000000)

@interface UIImage (Utility)
+(UIImage*)changeColorOfImage:(UIImage*)image;
+ (UIImage*)fastImageWithData:(NSData*)data;
+ (UIImage*)fastImageWithContentsOfFile:(NSString*)path;
- (UIImage *)imageWithTint:(UIColor *)tintColor;

- (UIImage*)deepCopy;

- (UIImage*)grayScaleImage;
- (UIImage*)squareImage;
- (UIImage*)resizeWithoutAspectRatio:(CGSize)size;
- (UIImage*)resize:(CGSize)size;
- (UIImage*)aspectFit:(CGSize)size;
- (UIImage*)aspectFill:(CGSize)size;
- (UIImage*)aspectFill:(CGSize)size offset:(CGFloat)offset;

- (UIImage*)crop:(CGRect)rect;

- (UIImage*)maskedImage:(UIImage*)maskImage;

- (UIImage*)gaussBlur:(CGFloat)blurLevel;       //  {blurLevel | 0 ≤ t ≤ 1}
+(UIImage *)removeGradientColor:(UIImage*)img;
+(UIImage *)removeWhiteColor:(UIImage*)img;
+ (UIImage *)imageFromColor:(UIColor *)color;
+(UIImage *)imageFromColor:(UIColor *)color withSize:(CGSize)withSize;
+(UIImage *)changeAlphaOfImage:(UIImage *)img withAlpha:(double)alpha;
+ (UIImage *)drawImage:(UIImage *)inputImage inRect:(CGRect)frame;
+ (UIImage *)drawImageNoScale:(UIImage *)inputImage inRect:(CGRect)frame ;




- (UIImage *)imageByRemovingColor:(uint)color;
- (UIImage *)imageByRemovingColorsWithMinColor:(uint)minColor maxColor:(uint)maxColor;
- (UIImage *)imageByReplacingColor:(uint)color withColor:(uint)newColor;
- (UIImage *)imageByReplacingColorsWithMinColor:(uint)minColor maxColor:(uint)maxColor withColor:(uint)newColor;
- (UIImage *)imageByReplacingColorsWithMinColor:(uint)minColor maxColor:(uint)maxColor withColor:(uint)newColor andAlpha:(float)alpha;

@end

void safe_dispatch_sync_main(DISPATCH_NOESCAPE dispatch_block_t block);

