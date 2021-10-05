//
//  SelectorsList.h
//  UnlimitedEffects
//
//  Created by Kanwarpal Singh on 21/02/16.
//  Copyright © 2016 Kanwarpal Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SelectorsList : NSObject

-(UIImage *)getImageByApplyingEffectId:(CGSize)imageSize effectId:(NSUInteger)effectId;

+ (id)sharedInstance;

@end
