//
//  ModelForum.h
//  ProjectLana
//
//  Created by TAPHUOCHAI on 10/31/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ModelTopic.h"

@interface ModelForum : NSObject

// Các thuộc tính này có khi gọi getForum
@property (nonatomic, readonly) NSString * forum_id;
@property (nonatomic, readonly) NSString * forum_name;
@property (nonatomic, readonly) NSString * description;
@property (nonatomic, readonly) NSString * parent_id;
@property (nonatomic, readonly) NSString * logo_url;
@property (nonatomic, readonly) BOOL       new_post;
@property (nonatomic, readonly) BOOL       is_protected;
@property (nonatomic, readonly) BOOL       is_subscribed;
@property (nonatomic, readonly) BOOL       can_subscribe;
@property (nonatomic, readonly) NSString * url;
@property (nonatomic, readonly) BOOL       sub_only;

@property (nonatomic, strong) NSMutableArray * child;

// Các thuộc tính này chỉ có khi gọi getTopicWithMode function
@property (nonatomic, strong) NSArray  * topics;
@property (nonatomic)         int        total_topic_num;
@property (nonatomic)         BOOL       can_post;
@property (nonatomic)         int        unread_sticky_cout;
@property (nonatomic)         int        unread_announce_count;
@property (nonatomic)         BOOL       require_prefix;
@property (nonatomic, strong) NSArray  * prefixes;
@property (nonatomic, strong) NSString * prefix_id;
@property (nonatomic, strong) NSString * prefix_display_name;

- (id)initWithDictionary:(NSDictionary*)dic;
- (id)initWithId:(NSString*)_forumId
            name:(NSString*)_forumName
         logoUrl:(NSString*)_logoUrl
     description:(NSString*)_description;

- (ModelForum*)findSubForumWithId:(NSString*)subForumId;

@end
