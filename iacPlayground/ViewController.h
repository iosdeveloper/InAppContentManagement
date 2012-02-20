//
//  ViewController.h
//  iacPlayground
//
//  Created by Max Bäumle.
//  Copyright (c) 2012 Max Bäumle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iAC.h"
#import "iACDocListController.h"

@interface ViewController : UIViewController <iACDelegate, iACDocListControllerDelegate, UIDocumentInteractionControllerDelegate>

@property (nonatomic, copy) UIDocumentInteractionController *interactionController;

- (IBAction)requestDocuments;
- (IBAction)showDocList;

@end
