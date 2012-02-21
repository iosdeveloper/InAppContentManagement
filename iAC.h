//
//  iAC.h
//
//  Created by Max Bäumle.
//  Copyright (c) 2012 Max Bäumle. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol iACDelegate <NSObject>

@optional

- (void)iACRequestDidFail:(NSError *)error;
- (void)iACDidReceiveKVList:(NSDictionary *)kvStore;
- (void)iACDidReceiveDocList:(NSArray *)docStore;
- (void)iACDidReceiveFile:(NSData *)data withName:(NSString *)filename;

@end

@interface iAC : NSObject

+ (iAC *)sharedInstance;

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, assign) id <iACDelegate> delegate;

- (void)requestKVList;
- (void)requestDocList;
- (void)requestFile:(NSString *)filename;

- (void)sendValue:(NSString *)value forKey:(NSString *)key;
- (void)sendValues:(NSArray *)values forKey:(NSArray *)keys;
- (void)sendValuesAndKeys:(NSString *)firstValue, ...;

@end
