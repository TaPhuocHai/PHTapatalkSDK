//
//  LNPagingTopic.h
//  ProjectLana
//
//  Created by TAPHUOCHAI on 12/27/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import "LNBasePaging.h"
#import "ModelTopic.h"
#import "ModelPost.h"

@interface LNPagingTopic : LNBasePaging

@property (nonatomic, strong) NSMutableArray *pageLoaded;
@property (nonatomic, strong) ModelTopic     *topic;

- (id)initTopic:(ModelTopic*)_topic;
- (id)initTopic:(ModelTopic*)_topic paging:(int)count;

- (BOOL)isPreviousPage;
- (BOOL)isLoad:(int)page;
- (BOOL)isNextPage:(int)page;
- (BOOL)isPreviousPage:(int)page;
- (void)loadPrevPageOnSuccess:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild;
- (void)jumpToPage:(int)page onSuccess:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild;

@end
