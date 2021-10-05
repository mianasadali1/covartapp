//
//  NSNumber+RandomNumberGenrator.m
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 05/09/15.
//  Copyright (c) 2015 Kanwarpal Singh. All rights reserved.
//


#import "NSNumber+RandomNumberGenrator.h"

#define ARC4RANDOM_MAX 0x100000000


@implementation NSNumber (RandomNumberGenrator)

+(int)randomIntInLimit:(int)startLimit endLimit:(int)eLimit{
 
    int rndValue = startLimit + arc4random() % (eLimit - startLimit);
    return rndValue;
}

+(float)randomFloatInLimit:(float)startLimit endLimit:(float)eLimit{
    //float randomNum = ((float)rand() / RAND_MAX) * eLimit;
    double randomNum = ((double)arc4random() / ARC4RANDOM_MAX)
    * (eLimit - startLimit)
    + startLimit;

    if(randomNum < 0)
        return 0;
    return randomNum;
}

+(float)randomFloatInLimit1:(float)startLimit endLimit:(float)eLimit{
    //float randomNum = ((float)rand() / RAND_MAX) * eLimit;
    double randomNum = ((double)arc4random() / ARC4RANDOM_MAX)
    * (eLimit - startLimit)
    + startLimit;
    
    return randomNum;
}

/*
 CIAccordionFoldTransition,
 CIAdditionCompositing,
 CIAffineClamp,
 CIAffineTile,
 CIAffineTransform,
 CIAreaHistogram,
 CIAztecCodeGenerator,
 CIBarsSwipeTransition,
 CIBlendWithAlphaMask,
 CIBlendWithMask,
 CIBloom,
 CIBumpDistortion,
 CIBumpDistortionLinear,
 CICheckerboardGenerator,
 CICircleSplashDistortion,
 CICircularScreen,
 CICode128BarcodeGenerator,
 CIColorBlendMode,
 CIColorBurnBlendMode,
 CIColorClamp,
 CIColorControls,
 CIColorCrossPolynomial,
 CIColorCube,
 CIColorCubeWithColorSpace,
 CIColorDodgeBlendMode,
 CIColorInvert,
 CIColorMap,
 CIColorMatrix,
 CIColorMonochrome,
 CIColorPolynomial,
 CIColorPosterize,
 CIConstantColorGenerator,
 CIConvolution3X3,
 CIConvolution5X5,
 CIConvolution9Horizontal,
 CIConvolution9Vertical,
 CICopyMachineTransition,
 CICrop,
 CIDarkenBlendMode,
 CIDifferenceBlendMode,
 CIDisintegrateWithMaskTransition,
 CIDissolveTransition,
 CIDivideBlendMode,
 CIDotScreen,
 CIEightfoldReflectedTile,
 CIExclusionBlendMode,
 CIExposureAdjust,
 CIFalseColor,
 CIFlashTransition,
 CIFourfoldReflectedTile,
 CIFourfoldRotatedTile,
 CIFourfoldTranslatedTile,
 CIGammaAdjust,
 CIGaussianBlur,
 CIGaussianGradient,
 CIGlassDistortion,
 CIGlideReflectedTile,
 CIGloom,
 CIHardLightBlendMode,
 CIHatchedScreen,
 CIHighlightShadowAdjust,
 CIHistogramDisplayFilter,
 CIHoleDistortion,
 CIHueAdjust,
 CIHueBlendMode,
 CILanczosScaleTransform,
 CILightenBlendMode,
 CILightTunnel,
 CILinearBurnBlendMode,
 CILinearDodgeBlendMode,
 CILinearGradient,
 CILinearToSRGBToneCurve,
 CILineScreen,
 CILuminosityBlendMode,
 CIMaskToAlpha,
 CIMaximumComponent,
 CIMaximumCompositing,
 CIMinimumComponent,
 CIMinimumCompositing,
 CIModTransition,
 CIMotionBlur,
 CIMultiplyBlendMode,
 CIMultiplyCompositing,
 CIOverlayBlendMode,
 CIPerspectiveCorrection,
 CIPhotoEffectChrome,
 CIPhotoEffectFade,
 CIPhotoEffectInstant,
 CIPhotoEffectMono,
 CIPhotoEffectNoir,
 CIPhotoEffectProcess,
 CIPhotoEffectTonal,
 CIPhotoEffectTransfer,
 CIPinchDistortion,
 CIPinLightBlendMode,
 CIPixellate,
 CIQRCodeGenerator,
 CIRadialGradient,
 CIRandomGenerator,
 CISaturationBlendMode,
 CIScreenBlendMode,
 CISepiaTone,
 CISharpenLuminance,
 CISixfoldReflectedTile,
 CISixfoldRotatedTile,
 CISmoothLinearGradient,
 CISoftLightBlendMode,
 CISourceAtopCompositing,
 CISourceInCompositing,
 CISourceOutCompositing,
 CISourceOverCompositing,
 CISRGBToneCurveToLinear,
 CIStarShineGenerator,
 CIStraightenFilter,
 CIStripesGenerator,
 CISubtractBlendMode,
 CISwipeTransition,
 CITemperatureAndTint,
 CIToneCurve,
 CITriangleKaleidoscope,
 CITwelvefoldReflectedTile,
 CITwirlDistortion,
 CIUnsharpMask,
 CIVibrance,
 CIVignette,
 CIVignetteEffect,
 CIVortexDistortion,
 CIWhitePointAdjust,
 CIZoomBlur
*/
@end
