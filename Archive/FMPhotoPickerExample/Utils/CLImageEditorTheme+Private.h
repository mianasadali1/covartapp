//
//  CLImageEditorTheme+Private.h
//
//  Created by sho yakushiji on 2013/12/07.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CLImageEditorTheme.h"

#import "ToolBarItem.h"
#import "ToolInfo.h"
#import "SubToolBarItem.h"
#import "StickerToolBarItem.h"

@interface CLImageEditorTheme (Private)

+ (NSString*)bundleName;
+ (NSBundle*)bundle;
+ (UIImage*)imageNamed:(Class)path image:(NSString*)image;
+ (NSString*)localizedString:(NSString*)key withDefault:defaultValue;

+ (UIColor*)backgroundColor;
+ (UIColor*)toolbarColor;
+ (UIColor*)toolbarTextColor;
+ (UIColor*)toolbarSelectedButtonColor;

+ (UIFont*)toolbarTextFont;

+ (UIActivityIndicatorView*)indicatorView;
+ (ToolBarItem*)menuItemWithFrame:(CGRect)frame target:(id)target action:(SEL)action toolInfo:(ToolInfo*)toolInfo isIcon:(BOOL)isIcon;
+ (SubToolBarItem*)subMenuItemWithFrame:(CGRect)frame target:(id)target action:(SEL)action toolInfo:(ToolInfo*)toolInfo isIcon:(BOOL)isIcon isPro:(BOOL)isPro;

+ (StickerToolBarItem*)stickerMenuItemWithFrame:(CGRect)frame target:(id)target action:(SEL)action toolInfo:(ToolInfo*)toolInfo isIcon:(BOOL)isIcon isPro:(BOOL)isPro;


@end
