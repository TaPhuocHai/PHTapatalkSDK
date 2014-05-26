//
//  ModelTopic.m
//  ProjectLana
//
//  Created by TAPHUOCHAI on 10/31/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import "ModelTopic.h"
#import "LNRequest.h"
#import "LNRequestHelper.h"

#import "LNTapatalkSDK.h"
#import "TapatalkAPI.h"

#import "NSData+Base64.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+LNTapatalkHelper.h"

@implementation ModelTopic

- (id)initWithId:(NSString*)topicId topicTitle:(NSString*)title forumId:(NSString*)forumId
{
    if (self = [super init]) {
        _topic_id = topicId;
        _topic_title = title;
        _forum_id = forumId;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dic
{
    if (self = [super init]) {
        _topic_id          = [dic objectForKey:@"topic_id"];
        _topic_title       = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"topic_title"]]
                                                       encoding:NSUTF8StringEncoding];
        _forum_id          = [dic objectForKey:@"forum_id"];
        _prefix            = [dic objectForKey:@"prefix"];
        _topic_author_id   = [dic objectForKey:@"topic_author_id"];
        _topic_author_name = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"topic_author_name"]]
                                                       encoding:NSUTF8StringEncoding];
        
        if(!_topic_author_id) _topic_author_id   = [dic objectForKey:@"post_author_id"];
        if (_topic_author_name.length == 0) {
            _topic_author_name = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"post_author_name"]]
                                                           encoding:NSUTF8StringEncoding];
        }
        
        
        _can_subscribe     = [[dic objectForKey:@"can_subscribe"] boolValue];
        _is_subscribed     = [[dic objectForKey:@"is_subscribed"] boolValue];
        _is_closed         = [[dic objectForKey:@"is_closed"] boolValue];
        _icon_url          = [dic objectForKey:@"icon_url"];
        _last_reply_time   = [dic objectForKey:@"last_reply_time"];
        _reply_number      = [[dic objectForKey:@"reply_number"] intValue];
        _new_post          = [[dic objectForKey:@"new_post"] intValue];
        _view_number       = [[dic objectForKey:@"view_number"] intValue];
        _short_content     = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"short_content"]]
                                                       encoding:NSUTF8StringEncoding];
        _is_approved       = [[dic objectForKey:@"is_approved"] boolValue];
        _attachment        = [[dic objectForKey:@"attachment"] intValue];
        _last_reply_user   = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"last_reply_user"]]
                                                       encoding:NSUTF8StringEncoding];
        
        _timestamp         = [dic[@"timestamp"] intValue];
        //
        _can_reply         = [[dic objectForKey:@"can_reply"] boolValue];
        _can_subscribe     = [[dic objectForKey:@"can_subscribe"] boolValue];
        _can_upload        = [[dic objectForKey:@"can_upload"] boolValue];
        _position          = [[dic objectForKey:@"position"] intValue];
        _total_post_num    = [[dic objectForKey:@"total_post_num"] intValue];
        
        _posts             = [dic objectForKey:@"posts"];
        _is_sticky         = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        _topic_id          = [coder decodeObjectForKey:@"_topic_id"];
        _topic_title       = [coder decodeObjectForKey:@"_topic_title"];
        _forum_id          = [coder decodeObjectForKey:@"_forum_id"];
        _prefix            = [coder decodeObjectForKey:@"_prefix"];
        _topic_author_id   = [coder decodeObjectForKey:@"_topic_author_id"];
        _topic_author_name = [coder decodeObjectForKey:@"_topic_author_name"];
        _can_subscribe     = [coder decodeBoolForKey:@"_can_subscribe"];
        _is_subscribed     = [coder decodeBoolForKey:@"_is_subscribed"];
        _is_closed         = [coder decodeBoolForKey:@"_is_closed"];
        _icon_url          = [coder decodeObjectForKey:@"_icon_url"];
        _last_reply_time   = [coder decodeObjectForKey:@"_last_reply_time"];
        _reply_number      = [coder decodeIntegerForKey:@"_reply_number"];
        _new_post          = [coder decodeBoolForKey:@"_new_post"];
        _view_number       = [coder decodeIntegerForKey:@"_view_number"];
        _short_content     = [coder decodeObjectForKey:@"_short_content"];
        _is_approved       = [coder decodeIntegerForKey:@"_is_approved"];
        _attachment        = [coder decodeIntegerForKey:@"_attachment"];
        _last_reply_user   = [coder decodeObjectForKey:@"_last_reply_user"];
        _timestamp         = [coder decodeIntegerForKey:@"_timestamp"];
        _posts             = [coder decodeObjectForKey:@"_posts"];

        _can_reply         = [coder decodeBoolForKey:@"_can_reply"];
        _can_upload        = [coder decodeBoolForKey:@"_can_upload"];
        _position          = [coder decodeIntegerForKey:@"_position"];
        _total_post_num    = [coder decodeIntegerForKey:@"_total_post_num"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_topic_id forKey:@"_topic_id"];
    [coder encodeObject:_topic_title forKey:@"_topic_title"];
    [coder encodeObject:_forum_id forKey:@"_forum_id"];
    [coder encodeObject:_prefix forKey:@"_prefix"];
    [coder encodeObject:_topic_author_name forKey:@"_topic_author_name"];
    [coder encodeObject:_topic_author_id forKey:@"_topic_author_id"];
    [coder encodeBool:_can_subscribe forKey:@"_can_subscribe"];
    [coder encodeBool:_is_subscribed forKey:@"_is_subscribed"];
    [coder encodeBool:_is_closed forKey:@"_is_closed"];
    [coder encodeObject:_icon_url forKey:@"_icon_url"];
    [coder encodeObject:_last_reply_user forKey:@"_last_reply_user"];
    [coder encodeInteger:_reply_number forKey:@"_reply_number"];
    [coder encodeInteger:_new_post forKey:@"_new_post"];
    [coder encodeInteger:_view_number forKey:@"_view_number"];
    [coder encodeObject:_short_content forKey:@"_short_content"];
    [coder encodeInteger:_is_approved forKey:@"_is_approved"];
    [coder encodeInteger:_attachment forKey:@"_attachment"];
    [coder encodeObject:_last_reply_user forKey:@"_last_reply_user"];
    [coder encodeInteger:_timestamp forKey:@"_timestamp"];
    [coder encodeObject:_posts forKey:@"_posts"];
    
    [coder encodeBool:_can_reply forKey:@"_can_reply"];
    [coder encodeBool:_can_upload forKey:@"_can_upload"];
    [coder encodeInteger:_position forKey:@"_position"];
    [coder encodeInteger:_total_post_num forKey:@"_total_post_num"];
}

- (void)getContentOnComplete:(void (^)(void))completeBlock
                   onFailure:(void (^)(NSError * error))failureBlock
{
    [TapatalkAPI getThreadWithTopic:self.topic_id
                         returnHTML:NO
                           startNum:0
                            lastNum:0
                  completionHandler:^(ModelTopic *result, NSError *error)
     {
         if (!error) {
             _content = result.posts[0];
             _short_content = [((ModelPost*)[result.posts objectAtIndex:0]).post_content getWordInFirstCharactor:100];
             if(completeBlock) completeBlock();
         } else {
             if(failureBlock) failureBlock(error);
         }
     } onPercent:^(float percent) {
     }];
}

@end
