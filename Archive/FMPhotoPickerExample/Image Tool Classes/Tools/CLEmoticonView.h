//
//  CLEmoticonView.h
//  BasicFilters
//
//  Created by Kanwar on 6/21/18.
//  Copyright © 2018 Kanwarpal Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^stickerDeleteBlock)();

@interface CLEmoticonView : UIView<UIGestureRecognizerDelegate>
+ (void)setActiveEmoticonView:(CLEmoticonView*)view;
- (UIImageView*)imageView;
- (id)initWithImage:(UIImage *)image isSticker:(BOOL)isSticker deleteBlock:(stickerDeleteBlock)deleteBlock;
- (void)setScale:(CGFloat)scale;
- (void)setMinScale:(CGFloat)scale;

@property (nonatomic) BOOL isSticker;
@property (nonatomic) stickerDeleteBlock deleteBlock;

@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) CGFloat scale;

@end
