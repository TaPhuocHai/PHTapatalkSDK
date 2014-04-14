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

@synthesize topic_author_id, topic_author_name, topic_id, topic_title, forum_id, prefix, can_subscribe, is_closed, is_subscribed, icon_url, last_reply_time, reply_number, new_post, view_number, short_content, is_approved, attachment, last_reply_user;
@synthesize can_reply, can_upload, position, total_post_num, posts;
@synthesize is_sticky;

- (id)initWithDictionary:(NSDictionary*)dic{

    if (self = [super init]) {
        self.topic_id          = [dic objectForKey:@"topic_id"];
        self.topic_title       = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"topic_title"]]
                                                       encoding:NSUTF8StringEncoding];
        self.forum_id          = [dic objectForKey:@"forum_id"];
        self.prefix            = [dic objectForKey:@"prefix"];
        self.topic_author_id   = [dic objectForKey:@"topic_author_id"];
        self.topic_author_name = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"topic_author_name"]]
                                                       encoding:NSUTF8StringEncoding];
        
        if(!self.topic_author_id) self.topic_author_id   = [dic objectForKey:@"post_author_id"];
        if (self.topic_author_name.length == 0) {
            self.topic_author_name = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"post_author_name"]]
                                                           encoding:NSUTF8StringEncoding];
        }
        
        
        self.can_subscribe     = [[dic objectForKey:@"can_subscribe"] boolValue];
        self.is_subscribed     = [[dic objectForKey:@"is_subscribed"] boolValue];
        self.is_closed         = [[dic objectForKey:@"is_closed"] boolValue];
        self.icon_url          = [dic objectForKey:@"icon_url"];
        self.last_reply_time   = [dic objectForKey:@"last_reply_time"];
        self.reply_number      = [[dic objectForKey:@"reply_number"] intValue];
        self.new_post          = [[dic objectForKey:@"new_post"] intValue];
        self.view_number       = [[dic objectForKey:@"view_number"] intValue];
        self.short_content     = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"short_content"]]
                                                       encoding:NSUTF8StringEncoding];
        self.is_approved       = [[dic objectForKey:@"is_approved"] boolValue];
        self.attachment        = [[dic objectForKey:@"attachment"] intValue];
        self.last_reply_user   = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"last_reply_user"]]
                                                       encoding:NSUTF8StringEncoding];
        
        self.timestamp         = [dic[@"timestamp"] intValue];
        //
        self.can_reply         = [[dic objectForKey:@"can_reply"] boolValue];
        self.can_subscribe     = [[dic objectForKey:@"can_subscribe"] boolValue];
        self.can_upload        = [[dic objectForKey:@"can_upload"] boolValue];
        self.position          = [[dic objectForKey:@"position"] intValue];
        self.total_post_num    = [[dic objectForKey:@"total_post_num"] intValue];
        self.posts             = [dic objectForKey:@"posts"];
        self.is_sticky         = NO;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ModelTopic *another = [[ModelTopic alloc] init];

    another.topic_id = self.topic_id;
    another.topic_title = self.topic_title;
    another.forum_id = self.forum_id;
    another.prefix = self.prefix;
    another.topic_author_id = self.topic_author_id;
    another.topic_author_name = self.topic_author_name;
    another.can_subscribe = self.can_subscribe;
    another.is_subscribed = self.is_subscribed;
    another.is_closed = self.is_closed;
    another.icon_url = self.icon_url;
    another.last_reply_time = self.last_reply_time;
    another.reply_number = self.reply_number;
    another.new_post = self.new_post;
    another.view_number = self.view_number;
    another.short_content = self.short_content;
    another.is_approved = self.is_approved;
    another.attachment = self.attachment;
    another.last_reply_user = self.last_reply_user;
    another.can_reply = self.can_reply;
    another.can_upload = self.can_upload;
    another.position = self.position;
    another.total_post_num = self.total_post_num;
    another.is_sticky = self.is_sticky;
    
    another.posts = [[NSMutableArray alloc] init];
    for (ModelPost *post in self.posts) {
        [another.posts addObject:[post copy]];
    }
    return another;
}

- (void)getDescriptionCompletionHandler:(void (^)(NSError *error))_completionHander {
    [TapatalkAPI getThreadWithTopic:self.topic_id returnHTML:NO startNum:0 lastNum:0 completionHandler:^(ModelTopic *result, NSError *error) {
        if (!error) {
            self.short_content = [((ModelPost*)[result.posts objectAtIndex:0]).post_content getWordInFirstCharactor:100];
            if(_completionHander) _completionHander(nil);
        } else {
            if(_completionHander) _completionHander(error);
        }
    } onPercent:^(float percent) {
    }];
}

@end
