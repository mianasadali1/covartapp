//
//  CIFilter+Filter.m
//  BasicFilters
//
//  Created by Kanwar on 6/28/18.
//  Copyright © 2018 Kanwarpal Singh. All rights reserved.
//

#import "CIFilter+Filter.h"

@implementation CIFilter (Filter)

+(UIImage*)filter1:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha withBlendMode:(CGBlendMode)withBlendMode{
    CGBlendMode filterName    =   withBlendMode;
    // UIImage *image = blurImage;
    CGSize newSize = CGSizeMake(onImage.size.width, onImage.size.height);
    UIGraphicsBeginImageContext( newSize );
    [onImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    [filterImg drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:filterName alpha:0.2];
    UIImage *blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CIImage *img = [CIImage imageWithData:UIImagePNGRepresentation(blendedImage)];
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey,img, nil];
    [filter setValue: @0.25f forKey: kCIInputIntensityKey];
    
    filter = [CIFilter filterWithName:@"CIHueAdjust"
                        keysAndValues: kCIInputImageKey,filter.outputImage,
              @"inputAngle", [NSNumber numberWithFloat:0.2],nil];
    
    CIFilter * filter1 = [CIFilter filterWithName:@"CIHighlightShadowAdjust" keysAndValues:kCIInputImageKey, filter.outputImage, nil];
    CGFloat shadowAmount = 0.2;
    [filter1 setValue:@(shadowAmount) forKey:@"inputShadowAmount"];
    [filter1 setValue:@(1) forKey:@"inputRadius"];
    UIImage *bottomImage = [UIImage imageWithCIImage:[filter outputImage]];
    
    return bottomImage;
}

+(UIImage*)filter2:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha withBlendMode:(CGBlendMode)withBlendMode{
    CGBlendMode filterName    =   withBlendMode;
    // UIImage *image = blurImage;
    CGSize newSize = CGSizeMake(onImage.size.width, onImage.size.height);
    UIGraphicsBeginImageContext( newSize );
    [onImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    [filterImg drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:filterName alpha:0.2];
    UIImage *blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CIImage *img = [CIImage imageWithData:UIImagePNGRepresentation(blendedImage)];
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey,img, nil];
    [filter setValue: @0.25f forKey: kCIInputIntensityKey];
    
//    filter = [CIFilter filterWithName:@"CIHueAdjust"
//                        keysAndValues: kCIInputImageKey,filter.outputImage,
//              @"inputAngle", [NSNumber numberWithFloat:0.2],nil];
    
    CIFilter * filter1 = [CIFilter filterWithName:@"CIHighlightShadowAdjust" keysAndValues:kCIInputImageKey, filter.outputImage, nil];
    CGFloat shadowAmount = 0.2;
    [filter1 setValue:@(shadowAmount) forKey:@"inputShadowAmount"];
    [filter1 setValue:@(2) forKey:@"inputRadius"];
    UIImage *bottomImage = [UIImage imageWithCIImage:[filter outputImage]];
    
    return bottomImage;

}

