//
//  LNPagingTopic.m
//  ProjectLana
//
//  Created by TAPHUOCHAI on 12/27/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import "LNPagingTopic.h"
#import "LNTapatalkSDK.h"
#import "TapatalkAPI.h"

#define kPagingTopicNumber  10

@interface LNPagingTopic ()

- (void)loadTopicForm:(int)from to:(int)to onSuccess:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild;

@end

@implementation LNPagingTopic

@synthesize pageLoaded;
@synthesize topic;

- (id)initTopic:(ModelTopic*)_topic
{
    if(self = [super init]) {
        self.topic = _topic;
        self.pageLoaded = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initTopic:(ModelTopic*)_topic paging:(int)count
{
    if (self = [super initWithPaging:count]) {
        self.topic = _topic;
        self.pageLoaded = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Kế thừa từ LNBasePaging

- (BOOL)isNextPage
{
    return [super isNextPage];
}

- (void)startPagingOnSuccess:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild
{
    if ([LNAccountManager sharedInstance].isLoggedIn) {
        [self loadTopicUnread:_countPaging completionHandler:^(NSArray *arrData) {
            _onSuccess(arrData);
        } onFaild:^(NSError *error) {
            _onFaild(error);
        }];
    } else {
        [self loadTopicForm:0 to:(_countPaging - 1) onSuccess:^(NSArray *arrData) {
            _maxIndexPageLoaded = _currentPage;
            _onSuccess(arrData);
        } onFaild:^(NSError *error) {
            _onFaild(error);
        }];
    }
}

- (void)loadNextPageOnSuccess:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild
{    
    [TapatalkAPI getThreadWithTopic:self.topic.topic_id returnHTML:YES startNum:(self.currentPage*_countPaging)
                           lastNum:(((self.currentPage+1)*_countPaging)-1) completionHandler:^(ModelTopic *result, NSError *error) {
                               
        if (!error) {
            _startNum = self.currentPage*_countPaging;
            _lastNum = ((self.currentPage+1)*_countPaging)-1;
            _currentPage = self.currentPage + 1;
            _maxIndexPageLoaded = _currentPage;
            
            self.topic.can_reply = result.can_reply;
            self.topic.can_subscribe = result.can_subscribe;
            self.topic.can_upload = result.can_upload;
            self.topic.total_post_num = result.total_post_num;
            
            _totalCountData = result.total_post_num;
            
            [self.pageLoaded addObject:[NSNumber numberWithInt:self.currentPage]];
            for (ModelPost *post in result.posts) {
                [self.topic.posts addObject:post];
            }
            
            _onSuccess(result.posts);
        } else {
            _onFaild(error);
        }
    } onPercent:^(float percent) {
    }];
}

- (void)reloadPagingOnSuccess:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild
{
    [self loadTopicForm:_startNum to:_lastNum onSuccess:^(NSArray *arrData) {
        _onSuccess(arrData);
    } onFaild:^(NSError *error) {
        _onFaild(error);
    }];
}

#pragma mark - Các hàm riêng của LNPagingTopic

- (BOOL)isPreviousPage
{
    for (NSNumber *number in self.pageLoaded)
    {
        if ([number intValue] == 1)
        {
            return NO;
        }
    }
    
    if (self.currentPage > 1) {
        return YES;
    }
    return NO;
}

- (BOOL)isLoad:(int)page {
    if ([self.pageLoaded count] == 0) {
        return NO;
    }
    
    for (NSNumber *number in self.pageLoaded) {
        if ([number intValue] == page) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isNextPage:(int)page {
    if ([self.pageLoaded count] == 0) {
        return NO;
    }
    if ([[self.pageLoaded objectAtIndex:(self.pageLoaded.count - 1)] intValue] == page - 1) {
        return YES;
    }
    return NO;
}

- (BOOL)isPreviousPage:(int)page {
    if ([self.pageLoaded count] == 0) {
        return NO;
    }
    if ([[self.pageLoaded objectAtIndex:0] intValue] == page + 1) {
        return YES;
    }
    return NO;
}

- (void)loadPrevPageOnSuccess:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild {
    if (_startNum < 0) {
        _startNum = 0;
    }
    
    int startNeedLoad = (self.currentPage - 2)*_countPaging;
    if (startNeedLoad < 0) {
        startNeedLoad = 0;
    }
    
    [TapatalkAPI getThreadWithTopic:self.topic.topic_id returnHTML:YES startNum:startNeedLoad lastNum:(startNeedLoad + _countPaging - 1) completionHandler:^(ModelTopic *result, NSError *error) {
        if (!error) {
            _startNum = startNeedLoad;
            _lastNum = ((self.currentPage*kPagingTopicNumber)-1);
            _currentPage = self.currentPage - 1;
            
            self.topic.can_reply = result.can_reply;
            self.topic.can_subscribe = result.can_subscribe;
            self.topic.can_upload = result.can_upload;
            self.topic.total_post_num = result.total_post_num;
            
            _totalCountData = result.total_post_num;
            
            [self.pageLoaded insertObject:[NSNumber numberWithInt:self.currentPage] atIndex:0];
            for (int i = [result.posts count] - 1 ; i >= 0 ; i --) {
                ModelPost *post = [result.posts objectAtIndex:i];
                [self.topic.posts insertObject:post atIndex:0];
            }
            
            _onSuccess(result.posts);
        } else {
            _onFaild(error);
        }
    } onPercent:^(float percent) {
    }];
}

- (void)jumpToPage:(int)page onSuccess:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild {
    if (page < 0) {
        _onFaild([NSError errorWithDomain:@"" code:1 userInfo:@{@"error" : @"Page quá nhỏ"}]);
        return;
    }
    if ((page-1)*_countPaging > _totalCountData) {
        _onFaild([NSError errorWithDomain:@"" code:1 userInfo:@{@"error" : @"Page quá lớn"}]);
        return;
    }
    
    [self loadTopicForm:(page-1)*_countPaging to:(page*_countPaging-1) onSuccess:^(NSArray *arrData) {
        _maxIndexPageLoaded = page;
        _onSuccess(arrData);
    } onFaild:^(NSError *error) {
        _onFaild(error);
    }];
}

#pragma mark - private method 

- (void)loadTopicForm:(int)from
                   to:(int)to
            onSuccess:(void (^)(NSArray *arrData))_onSuccess
              onFaild:(void (^)(NSError *error))_onFaild
{
    self.pageLoaded = [[NSMutableArray alloc] init];
    
    [TapatalkAPI getThreadWithTopic:self.topic.topic_id
                         returnHTML:YES
                           startNum:from
                            lastNum:to
                  completionHandler:^(ModelTopic *result2, NSError *error2)
    {
        if (!error2) {
            _startNum = from;
            _lastNum = to;
            _currentPage = self.startNum / _countPaging + 1;        
            
            [self.pageLoaded addObject:[NSNumber numberWithInt:self.currentPage]];
            
            self.topic.can_reply        = result2.can_reply;
            self.topic.can_subscribe    = result2.can_subscribe;
            self.topic.can_upload       = result2.can_upload;
            self.topic.total_post_num   = result2.total_post_num;
            self.topic.posts            = result2.posts;
            if (from == 0 && self.topic.posts.count) {
                ModelPost * firstPost = self.topic.posts[0];
                firstPost.is_first_post_in_topic = YES;
            }
            
            _totalCountData = result2.total_post_num;
            
            _onSuccess(self.topic.posts);
        } else {
            _onFaild(error2);
        }
    } onPercent:^(float percent) {
    }];
}

-(void)loadTopicUnread:(int)posts_per_request completionHandler:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild {
    [TapatalkAPI getThreadUnread:self.topic.topic_id returnHTML:YES postsPerRequest:posts_per_request completionHandler:^(ModelTopic *result, int position, NSError *error2) {
        
        if (!error2) {
            _startNum = position;
            _lastNum = position + result.posts.count;
            
            float tempTotal = position /(float) posts_per_request;
            _currentPage = (tempTotal > (int)tempTotal) ? tempTotal + 1 : (int)tempTotal;
            _maxIndexPageLoaded = _currentPage;
            [self.pageLoaded addObject:[NSNumber numberWithInt:self.currentPage]];
            
            self.topic.can_reply = result.can_reply;
            self.topic.can_subscribe = result.can_subscribe;
            self.topic.can_upload = result.can_upload;
            self.topic.total_post_num = result.total_post_num;
            self.topic.posts = result.posts;
            
            _totalCountData = result.total_post_num;
            
            _onSuccess(self.topic.posts);
        } else {
            // login and try again
            [LNAccountManager autoLoginOnCompletionHander:^(ModelUser *result2, NSError *error3) {
                if (error3) {
                    [self loadTopicForm:0 to:(_countPaging - 1) onSuccess:^(NSArray *arrData) {
                        _onSuccess(arrData);
                    } onFaild:^(NSError *error) {
                        _onFaild(error);
                    }];
                } else {
                    [TapatalkAPI getThreadUnread:self.topic.topic_id returnHTML:YES postsPerRequest:posts_per_request completionHandler:^(ModelTopic *result, int position, NSError *error4) {
                        
                        if (!error4) {
                            _startNum = position/posts_per_request;
                            _lastNum = position/posts_per_request + result.posts.count;
                            _currentPage = position / posts_per_request;
                            _maxIndexPageLoaded = _currentPage;
                            
                            [self.pageLoaded addObject:[NSNumber numberWithInt:self.currentPage]];
                            
                            self.topic.can_reply = result.can_reply;
                            self.topic.can_subscribe = result.can_subscribe;
                            self.topic.can_upload = result.can_upload;
                            self.topic.total_post_num = result.total_post_num;
                            self.topic.posts = result.posts;
                            
                            _totalCountData = result.total_post_num;
                            
                            _onSuccess(self.topic.posts);
                        } else {
                            _onFaild(error4);
                        }
                    }];
                }
            }];
        }
    }];
}

@end
