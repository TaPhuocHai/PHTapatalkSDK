//
//  LNAccountManager.h
//  TapatalkSDK
//
//  Created by Ta Phuoc Hai on 1/18/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModelUser;

#define kLNStoreLoginUser                      @"ZJboIzf3OGEyJtR"
#define kLNUserDidLoginNotification            @"GagYG2Y0HD5VYhM"
#define kLNUserDidLogoutNotification           @"WwAimsnkO4MnEGx"

@interface LNAccountManager : NSObject

// Singleton
+(LNAccountManager*)sharedInstance;

// Basic account operation & status
-(BOOL)isLoggedIn;
-(void)logoutAndClearData;
-(void)storeUserAccountAndLogin:(ModelUser*)user;
-(ModelUser*)loggedInUser;

+ (void)autoLoginOnCompletionHander:(void (^)(ModelUser* result, NSError *error))_completionHander;
+ (void)loginAndStoreUserWithUsername:(NSData*)username
                             password:(NSData*)password
                    completionHandler:(void (^)(ModelUser* result, NSError *error))_completionHander;

@end