+(UIImage*)filter3:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha withBlendMode:(CGBlendMode)withBlendMode{
    CGBlendMode filterName    =   withBlendMode;
    // UIImage *image = blurImage;
    CGSize newSize = CGSizeMake(onImage.size.width, onImage.size.height);
    UIGraphicsBeginImageContext( newSize );
    [onImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    [filterImg drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:filterName alpha:0.2];
    UIImage *blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CIImage *img = [CIImage imageWithData:UIImagePNGRepresentation(blendedImage)];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectTransfer" keysAndValues:kCIInputImageKey,img, nil];
    
    //    filter = [CIFilter filterWithName:@"CIHueAdjust"
    //                        keysAndValues: kCIInputImageKey,filter.outputImage,
    //              @"inputAngle", [NSNumber numberWithFloat:0.2],nil];
    
    CIFilter * filter1 = [CIFilter filterWithName:@"CIHighlightShadowAdjust" keysAndValues:kCIInputImageKey, filter.outputImage, nil];
    CGFloat shadowAmount = 0.2;
    [filter1 setValue:@(shadowAmount) forKey:@"inputShadowAmount"];
    [filter1 setValue:@(2) forKey:@"inputRadius"];
    UIImage *bottomImage = [UIImage imageWithCIImage:[filter outputImage]];
    
    return bottomImage;
    
}

+(UIImage*)filter4:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha withBlendMode:(CGBlendMode)withBlendMode{
    CGBlendMode filterName    =   withBlendMode;
    // UIImage *image = blurImage;
    CGSize newSize = CGSizeMake(onImage.size.width, onImage.size.height);
    UIGraphicsBeginImageContext( newSize );
    [onImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    [filterImg drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:filterName alpha:0.2];
    UIImage *blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CIImage *img = [CIImage imageWithData:UIImagePNGRepresentation(blendedImage)];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectProcess" keysAndValues:kCIInputImageKey,img, nil];
    
    //    filter = [CIFilter filterWithName:@"CIHueAdjust"
    //                        keysAndValues: kCIInputImageKey,filter.outputImage,
    //              @"inputAngle", [NSNumber numberWithFloat:0.2],nil];
    
    CIFilter * filter1 = [CIFilter filterWithName:@"CIHighlightShadowAdjust" keysAndValues:kCIInputImageKey, filter.outputImage, nil];
    CGFloat shadowAmount = 0.2;
    [filter1 setValue:@(shadowAmount) forKey:@"inputShadowAmount"];
    [filter1 setValue:@(2) forKey:@"inputRadius"];
    UIImage *bottomImage = [UIImage imageWithCIImage:[filter outputImage]];
    
    return bottomImage;
    
}

+(UIImage*)filter5:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha withBlendMode:(CGBlendMode)withBlendMode{
    CGBlendMode filterName    =   withBlendMode;
    // UIImage *image = blurImage;
    CGSize newSize = CGSizeMake(onImage.size.width, onImage.size.height);
    UIGraphicsBeginImageContext( newSize );
    [onImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    [filterImg drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:filterName alpha:0.2];
    UIImage *blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CIImage *img = [CIImage imageWithData:UIImagePNGRepresentation(blendedImage)];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectInstant" keysAndValues:kCIInputImageKey,img, nil];
    
    //    filter = [CIFilter filterWithName:@"CIHueAdjust"
    //                        keysAndValues: kCIInputImageKey,filter.outputImage,
    //              @"inputAngle", [NSNumber numberWithFloat:0.2],nil];
    
    CIFilter * filter1 = [CIFilter filterWithName:@"CIHighlightShadowAdjust" keysAndValues:kCIInputImageKey, filter.outputImage, nil];
    CGFloat shadowAmount = 0.4;
    [filter1 setValue:@(shadowAmount) forKey:@"inputShadowAmount"];
    [filter1 setValue:@(5) forKey:@"inputRadius"];
    UIImage *bottomImage = [UIImage imageWithCIImage:[filter outputImage]];
    
    return bottomImage;
    
}

+(UIImage*)filter6:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha withBlendMode:(CGBlendMode)withBlendMode{
    CGBlendMode filterName    =   withBlendMode;
    // UIImage *image = blurImage;
    CGSize newSize = CGSizeMake(onImage.size.width, onImage.size.height);
    UIGraphicsBeginImageContext( newSize );
    [onImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    [filterImg drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:filterName alpha:0.2];
    UIImage *blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CIImage *img = [CIImage imageWithData:UIImagePNGRepresentation(blendedImage)];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectFade" keysAndValues:kCIInputImageKey,img, nil];
    
    //    filter = [CIFilter filterWithName:@"CIHueAdjust"
    //                        keysAndValues: kCIInputImageKey,filter.outputImage,
    //              @"inputAngle", [NSNumber numberWithFloat:0.2],nil];
    
    CIFilter * filter1 = [CIFilter filterWithName:@"CIHighlightShadowAdjust" keysAndValues:kCIInputImageKey, filter.outputImage, nil];
    CGFloat shadowAmount = 0.4;
    [filter1 setValue:@(shadowAmount) forKey:@"inputShadowAmount"];
    [filter1 setValue:@(5) forKey:@"inputRadius"];
    UIImage *bottomImage = [UIImage imageWithCIImage:[filter outputImage]];
    
    return bottomImage;
    
}

+(UIImage*)filter1:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter1:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeScreen];
}

+(UIImage*)filter2:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter1:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeDarken];
}

