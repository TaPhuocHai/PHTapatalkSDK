//
//  LNPagingTopic.m
//  ProjectLana
//
//  Created by TAPHUOCHAI on 12/27/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import "LNTopicPaging.h"
#import "LNTapatalkSDK.h"
#import "TapatalkAPI.h"

#define kPagingTopicNumber  10

@interface LNTopicPaging ()

@property (nonatomic, readonly) NSArray * pageLoaded;

@property(nonatomic, copy) void (^_completionBlock)(NSArray * data, NSInteger totalDataNumber);
@property(nonatomic, copy) void (^_errorBlock)(NSError *error);

@end

@implementation LNTopicPaging

@synthesize topic = _topic,
dataOfPage = _dataOfPage;

- (id)initTopic:(ModelTopic*)topic
{
    if(self = [super init]) {
        _topic = topic;
        self.delegate = self;
    }
    return self;
}

- (id)initTopic:(ModelTopic*)topic perPage:(NSInteger)perPage
{
    if (self = [super initWithPerPage:perPage]) {
        _topic = topic;
        self.delegate = self;
    }
    return self;
}

#pragma mark - Properties

- (NSArray*)pageLoaded
{
    return self.dataOfPage.allKeys;
}

#pragma mark - LNBasePagingDelegate

- (void)loadDataFrom:(NSInteger)from
                  to:(NSInteger)to
            complete:(void (^)(NSArray * data, NSInteger totalDataNumber))completeBlock
             failure:(void (^)(NSError * error))failureBlock
{
    self._completionBlock = completeBlock;
    self._errorBlock = failureBlock;
    
    if (!_dataOfPage) _dataOfPage = [NSMutableDictionary dictionary];
    
    __block typeof(self) wself = self;
    [self loadTopicForm:from
                     to:to
               complete:^(NSArray *arrData, NSInteger totalDataNumber)
     {
         if (from == 0) {
             _lastRequestPage = 1;
             _dataOfPage[@(1)] = arrData;
         } else {
             int pageRequet = from/wself.perPage + 1;
             _lastRequestPage = pageRequet;
             _dataOfPage[@(pageRequet)] = arrData;
             NSLog(@"Load page %d", pageRequet);
         }
         
         if (wself._completionBlock) wself._completionBlock(arrData, totalDataNumber);
         [self cleanUp];
     } failure:^(NSError *error) {
         if (wself._errorBlock) wself._errorBlock(error);
         [self cleanUp];
     }];    
    /*
    if (from == 0) {
        [self loadTopicUnread:self.perPage
                     complete:^(NSArray *arrData, NSInteger position, NSInteger totalDataNumber)
        {
            // Tính lại lastRequsetPage thực sự
            float tempRequsetPage = position /(float) self.perPage;
            _lastRequestPage = (tempRequsetPage > (int)tempRequsetPage) ? tempRequsetPage + 1 : (int)tempRequsetPage;
            
            // Set lại data thật sự
            NSLog(@"Load page %d", _lastRequestPage);
            if (!_dataOfPage) _dataOfPage = [NSMutableDictionary dictionary];
            _dataOfPage[@(_lastRequestPage)] = arrData;
            
            if (completeBlock) completeBlock(arrData, totalDataNumber);
            
        } failure:^(NSError *error) {
            // Try request againt
            [self loadTopicForm:from
                             to:to
                       complete:^(NSArray *arrData, NSInteger totalDataNumber)
             {
                 NSLog(@"Load page %d", _lastRequestPage);
                 _lastRequestPage = 1;
                 _dataOfPage[@(1)] = arrData;
                 
                 if (completeBlock) completeBlock(arrData, totalDataNumber);
             } failure:^(NSError *error) {
                 if (failureBlock) failureBlock(error);
             }];
        }];
    } else {
        [self loadTopicForm:from
                         to:to
                   complete:^(NSArray *arrData, NSInteger totalDataNumber)
        {
            int pageRequet = from/self.perPage + 1;
            _lastRequestPage = pageRequet;
            _dataOfPage[@(pageRequet)] = arrData;
            NSLog(@"Load page %d", pageRequet);

            if (completeBlock) completeBlock(arrData, totalDataNumber);
        } failure:^(NSError *error) {
            if (failureBlock) failureBlock(error);
        }];
    }
     */
}

