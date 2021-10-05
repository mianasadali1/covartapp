//
//  AdjustmentSubTool.h
//  BasicFilters
//
//  Created by Kanwarpal Singh on 04/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AdjustmentSubTool : NSObject

-(UIImage *)applyFilterOnImage:(UIImage *)origionalImage withValue:(double)value;

@end
