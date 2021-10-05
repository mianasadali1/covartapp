//
//  TollInfo.h
//  BasicFilters
//
//  Created by Kanwarpal Singh on 03/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ToolInfo : NSObject

@property (nonatomic, strong) NSString *toolName;
@property (nonatomic, strong) NSString *toolId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage  *iconImage;
@property (nonatomic, strong) NSString *filterName;

@property (nonatomic, strong) NSMutableDictionary *optionalInfo;

@property (nonatomic, assign) double  maxLimit;
@property (nonatomic, assign) double  minLimit;

@end
