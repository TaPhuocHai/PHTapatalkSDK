//
//  LNAccountManager.m
//  TapatalkSDK
//
//  Created by Ta Phuoc Hai on 1/18/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "LNAccountManager.h"
#import "ModelUser.h"
#import "TapatalkAPI.h"

#define kLNAcountLoginUsername @"LN_LOGIN_USERNAME"
#define kLNAcountLoginPassword @"LN_LOGIN_PASSWORD"

@implementation LNAccountManager

static LNAccountManager * _shared;

#pragma mark - Singleton

+ (LNAccountManager*)sharedInstance
{
    if (_shared == nil) _shared = [[LNAccountManager alloc] init];
    return _shared;
}

- (BOOL)isLoggedIn
{
    if (self.loggedInUser) {
        return YES;
    }
    return NO;
}

#pragma mark - Basic operations

static ModelUser *_user;
- (void)storeUserAccountAndLogin:(ModelUser*)user
{
    _user = user;
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:user];
    [prefs setObject:data forKey:kLNStoreLoginUser];
    [prefs synchronize];
}

- (ModelUser*)loggedInUser
{
    if (!_user) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSData * data = [prefs objectForKey:kLNStoreLoginUser];
        if (data) {
            _user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return _user;
}

#pragma mark - Login

+ (void)autoLoginOnCompletionHander:(void (^)(ModelUser* result, NSError *error))_completionHander
{
    if ([LNAccountManager sharedInstance].isLoggedIn) {
        NSUserDefaults * pref = [NSUserDefaults standardUserDefaults];
        NSData * username = [pref objectForKey:kLNAcountLoginUsername];
        NSData * password = [pref objectForKey:kLNAcountLoginPassword];
        
        [self loginAndStoreUserWithUsername:username
                                   password:password completionHandler:^(ModelUser *result, NSError *error) {
                                       if (_completionHander) {
                                           _completionHander ([LNAccountManager sharedInstance].loggedInUser, nil);
                                       }
                                   }];
    } else {
        if(_completionHander) {
            _completionHander (nil, [NSError errorWithDomain:@"" code:1 userInfo:@{@"message" : @"unknow"}]);
        }
    }
}

+ (void)loginAndStoreUserWithUsername:(NSData*)username
                             password:(NSData*)password
                    completionHandler:(void (^)(ModelUser* result, NSError *error))_completionHander
{
    [TapatalkAPI loginWithUsername:username
                          password:password
                 completionHandler:^(ModelUser *result, NSError *error) {
                     if (result) {
                         NSUserDefaults * pref = [NSUserDefaults standardUserDefaults];
                         [pref setObject:username forKey:kLNAcountLoginUsername];
                         [pref setObject:password forKey:kLNAcountLoginPassword];
                         [pref synchronize];
                         
                         [[LNAccountManager sharedInstance] storeUserAccountAndLogin:result];
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:kLNUserDidLoginNotification
                                                                             object:result];
                     }
                     if (_completionHander) _completionHander(result, error);
                 }];
}

#pragma mark - Logout

-(void)logoutAndClearData
{
    // Clear values to force show login screen
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:kLNStoreLoginUser];
    [prefs removeObjectForKey:kLNAcountLoginUsername];
    [prefs removeObjectForKey:kLNAcountLoginPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _user = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLNUserDidLogoutNotification object:nil];
}

#pragma mark - Cleanup

- (void)dealloc
{
}

@end
