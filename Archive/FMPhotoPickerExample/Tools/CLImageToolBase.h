//
//  CLImageToolBase.h
//
//  Created by sho yakushiji on 2013/10/17.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CLImageToolProtocol.h"
#import "ToolInfo.h"
#import "CLImageEditorTheme.h"
#import "CLImageEditorTheme+Private.h"
#import "FMPhotoPickerExample-Swift.h"
#import "ViewController.h"

static const CGFloat kCLImageToolAnimationDuration = 0.2;
static const CGFloat kCLImageToolFadeoutDuration   = 0.2;
static const CGFloat kNavBarHeight = 44.0f;
static const CGFloat kMenuBarHeight = 80.0f;

static const CGFloat kOkBtnHeightWidth = 40.0f;
static const CGFloat kCancelBtnHeightWidth = 40.0f;

@interface CLImageToolBase : NSObject<CLImageToolProtocol>
{
    
}

@property (nonatomic, weak) ViewController *editor;
@property (nonatomic, weak) ToolInfo *toolInfo;

- (id)initWithImageEditor:(ViewController*)editor withToolInfo:(ToolInfo*)info;
- (UIBarButtonItem *)buttonWithImageName:(NSString *)imageName;

- (void)setup;
- (void)cleanup;
- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock;

- (UIImage*)imageForKey:(NSString*)key defaultImageName:(NSString*)defaultImageName;

@end
