//
//  TapatalkSDK.h
//  TapatalkSDK
//
//  Created by Ta Phuoc Hai on 1/18/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//
#import "ModelUser.h"
#import "ModelTopic.h"
#import "ModelPrefix.h"
#import "ModelPost.h"
#import "ModelForum.h"

#import "LNAccountManager.h"

#import "LNBasePaging.h"
#import "LNForumPaging.h"
#import "LNSearchPaging.h"
#import "LNSubscribePaging.h"
#import "LNTopicPaging.h"
#import "LNUnreadTopic.h"

#import "TapatalkAPI.h"

#define kNSTapatalkDidLoadRootForum @"kNSTapatalkDidLoadRootForum"

@interface LNTapatalkSDK : NSObject

+ (ModelForum*)rootForum;

+ (void)startWithFormUrl:(NSString*)forumUrl;
+ (void)didBecomeActive;

@end