#pragma mark - Các hàm riêng của LNPagingTopic

- (BOOL)hadPrevPage
{
    for (NSNumber *number in self.pageLoaded) {
        if ([number intValue] == 1) {
            return NO;
        }
    }
    
    if ([self minPageIndexLoaded] > 1) {
        return YES;
    }
    return NO;
}

- (BOOL)hadNextPage
{
    if ([self maxPageIndexLoaded] < self.totalPage) {
        return YES;
    }
    return NO;
}

- (BOOL)pageIsLoaded:(int)page
{
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

- (BOOL)pageIsNextPageInCurrentLoaded:(int)page
{
    if ([self.pageLoaded count] == 0) {
        return NO;
    }
    
    if ([self maxPageIndexLoaded] == page - 1) {
        return YES;
    }
    return NO;
}

- (BOOL)pageIsPrevPageInCurrentLoaded:(int)page
{
    if ([self.pageLoaded count] == 0) {
        return NO;
    }
    if ([self minPageIndexLoaded]  == page + 1) {
        return YES;
    }
    return NO;
}

- (void)loadPrevPageOnComplete:(void (^)(NSArray *arrData))completeBlock
                       failure:(void (^)(NSError *error))failureBlock
{
    int minPageRequest = [self minPageIndexLoaded];
    
    int pageRequest = minPageRequest - 1;
    if (pageRequest < 0) {
        if (failureBlock) failureBlock([NSError errorWithDomain:@"local"
                                                           code:1
                                                       userInfo:@{@"error" : @"Page quá nhỏ"}]);
        return;
    }
    
    [TapatalkAPI getThreadWithTopic:self.topic.topic_id
                         returnHTML:YES
                           startNum:(pageRequest - 1) * self.perPage
                            lastNum:(pageRequest * self.perPage) - 1
                  completionHandler:^(ModelTopic *result, NSError *error)
    {
        if (!error) {
            self.topic.can_reply = result.can_reply;
            self.topic.can_upload = result.can_upload;
            self.topic.total_post_num = result.total_post_num;

            for (int i = result.posts.count - 1; i >= 0; i--) {
                ModelTopic * topic = result.posts[i];
                [_data insertObject:topic atIndex:0];
            }
            
            _lastRequestPage = pageRequest;
            NSLog(@"Load page %d", _lastRequestPage);
            _dataOfPage[@(pageRequest)] = result.posts;
            
            if (completeBlock) completeBlock(result.posts);
        } else {
            if (failureBlock) failureBlock(error);
        }
    } onPercent:^(float percent) {
    }];
}

- (void)jumpToPage:(NSInteger)page
          complete:(void (^)(NSArray *arrData))completeBlock
           failure:(void (^)(NSError *error))failureBlock
{
    if (page < 0) {
        if (failureBlock) failureBlock([NSError errorWithDomain:@"local"
                                                           code:1
                                                       userInfo:@{@"error" : @"Page quá nhỏ"}]);
        return;
    }
    if (page > self.totalPage) {
        if (failureBlock) failureBlock([NSError errorWithDomain:@"local"
                                                           code:1
                                                       userInfo:@{@"error" : @"Page quá lớn"}]);
        return;
    }

    [self loadTopicForm:(page - 1) * self.perPage
                     to:(page * self.perPage) - 1
               complete:^(NSArray *arrData, NSInteger totalDataNumber) {
                   // Clear all old data
                   _data = nil;
                   _data = [NSMutableArray arrayWithArray:arrData];
                   
                   _lastRequestPage = page;
                   NSLog(@"Jump : Load page %d", _lastRequestPage);
                   [_dataOfPage removeAllObjects];
                   _dataOfPage[@(page)] = arrData;
                   
                   if (completeBlock) completeBlock(arrData);
               } failure:^(NSError *error) {
                   if (failureBlock) failureBlock(error);
               }];
}

#pragma mark - Private helper method

// Trang lớn nhất đã load
- (int)maxPageIndexLoaded
{
    int max = 0;
    for (NSNumber * number in self.pageLoaded) {
        if ([number intValue] > max) {
            max = [number intValue];
        }
    }
    return max;
}

// Load nhỏ nhất đã load
- (int)minPageIndexLoaded
{
    int min = INT_MAX;
    for (NSNumber * number in self.pageLoaded) {
        if ([number intValue] < min) {
            min = [number intValue];
        }
    }
    return min;
}

#pragma mark - private method 

- (void)loadTopicForm:(NSInteger)from
                   to:(NSInteger)to
             complete:(void (^)(NSArray *arrData, NSInteger totalDataNumber))completeBlock
              failure:(void (^)(NSError *error))failureBlock
{
    __block typeof(self) wself = self;

    [TapatalkAPI getThreadWithTopic:wself.topic.topic_id
                         returnHTML:YES
                           startNum:from
                            lastNum:to
                  completionHandler:^(ModelTopic *result, NSError *error)
    {
        if (!error) {
            wself.topic.can_reply        = result.can_reply;
            wself.topic.can_upload       = result.can_upload;
            wself.topic.total_post_num   = result.total_post_num;
            
            if (from == 0 && result.posts.count) {
                ModelPost * firstPost = result.posts[0];
                firstPost.is_first_post_in_topic = YES;
            }
            if(completeBlock) completeBlock(result.posts ,result.total_post_num);
        } else {
            if(failureBlock) failureBlock(error);
        }
    } onPercent:^(float percent) {
    }];
}

-(void)loadTopicUnread:(NSInteger)posts_per_request
              complete:(void (^)(NSArray *arrData, NSInteger position, NSInteger totalDataNumber))completeBlock
               failure:(void (^)(NSError *error))failureBlock
{
    [TapatalkAPI getThreadUnread:self.topic.topic_id
                      returnHTML:YES
                 postsPerRequest:posts_per_request
               completionHandler:^(ModelTopic *result, NSInteger position, NSError *error)
    {
        if (!error) {
            self.topic.can_reply = result.can_reply;
            self.topic.can_upload = result.can_upload;
            self.topic.total_post_num = result.total_post_num;

            if(completeBlock) completeBlock(result.posts, position,result.total_post_num);
        } else {
            // login and try again
            [LNAccountManager autoLoginOnCompletionHander:^(ModelUser *result2, NSError *error2) {
                if (error2) {
                    if (failureBlock) failureBlock (error);
                } else {
                    [TapatalkAPI getThreadUnread:self.topic.topic_id
                                      returnHTML:YES
                                 postsPerRequest:posts_per_request
                               completionHandler:^(ModelTopic *result,NSInteger position, NSError *error3)
                    {
                        if (!error3) {
                            self.topic.can_reply = result.can_reply;
                            self.topic.can_upload = result.can_upload;
                            self.topic.total_post_num = result.total_post_num;
                            
                            if(completeBlock) completeBlock(result.posts, position,result.total_post_num);
                        } else {
                            if (failureBlock) failureBlock (error);
                        }
                    }];
                }
            }];
        }
    }];
}

#pragma mark - 

- (void)cleanUp
{
    self._completionBlock = nil;
    self._errorBlock = nil;
}

- (void)dealloc
{
    NSLog(@"dealloc LNTopicPaging");
    
    self.delegate = nil;
    _topic = nil;
    _dataOfPage = nil;
}


@end
