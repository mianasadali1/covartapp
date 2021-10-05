//
//  PurchaseViewController.m
//  BasicFilters
//
//  Created by Kanwar on 8/15/18.
//  Copyright © 2018 Kanwarpal Singh. All rights reserved.
//

#import "PurchaseViewController.h"
#import "FMPhotoPickerExample-Swift.h"
#import "InAppPurchases.h"

@implementation SKProduct (DEStoreKitManager)

-(NSString *) localizedPrice {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:self.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:self.price];
    return formattedString;
}

@end

@interface PurchaseViewController ()

@end

@implementation PurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    proBgView.layer.cornerRadius = 5.0f;
    proBgView.layer.masksToBounds = true;
    
    sortBgView.layer.cornerRadius = 5.0f;
    sortBgView.layer.masksToBounds = true;
    
    closeBtn.tintColor = [UIColor whiteColor];
    
    proSubscriptionLbl.text = @"Buy Pro";
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSLog(@"Purchased/Subscribed to product with id: %@", [note object]);
                                                      NSLog(@"%@", [[MKStoreKit sharedKit] valueForKey:@"purchaseRecord"]);
                                                      [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"IsPro"];
                                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          
                                                          [self dismissViewControllerAnimated:true completion:^{
                                                              [self.delegate subscriptionSuccesFull];

                                                              [hud removeFromSuperview];
                                                          }];
                                                      });
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchaseFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      // purchase failed
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [hud removeFromSuperview];

                                                          UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                         message:@"Purchase failed.. Please try again later"
                                                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                                                          
                                                          UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                handler:^(UIAlertAction * action) {
                                                                                                                    
                                                                                                                }];
                                                          
                                                          [alert addAction:defaultAction];
                                                          [self presentViewController:alert animated:YES completion:nil];
                                                          
                                                      });
                                                  }];
    
    [self loadAllProducts];
}

-(void)loadAllProducts{
    NSArray *productIdentifiers = [NSArray arrayWithObjects:Pro_In_App_Id, nil];
    [[MKStoreKit sharedKit] startProductRequestWithProductIdentifiers:productIdentifiers];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductsAvailableNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSLog(@"Products available: %@", [[MKStoreKit sharedKit] availableProducts]);
                                                      MKStoreKit *subscription = [MKStoreKit sharedKit];
                                                      if([[MKStoreKit sharedKit] availableProducts].count > 0){
                                                          
                                                          for(SKProduct *product in  [[MKStoreKit sharedKit] availableProducts]){
                                                              subscription.proSubscriptionPrice = [NSString stringWithFormat:@"Buy Pro in  %@",product.localizedPrice];
                                                          }
                                                          
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              proSubscriptionLbl.text = subscription.proSubscriptionPrice;
                                                          });
                                                      }
                                                  }];
    
}

-(IBAction)openCategorySorting:(id)sender{
    NSString * storyboardName               =   @"Main";
    NSString * viewControllerID             =   @"QuoteCategoryTableViewController";
    UIStoryboard * storyboard               =   [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    
    QuoteCategoryTableViewController * controller = (QuoteCategoryTableViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    [self presentViewController:controller animated:true completion:nil];
}

-(IBAction)proBtnTapped:(id)sender{
    [self purchaseProduct:Pro_In_App_Id];
}

-(IBAction)restoreSubscription:(id)sender{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Restoring.. Please wait";
    [[MKStoreKit sharedKit] restorePurchases];
}

-(void)purchaseProduct:(NSString *)inAppId{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Purchasing.. Please wait";
    
    [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:inAppId];
}

-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
