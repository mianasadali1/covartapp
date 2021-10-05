//
//  ViewController.h
//  GLViewPagerViewController
//
//  Created by Yanci on 17/4/18.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLViewPagerViewController.h"
//#import "FMPhotoPickerExample-Swift.h"
#import "MKStoreKit.h"
#import "MBProgressHUD.h"
#import "PurchaseViewController.h"

//@import GoogleMobileAds;
@protocol SelectNewImageDelegate
    - (void) selecteNewImageGallery: (UIImage *) image;
@end //end protocol


@interface StartPageViewController : GLViewPagerViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
     MBProgressHUD *hud;
    
}

@property (assign, nonatomic) BOOL isSelectingImage;

@property (nonatomic, weak) id <SelectNewImageDelegate> sdelegate;

@property (weak, nonatomic) IBOutlet UIView *viewImage;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewImageHeightConstraint;
-(IBAction)openSettings:(id)sender;

@end

