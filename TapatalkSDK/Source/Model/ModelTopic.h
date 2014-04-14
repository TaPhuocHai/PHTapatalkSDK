//
//  ModelTopic.h
//  ProjectLana
//
//  Created by TAPHUOCHAI on 10/31/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelTopic : NSObject

@property (nonatomic, strong) NSString* topic_id;
@property (nonatomic, strong) NSString* topic_title;
@property (nonatomic, strong) NSString* forum_id;
@property (nonatomic, strong) NSString* prefix;
@property (nonatomic, strong) NSString* topic_author_id;
@property (nonatomic, strong) NSString* topic_author_name;
@property (nonatomic) BOOL              can_subscribe;
@property (nonatomic) BOOL              is_subscribed;
@property (nonatomic) BOOL              is_closed;
@property (nonatomic, strong) NSString* icon_url;
@property (nonatomic, strong) NSString* last_reply_time;
@property (nonatomic) int               reply_number;
@property (nonatomic) BOOL              new_post;
@property (nonatomic) int               view_number;
@property (nonatomic, strong) NSString* short_content;
@property (nonatomic) int               is_approved;
@property (nonatomic) int               attachment;
@property (nonatomic, strong) NSString* last_reply_user;
@property (nonatomic) int               timestamp;

// Các dữ liệu dưới đây chỉ có được khi gọi hàm getThreadWithReturnHTML
@property (nonatomic) BOOL              can_reply;
@property (nonatomic) BOOL              can_upload;
@property (nonatomic) int               position;
@property (nonatomic) int               total_post_num;
@property (nonatomic, strong) NSMutableArray *posts;

@property (nonatomic) BOOL              is_sticky;

- (id)initWithDictionary:(NSDictionary*)dic;
- (id)copyWithZone:(NSZone *)zone;

- (void)getDescriptionCompletionHandler:(void (^)(NSError *error))_completionHander;

@end
