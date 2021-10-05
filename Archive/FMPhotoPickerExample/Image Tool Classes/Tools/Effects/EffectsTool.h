//
//  EffectsTool.h
//  BasicFilters
//
//  Created by Kanwar on 2/1/18.
//  Copyright © 2018 Kanwarpal Singh. All rights reserved.
//

#import "CLImageToolBase.h"
#import "RandomObjects.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+Utility.h"

@interface EffectsTool : CLImageToolBase
{
    NSUInteger blendMode;
    NSUInteger pattern;
    double patternAlpha;
    NSUInteger patternblur;
    UIActivityIndicatorView *indicator;
    NSArray* _overlayColorsImgs;
    UIImage *_originalImage;
    UIImage *_thumbnailImage;
    UIView *_containerView;
    UIScrollView *_subMenuScroll;
    NSUInteger overlayPattern;

}
@end
