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

@interface LNTopicPaging : LNBasePaging <LNBasePagingDelegate>

@property (nonatomic, readonly) ModelTopic           * topic;
@property (nonatomic, readonly) NSMutableDictionary  * dataOfPage;

- (id)initTopic:(ModelTopic*)_topic;
- (id)initTopic:(ModelTopic*)_topic perPage:(NSInteger)perPage;

- (BOOL)pageIsLoaded:(int)page;

- (BOOL)hadPrevPage;
- (BOOL)hadNextPage;

- (int)maxPageIndexLoaded;
- (int)minPageIndexLoaded;

- (BOOL)pageIsNextPageInCurrentLoaded:(int)page;
- (BOOL)pageIsPrevPageInCurrentLoaded:(int)page;

- (void)loadPrevPageOnComplete:(void (^)(NSArray *arrData))completeBlock
                       failure:(void (^)(NSError *error))failureBlock;
- (void)jumpToPage:(NSInteger)page
          complete:(void (^)(NSArray *arrData))completeBlock
           failure:(void (^)(NSError *error))failureBlock;

@end
