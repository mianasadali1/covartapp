//
//  UIImage+Reflection.h
//  BasicFilters
//
//  Created by Kanwarpal Singh on 07/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Reflection)

- (UIImage *)imageWithReflectionWithScale:(CGFloat)scale onImage:(UIImage *)image gap:(CGFloat)gap alpha:(CGFloat)alpha;

@end
