//
//  ToolBarItem.m
//  BasicFilters
//
//  Created by Kanwarpal Singh on 03/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import "ToolBarItem.h"
#import "UIView+Frame.h"
#import "CLImageEditorTheme.h"
#import "CLImageEditorTheme+Private.h"

@interface ToolBarItem ()



@end


@implementation ToolBarItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame isIcon:(BOOL)isIcon
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat W = frame.size.width;
        
        if(isIcon){
            _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, W-40, W-40)];
        }
        else{
            _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, W-20, W-20)];
        }
        _iconView.clipsToBounds = YES;
        _iconView.tintColor = [UIColor whiteColor];
        //_iconView.layer.cornerRadius = 5;
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_iconView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconView.bottom + 5, W, 15)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [CLImageEditorTheme toolbarTextColor];
        _titleLabel.font = [CLImageEditorTheme toolbarTextFont];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action toolInfo:(ToolInfo*)toolInfo isIcon:(BOOL)isIcon
{
    self = [self initWithFrame:frame isIcon:isIcon];
    if(self){
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [self addGestureRecognizer:gesture];
        
        self.toolInfo           =   toolInfo;
        self.titleLabel.text    =   toolInfo.title;
        self.iconView.image     =   toolInfo.iconImage;
        self.toolId             =   toolInfo.toolId;
    }
    return self;
}

+ (ToolBarItem*)menuItemWithFrame:(CGRect)frame target:(id)target action:(SEL)action toolInfo:(ToolInfo*)toolInfo isIcon:(BOOL)isIcon;
{
    return [[ToolBarItem alloc] initWithFrame:frame target:target action:action toolInfo:toolInfo isIcon:isIcon];
}

@end
