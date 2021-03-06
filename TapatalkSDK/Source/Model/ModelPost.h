//
//  ModelPost.h
//  ProjectLana
//
//  Created by TAPHUOCHAI on 10/31/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelPost : NSObject
{
    BOOL       _allow_smilies;
    int        _attachment_authority;
    NSString * _icon_url;
    BOOL       _is_approved;
    int        _post_author_id;
    NSString * _post_author_name;
    NSString * _post_content;
    int        _post_count;
    NSString * _post_id;
    NSString * _post_time;
    NSString * _post_title;
    NSString * _topic_id;
    NSDate   * _date;
}

@property (nonatomic, readonly) BOOL       allow_smilies;
@property (nonatomic, readonly) int        attachment_authority;
@property (nonatomic, readonly) NSString * icon_url;
@property (nonatomic, readonly) BOOL       is_approved;
@property (nonatomic, readonly) int        post_author_id;
@property (nonatomic, readonly) NSString * post_author_name;
@property (nonatomic, readonly) NSString * post_content;
@property (nonatomic, readonly) int        post_count;
@property (nonatomic, readonly) NSString * post_id;
@property (nonatomic, readonly) NSString * post_time;
@property (nonatomic, readonly) NSString * post_title;
@property (nonatomic, readonly) NSString * topic_id;

@property (nonatomic, readonly) NSDate   * date;

@property (nonatomic)         BOOL       is_first_post_in_topic;

- (id)initWithDictionary:(NSDictionary*)dic;

@end
