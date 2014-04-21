//
//  ModelTopic.h
//  ProjectLana
//
//  Created by TAPHUOCHAI on 10/31/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelPost.h"

@interface ModelTopic : NSObject

@property (nonatomic, readonly) NSString * topic_id;
@property (nonatomic, readonly) NSString * topic_title;
@property (nonatomic, readonly) NSString * forum_id;
@property (nonatomic, readonly) NSString * prefix;
@property (nonatomic, readonly) NSString * topic_author_id;
@property (nonatomic, readonly) NSString * topic_author_name;
@property (nonatomic, readonly) BOOL       can_subscribe;
@property (nonatomic, readonly) BOOL       is_subscribed;
@property (nonatomic, readonly) BOOL       is_closed;
@property (nonatomic, readonly) NSString * icon_url;
@property (nonatomic, readonly) NSString * last_reply_time;
@property (nonatomic, readonly) int        reply_number;
@property (nonatomic, readonly) BOOL       new_post;
@property (nonatomic, readonly) int        view_number;
@property (nonatomic, readonly) NSString * short_content;
@property (nonatomic, readonly) int        is_approved;
@property (nonatomic, readonly) int        attachment;
@property (nonatomic, readonly) NSString * last_reply_user;
@property (nonatomic, readonly) int        timestamp;
@property (nonatomic, readonly) NSArray *  posts;

// Các dữ liệu dưới đây chỉ có được khi gọi hàm getThreadWithReturnHTML
@property (nonatomic) BOOL              can_reply;
@property (nonatomic) BOOL              can_upload;
@property (nonatomic) int               position;
@property (nonatomic) int               total_post_num;

@property (nonatomic) BOOL                is_sticky;
@property (nonatomic, strong) ModelPost * content;

- (id)initWithDictionary:(NSDictionary*)dic;

- (void)getContentOnComplete:(void (^)(void))completeBlock
                   onFailure:(void (^)(NSError * error))failureBlock;

@end
