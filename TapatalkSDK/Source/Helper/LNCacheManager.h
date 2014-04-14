//
//  LNCacheManager.h
//  TapatalkSDK
//
//  Created by Ta Phuoc Hai on 4/11/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNCacheManager : NSObject

+ (LNCacheManager*)shareInstance;

- (void)getForumById:(int)forumId
   completionHandler:(void (^)(NSArray * childForum))_completionHandler
      failureHandler:(void (^)(NSError * error))_failureHandler;

@end
