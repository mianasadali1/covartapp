//
//  SingleLineShapes.h
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 05/12/15.
//  Copyright © 2015 Kanwarpal Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SmiliesShapes.h"

@interface SingleLineShapes : NSObject

+(UIImage *)generateImage:(CGSize)imageSize effectId:(NSUInteger)effectId;
+(UIImage *)generateImageAsWindow:(CGSize)imageSize effectId:(NSUInteger)effectId;
+(UIImage *)generateNoShapeImage:(CGSize)imageSize effectId:(NSUInteger)effectId;

@end
