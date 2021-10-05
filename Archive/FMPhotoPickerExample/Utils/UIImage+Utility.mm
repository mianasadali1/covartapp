//
//  UIImage+Utility.m
//
//  Created by sho yakushiji on 2013/05/17.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "UIImage+Utility.h"

#import <Accelerate/Accelerate.h>

//#import <opencv2/core.hpp>
//#import <opencv2/imgcodecs/ios.h>
//#import <opencv2/imgproc.hpp>
//#ifdef __cplusplus
//#import <opencv2/opencv.hpp>
//#endif



@implementation UIImage (Utility)

+(UIImage*)changeColorOfImage:(UIImage*)image{
//    cv::Mat updatedMat;
//    cv::Mat originalMat;
    
    double r = 0.5 + RAND_0_1() * 1.0;
    double g = 0.6 + RAND_0_1() * 0.8;
    double b = 0.4 + RAND_0_1() * 1.2;
//    cv::Scalar randomColor(r, g, b);
//
//    UIImage *img =  [image copy];
//
//    UIImageToMat(img, originalMat);
//    cv::multiply(originalMat, randomColor, updatedMat);
//    img   =   MatToUIImage(updatedMat);
//    return img;
    
    
    CGContextRef ctx;
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    char *rawData = (char*)malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * 0) + 0 * bytesPerPixel;
    
    
    for (int ii = 0 ; ii < width * height ; ++ii)
    {
        // Get color values to construct a UIColor
        CGFloat red   = (rawData[byteIndex]     * 1.0) ;
        CGFloat green = (rawData[byteIndex + 1] * 1.0);
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) ;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) ;
        
        rawData[byteIndex] = (char) red * r;
        rawData[byteIndex+1] = (char) green * g;
        rawData[byteIndex+2] = (char) blue * b;
        
        byteIndex += 4;
    }
    
    ctx = CGBitmapContextCreate(rawData,
                                CGImageGetWidth( imageRef ),
                                CGImageGetHeight( imageRef ),
                                8,
                                CGImageGetBytesPerRow( imageRef ),
                                CGImageGetColorSpace( imageRef ),
                                kCGImageAlphaPremultipliedLast );
    
    imageRef = CGBitmapContextCreateImage (ctx);
    UIImage* rawImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    free(rawData);
    return rawImage;
}

