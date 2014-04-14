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

@interface ModelForum : NSObject {
}

// Các thuộc tính này có khi gọi getForum
@property (nonatomic, strong) NSString * forum_id;
@property (nonatomic, strong) NSString * forum_name;
@property (nonatomic, strong) NSString * description;
@property (nonatomic, strong) NSString * parent_id;
@property (nonatomic, strong) NSString * logo_url;
@property (nonatomic)         BOOL       new_post;
@property (nonatomic)         BOOL       is_protected;
@property (nonatomic)         BOOL       is_subscribed;
@property (nonatomic)         BOOL       can_subscribe;
@property (nonatomic, strong) NSString * url;
@property (nonatomic)         BOOL       sub_only;

@property (nonatomic, strong) NSMutableArray *child;

// Các thuộc tính này chỉ có khi gọi getTopicWithMode function
@property (nonatomic, strong) NSMutableArray  * topics;
@property (nonatomic)         int        total_topic_num;
@property (nonatomic)         BOOL       can_post;
@property (nonatomic)         int        unread_sticky_cout;
@property (nonatomic)         int        unread_announce_count;
@property (nonatomic)         BOOL       require_prefix;
@property (nonatomic, strong) NSArray  * prefixes;
@property (nonatomic, strong) NSString * prefix_id;
@property (nonatomic, strong) NSString * prefix_display_name;

// Thuộc tính quản lý load page
@property (nonatomic) int               currentPage;
@property (nonatomic) int               startNum;
@property (nonatomic) int               lastNum;

// Các thuộc tính sử dụng để quản lý
@property (nonatomic, strong) UIImage  * logoImage;

- (id)initWithDictionary:(NSDictionary*)dic;
- (id)initWithId:(NSString*)_forumId
            name:(NSString*)_forumName
            logo:(UIImage*)_logo
     description:(NSString*)_description;

- (ModelForum*)findSubForumWithId:(NSString*)subForumId;

@end
