//
//  DistortionSubTool.h
//  BasicFilters
//
//  Created by Kanwarpal Singh on 17/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "CLImageToolBase.h"

@interface DistortionSubTool : NSObject

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value withCenter:(CGPoint)center withRadius:(double)radius;

@end