+ (UIImage*)decode:(UIImage*)image
{
    if(image==nil){  return nil; }
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    {
        [image drawAtPoint:CGPointMake(0, 0)];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*)fastImageWithData:(NSData *)data
{
    UIImage *image = [UIImage imageWithData:data];
    return [self decode:image];
}

+ (UIImage*)fastImageWithContentsOfFile:(NSString*)path
{
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    return [self decode:image];
}

#pragma mark- Copy

- (UIImage*)deepCopy
{
    return [UIImage decode:self];
}

#pragma mark- GrayScale

- (UIImage*)grayScaleImage
{
    CGRect imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, self.size.width, self.size.height, 8, 0, colorSpace, kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(context, imageRect, [self CGImage]);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    return newImage;
}

#pragma mark- Resizing

- (UIImage*)resizeWithoutAspectRatio:(CGSize)size
{
    CGRect scaledImageRect = CGRectZero;
        
    scaledImageRect.size.width = self.size.width ;
    scaledImageRect.size.height = self.size.height;
    scaledImageRect.origin.x = 0;
    scaledImageRect.origin.y = 0;
    
    UIGraphicsBeginImageContextWithOptions( size, NO, self.scale );
    [self drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}


- (UIImage*)resize:(CGSize)size
{
    CGRect scaledImageRect = CGRectZero;
    
    CGFloat aspectWidth = size.width / self.size.width;
    CGFloat aspectHeight = size.height / self.size.height;
    CGFloat aspectRatio = MIN ( aspectWidth, aspectHeight );
    
    scaledImageRect.size.width = self.size.width * aspectRatio;
    scaledImageRect.size.height = self.size.height * aspectRatio;
    scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0f;
    scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0f;
    
    UIGraphicsBeginImageContextWithOptions( size, NO, self.scale );
    [self drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage*)aspectFit:(CGSize)size
{
    CGFloat ratio = MIN(size.width/self.size.width, size.height/self.size.height);
    return [self resize:CGSizeMake(self.size.width*ratio, self.size.height*ratio)];
}

- (UIImage*)aspectFill:(CGSize)size
{
    return [self aspectFill:size offset:0];
}

- (UIImage*)aspectFill:(CGSize)size offset:(CGFloat)offset
{
    int W  = size.width;
    int H  = size.height;
    int W0 = self.size.width;
    int H0 = self.size.height;
    
    CGImageRef   imageRef = self.CGImage;
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, W, H, 8, 4*W, colorSpaceInfo, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    
    if(self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationRight){
        W  = size.height;
        H  = size.width;
        W0 = self.size.height;
        H0 = self.size.width;
    }
    
    double ratio = MAX(W/(double)W0, H/(double)H0);
    W0 = ratio * W0;
    H0 = ratio * H0;
    
    int dW = abs((W0-W)/2);
    int dH = abs((H0-H)/2);
    
    if(dW==0){ dH += offset; }
    if(dH==0){ dW += offset; }
    
    if(self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationLeftMirrored){
        CGContextRotateCTM (bitmap, M_PI/2);
        CGContextTranslateCTM (bitmap, 0, -H);
    }
    else if (self.imageOrientation == UIImageOrientationRight || self.imageOrientation == UIImageOrientationRightMirrored){
        CGContextRotateCTM (bitmap, -M_PI/2);
        CGContextTranslateCTM (bitmap, -W, 0);
    }
    else if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationUpMirrored){
        // Nothing
    }
    else if (self.imageOrientation == UIImageOrientationDown || self.imageOrientation == UIImageOrientationDownMirrored){
        CGContextTranslateCTM (bitmap, W, H);
        CGContextRotateCTM (bitmap, -M_PI);
    }
    
    CGContextDrawImage(bitmap, CGRectMake(-dW, -dH, W0, H0), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}

#pragma mark- Clipping

- (UIImage*)crop:(CGRect)rect
{
    CGPoint origin = CGPointMake(-rect.origin.x, -rect.origin.y);
    
    UIImage *img = nil;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
    [self drawAtPoint:origin];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


- (UIImage*)squareImage
{
    CGRect rect;
    CGFloat height = self.size.height;
    CGFloat width = self.size.width;
    
    if(height > width){
        rect = CGRectMake(0, (height - width)/2, width, width);
    }
    else{
        rect = CGRectMake((width - height)/2,0 , height, height);
    }
    
    CGPoint origin = CGPointMake(-rect.origin.x, -rect.origin.y);
    
    UIImage *img = nil;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
    [self drawAtPoint:origin];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark- Masking

- (UIImage*)maskedImage:(UIImage*)maskImage
{
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskImage.CGImage),
                                        CGImageGetHeight(maskImage.CGImage),
                                        CGImageGetBitsPerComponent(maskImage.CGImage),
                                        CGImageGetBitsPerPixel(maskImage.CGImage),
                                        CGImageGetBytesPerRow(maskImage.CGImage),
                                        CGImageGetDataProvider(maskImage.CGImage), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask(self.CGImage, mask);
    
    UIImage *result = [UIImage imageWithCGImage:masked];
    
    CGImageRelease(mask);
    CGImageRelease(masked);
    
    return result;
}

+(UIImage *)changeAlphaOfImage:(UIImage *)img withAlpha:(double)alpha{
    
    UIGraphicsBeginImageContextWithOptions(img.size, NO, [[UIScreen mainScreen] scale]);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, img.size.width, img.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, img.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark- Blur

//- (UIImage *)blurredImageWithImage:(UIImage *)sourceImage{
//
//
//}

- (UIImage*)gaussBlur:(CGFloat)blurLevel
{
    //  Create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    
    //  Setting up Gaussian Blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:blurLevel] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    /*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
     *  up exactly to the bounds of our original image */
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *retVal = [UIImage imageWithCGImage:cgImage];
    
    if (cgImage) {
        CGImageRelease(cgImage);
    }
    
    return retVal;
}

+(UIImage *)removeWhiteColor:(UIImage*)img{
    CGImageRef rawImageRef = img.CGImage;
    const CGFloat colorMasking[6] = { 254.0, 254.0, 254.0, 254.0, 254.0, 254.0 };
    
    UIGraphicsBeginImageContextWithOptions(img.size, YES, [img scale]);
    
    CGImageRef maskedImageRef =  CGImageCreateWithMaskingColors(rawImageRef, colorMasking);
    {
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, img.size.height);
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    }
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, img.size.width, img.size.height), maskedImageRef);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    CFGetRetainCount(maskedImageRef);
    CGImageRelease(maskedImageRef);
    UIGraphicsEndImageContext();
    return result;
}


+(UIImage *)removeGradientColor:(UIImage*)img{
    CGImageRef rawImageRef = img.CGImage;
    const CGFloat colorMasking[6] = { 252.0, 255.0, 252.0, 255.0, 252.0, 255.0 };
    
    UIGraphicsBeginImageContextWithOptions(img.size, YES, [img scale]);
    
    CGImageRef maskedImageRef =  CGImageCreateWithMaskingColors(rawImageRef, colorMasking);
    {
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, img.size.height);
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    }
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, img.size.width, img.size.height), maskedImageRef);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    CFGetRetainCount(maskedImageRef);
    CGImageRelease(maskedImageRef);
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [[UIScreen mainScreen] scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageFromColor:(UIColor *)color withSize:(CGSize)withSize{
    CGRect rect = CGRectMake(0, 0, withSize.width, withSize.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [[UIScreen mainScreen] scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)drawImage:(UIImage *)inputImage inRect:(CGRect)frame {
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, inputImage.scale);
    [inputImage drawInRect:frame];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)drawImageNoScale:(UIImage *)inputImage inRect:(CGRect)frame {
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
    [inputImage drawInRect:frame];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageByRemovingColor:(uint)color {
    return [self imageByRemovingColorsWithMinColor:color maxColor:color];
}

- (UIImage *)imageByRemovingColorsWithMinColor:(uint)minColor maxColor:(uint)maxColor {
    return [self imageByReplacingColorsWithMinColor:minColor maxColor:maxColor withColor:0 andAlpha:0];
}

- (UIImage *)imageByReplacingColor:(uint)color withColor:(uint)newColor {
    return [self imageByReplacingColorsWithMinColor:color maxColor:color withColor:newColor];
}

- (UIImage *)imageByReplacingColorsWithMinColor:(uint)minColor maxColor:(uint)maxColor withColor:(uint)newColor {
    return [self imageByReplacingColorsWithMinColor:minColor maxColor:maxColor withColor:newColor andAlpha:1.0f];
}

- (UIImage *)imageByReplacingColorsWithMinColor:(uint)minColor maxColor:(uint)maxColor withColor:(uint)newColor andAlpha:(float)alpha {
    CGImageRef imageRef = self.CGImage;
    float width = CGImageGetWidth(imageRef);
    float height = CGImageGetHeight(imageRef);
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat minRed = (CGFloat)COLOR_PART_RED(minColor) - 5;
    CGFloat minGreen = (CGFloat)COLOR_PART_GREEN(minColor) - 5;
    CGFloat minBlue = (CGFloat)COLOR_PART_BLUE(minColor) - 5;
    CGFloat maxRed = (CGFloat)COLOR_PART_RED(maxColor) + 5;
    CGFloat maxGreen = (CGFloat)COLOR_PART_GREEN(maxColor) + 5;
    CGFloat maxBlue = (CGFloat)COLOR_PART_BLUE(maxColor) + 5;
    CGFloat newRed = (CGFloat)COLOR_PART_RED(newColor)/255.0f;
    CGFloat newGreen = (CGFloat)COLOR_PART_GREEN(newColor)/255.0f;
    CGFloat newBlue = (CGFloat)COLOR_PART_BLUE(newColor)/255.0f;
    
    CGContextRef context = nil;
    
    if (alpha) {
        context = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), CGImageGetColorSpace(imageRef), CGImageGetBitmapInfo(imageRef));
        CGContextSetRGBFillColor(context, newRed, newGreen, newBlue, alpha);
        CGContextFillRect(context, bounds);
    }
    const CGFloat maskingColors[6] = {minRed, maxRed, minGreen, maxGreen, minBlue, maxBlue};
    CGImageRef maskedImageRef = CGImageCreateWithMaskingColors(imageRef, maskingColors);
    if (!maskedImageRef) return nil;
    if (alpha) CGContextDrawImage(context, bounds, maskedImageRef);
    CGImageRef newImageRef = (alpha)?CGBitmapContextCreateImage(context):maskedImageRef;
    if (context) CGContextRelease(context);
    if (newImageRef != maskedImageRef) CGImageRelease(maskedImageRef);
    
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}

- (UIImage *)imageWithTint:(UIColor *)tintColor
{
    // Begin drawing
    CGRect aRect = CGRectMake(0.f, 0.f, self.size.width, self.size.height);
    CGImageRef alphaMask;
    
    //
    // Compute mask flipping image
    //
    {
        UIGraphicsBeginImageContext(aRect.size);
        CGContextRef c = UIGraphicsGetCurrentContext();
        
        // draw image
        CGContextTranslateCTM(c, 0, aRect.size.height);
        CGContextScaleCTM(c, 1.0, -1.0);
        [self drawInRect: aRect];
        
        alphaMask = CGBitmapContextCreateImage(c);
        
        UIGraphicsEndImageContext();
    }
    
    //
    UIGraphicsBeginImageContext(aRect.size);
    
    // Get the graphic context
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    // Draw the image
    [self drawInRect:aRect];
    
    // Mask
    CGContextClipToMask(c, aRect, alphaMask);
    
    // Set the fill color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextSetFillColorSpace(c, colorSpace);
    
    // Set the fill color
    CGContextSetFillColorWithColor(c, tintColor.CGColor);
    
    UIRectFillUsingBlendMode(aRect, kCGBlendModeNormal);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Release memory
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(alphaMask);
    
    return img;
}


@end

void safe_dispatch_sync_main(DISPATCH_NOESCAPE dispatch_block_t block)
{
    if([NSThread isMainThread]){
        block();
    }
    else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}
