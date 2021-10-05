//
//  ViewController.h
//  BasicFilters
//
//  Created by Kanwarpal Singh on 25/07/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolInfo.h"
#import "UIView+ToolInfo.h"
@import FlexColorPicker;

@protocol CLImageEditorDelegate;

@interface ViewController : UIViewController<UIScrollViewDelegate,UINavigationControllerDelegate,UINavigationBarDelegate,UIImagePickerControllerDelegate>{
    NSUInteger PHOTO_EDITED;
    UIImagePickerController *ipc;
}

@property(nonatomic,strong) UIColor *barColor;
@property(nonatomic,strong)  UINavigationBar *navigationBar;

@property(nonatomic,strong)  UIImage *originalImage;

@property(nonatomic,weak) IBOutlet UIScrollView *menuScrollView;
@property(nonatomic,weak) IBOutlet UIView *editorView;

@property (nonatomic, strong) UIImageView  *imageView;
@property (nonatomic, strong) UIImageView *contentImageView;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidth;


@property (weak, nonatomic) IBOutlet UIView *viewAddAudio;

@property (nonatomic, strong, readwrite) ToolInfo *toolInfo;
//@property (nonatomic) IBOutlet dfoil *glViewSwift;

@property (nonatomic, weak) id<CLImageEditorDelegate> delegate;

// Explicit content
@property (weak, nonatomic) IBOutlet UIImageView *icExplicitCheck;
//@property (weak, nonatomic) IBOutlet UIImageView *explicitContent;

// WaterMark
@property (strong, nonatomic) UIImageView *imageViewWaterMark;
@property (weak, nonatomic) IBOutlet UIView *viewWaterMarkSelection;
- (void)waterMark;
- (void)waterMarkGalleryOpen;
- (void)waterMarkRemoval;

// Alignment
@property (weak, nonatomic) IBOutlet UIView *viewAlignment;
- (void)alignmentStateChange;



- (IBAction)pushedCloseBtn:(id)sender;
- (IBAction)pushedFinishBtn:(id)sender;
- (id)initWithImage:(UIImage*)image;
- (void)fixZoomScaleWithAnimated:(BOOL)animated;
- (void)resetZoomScaleWithAnimated:(BOOL)animated;

@end

@protocol CLImageEditorDelegate <NSObject>
@optional
- (void)imageEditor:(ViewController*)editor didFinishEditingWithImage:(UIImage*)image;
- (void)imageEditorDidCancel:(ViewController*)editor;

@end

