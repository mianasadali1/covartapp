//
//  ToolBarItem.h
//  BasicFilters
//
//  Created by Kanwarpal Singh on 03/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolInfo.h"
#import "UIView+ToolInfo.h"

@interface ToolBarItem : UIView

@property (nonatomic,retain) ToolInfo *toolInfo;
@property (nonatomic,retain) UILabel *titleLabel;

@property (nonatomic,retain) UIImageView *iconView;
@property (nonatomic,retain) NSString *toolId;
@property (nonatomic,retain) NSArray *filterObjects;
@property (nonatomic,retain) NSString *toolName;
@property (nonatomic,retain) NSString *toolInAppId;
@property (nonatomic,retain) NSString *methodName;

+ (ToolBarItem*)menuItemWithFrame:(CGRect)frame target:(id)target action:(SEL)action toolInfo:(ToolInfo*)toolInfo isIcon:(BOOL)isIcon;
- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action toolInfo:(ToolInfo*)toolInfo isIcon:(BOOL)isIcon;

@end
