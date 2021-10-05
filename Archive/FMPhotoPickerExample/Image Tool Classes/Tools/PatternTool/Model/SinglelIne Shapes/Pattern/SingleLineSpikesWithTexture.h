//
//  SingleLineSpikesWithTexture.h
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 10/01/16.
//  Copyright © 2016 Kanwarpal Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SingleLineSpikesWithTexture : NSObject

+(UIImage *)generateImage:(CGSize)imageSize effectId:(int)effectId;
+(UIImage *)generateImageAsWindow:(CGSize)imageSize effectId:(int)effectId;

@end
