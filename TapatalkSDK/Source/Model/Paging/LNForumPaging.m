//
//  LNPagingForum.m
//  ProjectLana
//
//  Created by Ta Phuoc Hai on 3/15/13.
//  Copyright (c) 2013 Project Lana. All rights reserved.
//

#import "LNForumPaging.h"
#import "TapatalkAPI.h"
#import "ModelForum.h"

#define kPagingForumNumber 50

@implementation LNForumPaging

- (id)initWithForum:(ModelForum*)forum
{    
    return [self initWithForum:forum perPage:kPagingForumNumber];
}

- (id)initWithForum:(ModelForum*)forum perPage:(NSInteger)numberOfPerPage
{
    if (self = [super initWithPerPage:numberOfPerPage]) {
        _forum = forum;
        self.delegate = self;
    }
    return self;
}

#pragma mark - LNBasePagingDelegate

- (void)loadDataFrom:(NSInteger)from
                  to:(NSInteger)to
          completion:(void (^)(NSArray * data, NSInteger totalDataNumber))completeBlock
             failure:(void (^)(NSError * error))failureBlock
{
    [TapatalkAPI getTopicWithForum:self.forum.forum_id
                              mode:nil
                          startNum:from
                           lastNum:to
                 completionHandler:^(ModelForum *result, NSError *error)
    {
        if (error) {
            if (failureBlock) failureBlock(error);
            return;
        }
        
        // Fill properties
        self.forum.can_post              = result.can_post;
        self.forum.total_topic_num       = result.total_topic_num;
        self.forum.unread_sticky_cout    = result.unread_sticky_cout;
        self.forum.unread_announce_count = result.unread_announce_count;
        self.forum.require_prefix        = result.require_prefix;
        self.forum.prefixes              = result.prefixes;
        
        if (completeBlock) completeBlock(result.topics, result.total_topic_num);
    } onPercent:^(float percent) {
    }];
}

@end
