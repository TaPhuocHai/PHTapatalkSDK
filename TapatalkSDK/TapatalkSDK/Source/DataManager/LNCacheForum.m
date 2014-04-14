//
//  LNCacheForum.m
//  TapatalkSDK
//
//  Created by Ta Phuoc Hai on 4/11/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "LNCacheForum.h"

@implementation LNCacheForum

- (void)startPagingOnSuccess:(void (^)(NSArray * topics))_onSuccess
                     onFaild:(void (^)(NSError * error))_onFaild
                     onCache:(void (^)(NSArray * cacheTopics))_onCache
{
#warning TODO do something with cache
    
    [super startPagingOnSuccess:^(NSArray *arrData) {
        // Xử lý cache
        
        // complete
        if (_onSuccess) _onSuccess(arrData);
    } onFaild:^(NSError *error) {
        if (_onFaild) _onFaild(error);
    }];
}

@end
