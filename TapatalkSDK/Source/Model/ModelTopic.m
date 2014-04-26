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

#pragma mark - Propreties

//- (ModelPost*)content
//{
//    if (!_content) {
//        if (self.posts.count) {
//            ModelPost * firstPost = self.posts.firstObject;
//            if (firstPost.po) {
//                <#statements#>
//            }
//        }
//    }
//    return _content;
//}

@end
