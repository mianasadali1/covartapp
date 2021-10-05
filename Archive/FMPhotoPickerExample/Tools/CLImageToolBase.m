//
//  CLImageToolBase.m
//
//  Created by sho yakushiji on 2013/10/17.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLImageToolBase.h"
#import "CLImageEditorTheme.h"
#import "CLImageEditorTheme+Private.h"

@implementation CLImageToolBase

- (id)initWithImageEditor:(ViewController*)editor withToolInfo:(ToolInfo*)info
{
    self = [super init];
    if(self){
        self.editor   = editor;
        self.toolInfo = info;
    }
    return self;
}

-(UIBarButtonItem *)buttonWithImageName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.bounds = CGRectMake( 0, 0, 40, 40 );
    [btn setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return barBtn;
}

+ (NSString*)defaultIconImagePath
{
    CLImageEditorTheme *theme = [CLImageEditorTheme theme];
    return [NSString stringWithFormat:@"%@/%@/%@/icon.png", CLImageEditorTheme.bundle.bundlePath, NSStringFromClass([self class]), theme.toolIconColor];
}

+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle
{
    return @"DefaultTitle";
}

+ (BOOL)isAvailable
{
    return NO;
}

+ (NSDictionary*)optionalInfo
{
    return nil;
}

#pragma mark-

- (void)setup
{
    
}

- (void)cleanup
{
    
}

- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock
{
    completionBlock(self.editor.imageView.image, nil, nil);
}

- (UIImage*)imageForKey:(NSString*)key defaultImageName:(NSString*)defaultImageName
{
    NSLog(@"%@",self.toolInfo.optionalInfo);
    NSString *iconName = self.toolInfo.optionalInfo[key];
    
    if(iconName.length>0){
        return [UIImage imageNamed:iconName];
    }
    else{
        return [CLImageEditorTheme imageNamed:[self class] image:defaultImageName];
    }
}

@end
