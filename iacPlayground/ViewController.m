//
//  ViewController.m
//  iacPlayground
//
//  Created by Max Bäumle.
//  Copyright (c) 2012 Max Bäumle. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize interactionController;

- (void)dealloc {
    [interactionController release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
#error Insert login information
    // Login
    [[iAC sharedInstance] setEmail:@"..."];
    [[iAC sharedInstance] setPassword:@"..."];
    
    [[iAC sharedInstance] setDelegate:self];
    
    // Request KV
    [[iAC sharedInstance] requestKVList];
    
    // Send KV
    [[iAC sharedInstance] sendValue:@"v1" forKey:@"k1"];
    //[[iAC sharedInstance] sendValues:[NSArray arrayWithObjects:@"v1", @"v1", nil]
    //                         forKeys:[NSArray arrayWithObjects:@"k2", @"k3", nil]];
    //[[iAC sharedInstance] sendValuesAndKeys:@"v1", @"k4", @"v1", @"k5", nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark iACDelegate

- (void)iACRequestDidFail:(NSError *)error {
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);
}

- (void)iACDidReceiveKVList:(NSDictionary *)kvStore {
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, kvStore);
}

- (void)iACDidReceiveDocList:(NSArray *)docStore {
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, docStore);
    
    iACDocListController *docListController = [[[iACDocListController alloc] init] autorelease];
    [docListController setDocStore:docStore];
    
    // Path is where you save the documents to (so you can even use iACDocListController offline).
    [docListController setPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    
    [docListController setDelegate:self];
    
    // iACDocListController must be on top of an UINavigationController
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:docListController] autorelease];
    
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [self presentViewController:navigationController animated:YES completion:NULL];
    } else {
        [self presentModalViewController:navigationController animated:YES];
    }
    
    // Override
    //[docListController setTitle:@"My In-App Content"];
}

- (void)iACDidReceiveFile:(NSData *)data withName:(NSString *)filename {
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, filename);
    
    // Save to disk
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:filename];
    [data writeToFile:path atomically:YES];
    
    // Hide activity indicator
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark -
#pragma mark iACDocListControllerDelegate

- (void)iACShouldDownloadItem:(NSDictionary *)item {
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, item);
    
    // Show activity indicator
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Request file
    [[iAC sharedInstance] requestFile:[item objectForKey:@"filename"]];
}

- (void)iACShouldDisplayItem:(NSString *)filepath {
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, filepath);
    
    // Either display using your very own viewer, or use web view, document interaction controller, quick look...
    
    if (!interactionController) {
        interactionController = [[UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filepath]] retain];
        [interactionController setDelegate:self];
    } else {
        [interactionController setURL:[NSURL fileURLWithPath:filepath]];
    }
    
    [interactionController presentPreviewAnimated:YES];
}

- (BOOL)iACShouldPurchaseItem:(SKProduct *)product {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Return NO if you would like to handle the purchase yourself, otherwise iAC will do (incl. verification).
    return YES;
}

- (BOOL)iACIsSandbox {
    // Return YES for sandbox testing environment, NO for App Store distribution
    return YES;
}

- (void)iACVerificationFailed:(int)errorCode error:(NSError *)error {
    NSLog(@"%s, %d, %@", __PRETTY_FUNCTION__, errorCode, error);
}

#pragma mark -
#pragma mark UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

#pragma mark -
#pragma mark Interface builder actions

- (IBAction)requestDocuments {
    [[iAC sharedInstance] requestDocList];
}

- (IBAction)showDocList {
    iACDocListController *docListController = [[[iACDocListController alloc] init] autorelease];
    
    // Path is where you save the documents to (so you can even use iACDocListController offline).
    [docListController setPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    
    [docListController setDelegate:self];
    
    // iACDocListController must be on top of an UINavigationController
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:docListController] autorelease];
    
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [self presentViewController:navigationController animated:YES completion:NULL];
    } else {
        [self presentModalViewController:navigationController animated:YES];
    }
    
    // Override
    //[docListController setTitle:@"My In-App Content"];
}

@end
