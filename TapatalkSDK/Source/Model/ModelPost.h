//
//  ModelPost.h
//  ProjectLana
//
//  Created by TAPHUOCHAI on 10/31/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelPost : NSObject

@property (nonatomic)         BOOL       allow_smilies;
@property (nonatomic)         int        attachment_authority;
@property (nonatomic, strong) NSString * icon_url;
@property (nonatomic)         BOOL       is_approved;
@property (nonatomic)         int        post_author_id;
@property (nonatomic, strong) NSString * post_author_name;
@property (nonatomic, strong) NSString * post_content;
@property (nonatomic)         int        post_count;
@property (nonatomic, strong) NSString * post_id;
@property (nonatomic, strong) NSString * post_time;
@property (nonatomic, strong) NSString * post_title;
@property (nonatomic, strong) NSString * topic_id;
@property (nonatomic)         BOOL       is_first_post_in_topic;

- (id)initWithDictionary:(NSDictionary*)dic;
- (id)copyWithZone:(NSZone *)zone;

@end
