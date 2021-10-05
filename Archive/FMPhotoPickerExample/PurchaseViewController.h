//
//  PurchaseViewController.h
//  BasicFilters
//
//  Created by Kanwar on 8/15/18.
//  Copyright © 2018 Kanwarpal Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKStoreKit.h"
#import "MBProgressHUD.h"
#import <StoreKit/StoreKit.h>

@protocol SubscriptionDelegate;
@interface PurchaseViewController : UIViewController
{
    IBOutlet UIView *proBgView;
    IBOutlet UIView *sortBgView;
    
    IBOutlet UILabel *proSubscriptionLbl;
    
    IBOutlet UIButton *closeBtn;
    MBProgressHUD *hud;
}
@property (nonatomic, weak) id<SubscriptionDelegate> delegate;

-(IBAction)proBtnTapped:(id)sender;

@end

@protocol SubscriptionDelegate <NSObject>
@optional

- (void)subscriptionSuccesFull;

@end
