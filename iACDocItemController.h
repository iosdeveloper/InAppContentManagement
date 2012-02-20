//
//  iACDocItemController.h
//
//  Created by Max Bäumle.
//  Copyright (c) 2012 Max Bäumle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface iACDocItemController : UIViewController <SKProductsRequestDelegate>

@property (nonatomic, copy) NSDictionary *item;

@end
