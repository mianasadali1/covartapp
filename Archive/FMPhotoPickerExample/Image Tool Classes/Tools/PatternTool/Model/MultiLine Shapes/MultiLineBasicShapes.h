//
//  MultiLineBasicShapes.h
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 05/12/15.
//  Copyright © 2015 Kanwarpal Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RandomObjects.h"
#import "UIColor+HexColors.h"
#import "NSNumber+RandomNumberGenrator.h"
#import "GradientView.h"
#import <UIKit/UIKit.h>

@interface MultiLineBasicShapes : NSObject

+(UIImage *)generateImageAsWindow:(CGSize)imageSize effectId:(NSUInteger)effectId;
+(UIImage *)generateImage:(CGSize)imageSize effectId:(NSUInteger)effectId;

@end
