//
//  TapatalkAPI.h
//  ProjectLana
//
//  Created by Ta Phuoc Hai on 3/15/13.
//  Copyright (c) 2013 Project Lana. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModelForum;
@class ModelPrefix;
@class ModelTopic;
@class ModelUser;

@interface TapatalkAPI : NSObject

+ (void)shareInstanceWithUrl:(NSString*)forumUrl;

#pragma mark - Login

+ (void)loginWithUsername:(NSData*)username
                 password:(NSData*)password
        completionHandler:(void (^)(ModelUser* result, NSError *error))_completionHander;

#pragma mark - Forum

// Lấy thông tin của form
// Nếu forum_id = nil : lấy toàn bộ cấu trúc forum
+ (void)getForum:(NSString*)_forum_id returnDescription:(BOOL)returnDescription completionHandler:(void (^)(ModelForum *result))_completionHandler failureHandler:(void (^)(NSError *error))_failureHandler;

// Lấy thông tin topic của 1 forum
+ (void)getTopicWithForum:(NSString*)forumId mode:(NSString*)mode
                 startNum:(NSInteger)startNum
                  lastNum:(NSInteger)lastNum
        completionHandler:(void (^)(ModelForum *result, NSError *error))_completionHander
                onPercent:(void (^)(float percent))_percent;

// Lấy thông tin topic chưa đọc
+ (void)getUnreadTopicWithStartNum:(NSInteger)start_num
                           lastNum:(NSInteger)last_num
                 completionHandler:(void (^)(NSArray *arrTopic, NSInteger totalTopicNum ,NSError *error))_completionHander
                         onPercent:(void (^)(float percent))_percent;

// Tạo mới totpic
+ (void)newTopicWithForumId:(NSString*)forum_id
                    subject:(NSString*)subject
                       body:(NSString*)body
                     prefix:(ModelPrefix*)prefix
                    success:(void (^)(NSString* topic_id))_onSuccess
                      faild:(void (^)(NSError *error))_onFaild;

#pragma mark - Topic

+ (void)getThreadWithTopic:(NSString*)topic_id returnHTML:(BOOL)return_html startNum:(NSInteger)_startNum lastNum:(NSInteger)_lastNum completionHandler:(void (^)(ModelTopic *result, NSError *error))_completionHander onPercent:(void (^)(float percent))_percent;

+ (void)getThreadUnread:(NSString*)topic_id
             returnHTML:(BOOL)return_html
        postsPerRequest:(NSInteger)posts_per_request
      completionHandler:(void (^)(ModelTopic *result,NSInteger position, NSError *error))_completionHander;

+ (void)replyTopic:(ModelTopic*)topic
       withSubject:(NSString*)subject
              body:(NSString*)body
        attachment:(NSArray*)attack
 completionHandler:(void (^)(NSError *error))_completionHander
         onPercent:(void (^)(float percent))_percent;

#pragma mark - Search

+ (void)searchTopic:(NSString*)searchString
        startNumber:(NSInteger)startNumber
         lastNumber:(NSInteger)lastNumber
           searchId:(NSString*)searchId
  completionHandler:(void (^)(NSString *searchId, NSArray *arrTopic, NSInteger totalTopicNum , NSError *error))_completionHander
          onPercent:(void (^)(float percent))_percent;

#pragma mark - Subscribe

+ (void)getSubscribeTopic:(int)_startNum
                  lastNum:(int)_lastNum
        completionHandler:(void (^)(NSArray *arrTopic, NSInteger totalTopicNum, NSError *error))_completionHander;

+ (void)subscribeTopic:(NSString*)topicId
               success:(void (^)(void))_onSuccess
                  fail:(void (^)(NSError *error))_onFail;

+ (void)unsubscribeTopic:(NSString*)topicId
                 success:(void (^)(void))_onSuccess
                    fail:(void (^)(NSError *error))_onFail;

#pragma mark - Post

+ (void)reportPost:(NSString*)postId
            reason:(NSString*)message
           success:(void (^)(void))_onSuccess
              fail:(void (^)(NSError *error))_onFail;

+ (void)thanksPost:(NSString*)post_id
 completionHandler:(void (^)(NSError *error))_completionHander;

+ (void)getQuotePost:(NSString*)post_id
   completionHandler:(void (^)(NSString *title, NSString *content, NSError *error))_completionHander;

@end
