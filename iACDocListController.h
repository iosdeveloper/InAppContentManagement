//
//  iACDocListController.h
//
//  Created by Max Bäumle.
//  Copyright (c) 2012 Max Bäumle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@protocol iACDocListControllerDelegate <NSObject>

@required

- (void)iACShouldDownloadItem:(NSDictionary *)item;
- (void)iACShouldDisplayItem:(NSString *)filepath;

@optional

- (BOOL)iACShouldPurchaseItem:(SKProduct *)product;
- (BOOL)iACIsSandbox;
- (void)iACVerificationFailed:(int)errorCode error:(NSError *)error;

@end

@interface iACDocListController : UITableViewController <SKPaymentTransactionObserver>

@property (nonatomic, copy) NSArray *docStore;
@property (nonatomic, copy) NSString *path;

@property (nonatomic, assign) id <iACDocListControllerDelegate> delegate;

@end
