//
//  LNPagingForum.m
//  ProjectLana
//
//  Created by Ta Phuoc Hai on 3/15/13.
//  Copyright (c) 2013 Project Lana. All rights reserved.
//

#import "LNPagingForum.h"
#import "TapatalkAPI.h"
#import "ModelForum.h"

#define kPagingForumNumber 50

@implementation LNPagingForum

- (id)initWithForum:(ModelForum*)forum_
{
    if(self = [super initWithPaging:kPagingForumNumber]) {
        self.forum = forum_;
    }
    return self;
}

- (BOOL)isNextPage
{
    if (self.lastNum < self.forum.total_topic_num) {
        return YES;
    }
    return NO;
}

- (void)startPagingOnSuccess:(void (^)(NSArray *arrData))_onSuccess
                     onFaild:(void (^)(NSError *error))_onFaild
{
    int startLoad = 0;
    int lastLoad = self.countPaging - 1;
    _currentPage = 1;
    
    // lấy dữ liệu sticky
    [TapatalkAPI getTopicWithForum:self.forum.forum_id mode:@"TOP"
                          startNum:0
                           lastNum:200
                 completionHandler:^(ModelForum *result, NSError *error)
    {
        self.forum.topics = result.topics;
        for (ModelTopic * topic in self.forum.topics) {
            topic.topic_title = [@"Chú ý : " stringByAppendingString:topic.topic_title];
            topic.is_sticky = YES;
        }
        NSLog(@"load from %d to %d",startLoad, lastLoad);
        // lấy dữ liệu bình thường
        [TapatalkAPI getTopicWithForum:self.forum.forum_id mode:@"ANY" startNum:startLoad lastNum:lastLoad completionHandler:^(ModelForum *result, NSError *error) {
            if (error) {
                if (_onFaild) _onFaild(error);
            } else{
                _startNum = 0;
                _lastNum  = lastLoad;
                
                self.forum.can_post              = result.can_post;
                self.forum.total_topic_num       = result.total_topic_num;
                self.forum.unread_sticky_cout    = result.unread_sticky_cout;
                self.forum.unread_announce_count = result.unread_announce_count;
                self.forum.require_prefix        = result.require_prefix;
                self.forum.prefixes              = result.prefixes;
                
                // copy topic
                for (ModelTopic* topic in result.topics) {
                    [self.forum.topics addObject:topic];
                }
                //NSLog(@"loaded count object = %d", self.forum.topics.count);
                
                if (_onSuccess) _onSuccess(self.forum.topics);
            }
        } onPercent:^(float percent2) {
        }];
    } onPercent:^(float percent) {
    }];
}

- (void)loadNextPageOnSuccess:(void (^)(NSArray *arrData))_onSuccess
                      onFaild:(void (^)(NSError *error))_onFaild
{
    NSLog(@"load from %d to %d",self.currentPage*self.countPaging, ((self.currentPage+1)*self.countPaging)-1);
    [TapatalkAPI getTopicWithForum:self.forum.forum_id mode:@"ANY" startNum:(self.currentPage*self.countPaging) lastNum:(((self.currentPage+1)*self.countPaging)-1) completionHandler:^(ModelForum *result, NSError *error) {
        if (error) {
            _currentPage --;
            if (_onFaild) _onFaild(error);
        } else{
            _startNum = (self.currentPage*self.countPaging);
            _lastNum = (((self.currentPage+1)*self.countPaging)-1);
            
            self.forum.can_post = result.can_post;
            self.forum.total_topic_num = result.total_topic_num;
            self.forum.unread_sticky_cout = result.unread_sticky_cout;
            self.forum.unread_announce_count = result.unread_announce_count;
            self.forum.require_prefix = result.require_prefix;
            for (ModelTopic* topic in result.topics) {
                [self.forum.topics addObject:topic];
            }
            //NSLog(@"loaded count object = %d", result.topics.count);
            _currentPage ++;
            
            if (_onSuccess) _onSuccess(result.topics);
        }
    } onPercent:^(float percent2) {
    }];
}

@end
