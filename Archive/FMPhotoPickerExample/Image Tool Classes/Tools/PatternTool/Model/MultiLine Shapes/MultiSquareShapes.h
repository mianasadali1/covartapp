//
//  MultiSquareShapes.h
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 15/12/15.
//  Copyright © 2015 Kanwarpal Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RandomObjects.h"
#import "UIColor+HexColors.h"
#import "NSNumber+RandomNumberGenrator.h"
#import "GradientView.h"
#import <UIKit/UIKit.h>

@interface MultiSquareShapes : NSObject

+(UIImage *)generateImage:(CGSize)imageSize effectId:(NSUInteger)effectId;

@end