+(UIImage*)filter3:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter1:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeLighten];
}

+(UIImage*)filter4:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter1:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeSoftLight];
}

+(UIImage*)filter5:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter1:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeHardLight];
}

+(UIImage*)filter6:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter1:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeDifference];
}

+(UIImage*)filter7:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter1:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeColor];
}

+(UIImage*)filter42:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter2:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeScreen];
}

+(UIImage*)filter8:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter2:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeDarken];
}

+(UIImage*)filter9:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter2:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeLighten];

}

+(UIImage*)filter10:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter2:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeSoftLight];
}

+(UIImage*)filter11:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter2:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeHardLight];

}

+(UIImage*)filter12:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter2:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeDifference];
}

+(UIImage*)filter13:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter2:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeColor];
}


+(UIImage*)filter14:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter3:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeScreen];
}

+(UIImage*)filter15:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter3:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeDarken];

}

+(UIImage*)filter16:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter3:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeLighten];

}

+(UIImage*)filter17:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter3:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeSoftLight];

}

+(UIImage*)filter18:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter3:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeHardLight];

}

+(UIImage*)filter19:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter3:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeDifference];
}

+(UIImage*)filter20:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter3:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeColor];

}

+(UIImage*)filter21:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter4:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeScreen];

}

+(UIImage*)filter22:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter4:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeDarken];

}

+(UIImage*)filter23:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter4:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeLighten];

}

+(UIImage*)filter24:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter4:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeSoftLight];

}

+(UIImage*)filter25:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter4:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeHardLight];

}

+(UIImage*)filter26:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter4:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeDifference];

}

+(UIImage*)filter27:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter4:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeColor];

}

+(UIImage*)filter28:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter5:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeScreen];

}

+(UIImage*)filter29:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter5:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeDarken];

}

+(UIImage*)filter30:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter5:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeLighten];

}

+(UIImage*)filter31:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter5:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeSoftLight];

}

+(UIImage*)filter32:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter5:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeHardLight];

}

+(UIImage*)filter33:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter5:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeDifference];

}

+(UIImage*)filter34:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter5:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeColor];

}

+(UIImage*)filter35:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter6:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeScreen];

}

+(UIImage*)filter36:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter6:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeDarken];

}

+(UIImage*)filter37:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter6:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeLighten];

}

+(UIImage*)filter38:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter6:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeSoftLight];

}

+(UIImage*)filter39:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter6:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeHardLight];

}

+(UIImage*)filter40:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter6:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeDifference];

}

+(UIImage*)filter41:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
    return [self filter6:filterImg onImage:onImage withAlpha:alpha withBlendMode:kCGBlendModeColor];

}


//+(UIImage*)filter42:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
//    return [self filter6:filterImg onImage:onImage withAlpha:kCGBlendModeScreen];
//}
//
//+(UIImage*)filter43:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
//    return [self filter6:filterImg onImage:onImage withAlpha:kCGBlendModeDarken];
//}
//
//+(UIImage*)filter44:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
//    return [self filter6:filterImg onImage:onImage withAlpha:kCGBlendModeLighten];
//}
//
//+(UIImage*)filter45:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
//    return [self filter6:filterImg onImage:onImage withAlpha:kCGBlendModeSoftLight];
//}
//
//+(UIImage*)filter46:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
//    return [self filter6:filterImg onImage:onImage withAlpha:kCGBlendModeHardLight];
//}
//
//+(UIImage*)filter47:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
//    return [self filter6:filterImg onImage:onImage withAlpha:kCGBlendModeDifference];
//}
//
//+(UIImage*)filter48:(UIImage *)filterImg onImage:(UIImage *)onImage withAlpha:(double)alpha {
//    return [self filter6:filterImg onImage:onImage withAlpha:kCGBlendModeColor];
//}

@end
