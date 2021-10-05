//
//  MaskedImages.h
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 08/01/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MaskedImages : NSObject

+(UIImage *)generateImage:(CGSize)imgSize effectId:(NSUInteger)effectId;
+(UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size;

@end
