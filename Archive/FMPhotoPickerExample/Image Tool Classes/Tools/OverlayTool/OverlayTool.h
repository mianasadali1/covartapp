//
//  CLBlurTool.h
//
//  Created by sho yakushiji on 2013/10/19.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLImageToolBase.h"
#import "RandomObjects.h"

@interface OverlayTool : CLImageToolBase
{
    UIScrollView *_subMenuScroll;
    UIView *_containerView;
    double  patternAlpha;
    NSUInteger blendMode;
    NSUInteger overlayPattern;
    NSUInteger pattern;
    UIActivityIndicatorView *indicator;
    NSMutableArray* _overlayColorsImgs;
}
@end
