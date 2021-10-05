//
//  CLBlurTool.h
//
//  Created by sho yakushiji on 2013/10/19.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLImageToolBase.h"
#import "RandomObjects.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+Utility.h"

@interface PatternTool : CLImageToolBase
{
    NSUInteger blendMode;
    NSUInteger pattern;
    double patternAlpha;
    NSUInteger patternblur;
    UIActivityIndicatorView *indicator;
    
}
@end
