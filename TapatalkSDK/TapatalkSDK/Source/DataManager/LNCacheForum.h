//
//  LNCacheForum.h
//  TapatalkSDK
//
//  Created by Ta Phuoc Hai on 4/11/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "LNPagingForum.h"

@interface LNCacheForum : LNPagingForum

- (void)startPagingOnSuccess:(void (^)(NSArray * topics))_onSuccess
                     onFaild:(void (^)(NSError * error))_onFaild
                     onCache:(void (^)(NSArray * cacheTopics))_onCache;

@end
