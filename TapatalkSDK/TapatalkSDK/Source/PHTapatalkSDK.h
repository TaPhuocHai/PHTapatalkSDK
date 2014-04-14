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
#import "LNPagingForum.h"
#import "LNPagingSearch.h"
#import "LNPagingSubscribe.h"
#import "LNPagingTopic.h"
#import "LNPagingUnreadTopic.h"

#import "TapatalkAPI.h"

@interface PHTapatalkSDK : NSObject

+ (ModelForum*)rootForum;
+ (void)didBecomeActive;

@end