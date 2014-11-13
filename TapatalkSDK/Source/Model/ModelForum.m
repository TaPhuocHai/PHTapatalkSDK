//
//  ModelForum.m
//  ProjectLana
//
//  Created by TAPHUOCHAI on 10/31/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import "ModelForum.h"
#import "LNRequest.h"
#import "LNRequestHelper.h"

#import "XML+NSData+Base64.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ModelForum

@synthesize description = _description,
forum_id = _forum_id,
forum_name = _forum_name,
parent_id = _parent_id,
logo_url = _logo_url,
new_post = _new_post,
is_protected = _is_protected,
is_subscribed = _is_subscribed,
can_subscribe = _can_subscribe,
sub_only = _sub_only,
child = _child;

- (id)initWithDictionary:(NSDictionary*)dic
{
    if(self = [super init]) {
        [self parseDataFormDictionary:dic];
    }
    return self;
}

- (id)initWithId:(NSString*)forumId
            name:(NSString*)forumName
         logoUrl:(NSString*)logoUrl
     description:(NSString*)description
{
    if (self = [super init]) {
        _forum_id       = forumId;
        _forum_name     = forumName;
        _description    = description;
        _logo_url       = logoUrl;
        _child          = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Coder

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        _forum_id              = [coder decodeObjectForKey:@"_forum_id"];
        _forum_name            = [coder decodeObjectForKey:@"_forum_name"];
        _description           = [coder decodeObjectForKey:@"_description"];
        _parent_id             = [coder decodeObjectForKey:@"_parent_id"];
        _logo_url              = [coder decodeObjectForKey:@"_logo_url"];
        _new_post              = [coder decodeBoolForKey:@"_new_post"];
        _is_protected          = [coder decodeBoolForKey:@"_is_protected"];
        _is_subscribed         = [coder decodeBoolForKey:@"_is_subscribed"];
        _can_subscribe         = [coder decodeBoolForKey:@"_can_subscribe"];
        _url                   = [coder decodeObjectForKey:@"_url"];
        _sub_only              = [coder decodeBoolForKey:@"_sub_only"];
        
        _child                 = [coder decodeObjectForKey:@"_child"];

        _topics                = [coder decodeObjectForKey:@"_topics"];
        _total_topic_num       = (int)[coder decodeIntegerForKey:@"_total_topic_num"];
        _can_post              = [coder decodeBoolForKey:@"_can_post"];
        _unread_sticky_cout    = (int)[coder decodeIntegerForKey:@"_unread_sticky_cout"];
        _unread_announce_count = (int)[coder decodeIntegerForKey:@"_unread_announce_count"];
        _require_prefix        = [coder decodeBoolForKey:@"_require_prefix"];
        _prefixes              = [coder decodeObjectForKey:@"_prefixes"];
        _prefix_id             = [coder decodeObjectForKey:@"_prefix_id"];
        _prefix_display_name   = [coder decodeObjectForKey:@"_prefix_display_name"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_forum_id forKey:@"_forum_id"];
    [coder encodeObject:_forum_name forKey:@"_forum_name"];
    [coder encodeObject:_description forKey:@"_description"];
    [coder encodeObject:_parent_id forKey:@"_parent_id"];
    [coder encodeObject:_logo_url forKey:@"_logo_url"];
    [coder encodeBool:_new_post forKey:@"_new_post"];
    [coder encodeBool:_is_protected forKey:@"_is_protected"];
    [coder encodeBool:_is_subscribed forKey:@"_is_subscribed"];
    [coder encodeBool:_can_subscribe forKey:@"_can_subscribe"];
    [coder encodeObject:_url forKey:@"_url"];
    [coder encodeBool:_sub_only forKey:@"_sub_only"];
    
    [coder encodeObject:_child forKey:@"_child"];
    
    [coder encodeObject:_topics forKey:@"_topics"];
    [coder encodeInteger:_total_topic_num forKey:@"_total_topic_num"];
    [coder encodeBool:_can_post forKey:@"_can_post"];
    [coder encodeInteger:_unread_sticky_cout forKey:@"_unread_sticky_cout"];
    [coder encodeInteger:_unread_announce_count forKey:@"_unread_announce_count"];
    [coder encodeBool:_require_prefix forKey:@"_require_prefix"];
    [coder encodeObject:_prefixes forKey:@"_prefixes"];
    [coder encodeObject:_prefix_id forKey:@"_prefix_id"];
    [coder encodeObject:_prefix_display_name forKey:@"_prefix_display_name"];
}


#pragma mark - Private helper

- (void)parseDataFormDictionary:(NSDictionary*)dic
{
    _forum_id         = [dic objectForKey:@"forum_id"];
    _forum_name       = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"forum_name"]]
                                                  encoding:NSUTF8StringEncoding];
    _description      = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"description"]]
                                                  encoding:NSUTF8StringEncoding];
    _parent_id        = [dic objectForKey:@"parent_id"];
    _logo_url         = [dic objectForKey:@"logo_url"];
    _new_post         = [[dic objectForKey:@"new_post"] boolValue];
    _is_protected     = [[dic objectForKey:@"is_protected"] boolValue];
    _is_subscribed    = [[dic objectForKey:@"is_subscribed"] boolValue];
    _can_subscribe    = [[dic objectForKey:@"can_subscribe"] boolValue];
    _url              = [dic objectForKey:@"url"];
    _sub_only         = [[dic objectForKey:@"sub_only"] boolValue];

    _child            = [dic objectForKey:@"child"];
}

#pragma mark - 

- (ModelForum*)findSubForumWithId:(NSString*)subForumId
{
    if ([self.forum_id isEqualToString:subForumId]) {
        return self;
    }
    
    for (ModelForum * subForum in self.child) {
        ModelForum * forum = [subForum findSubForumWithId:subForumId];
        if (forum) return forum;
    }
    return nil;
}

#pragma mark - dealloc

- (void)dealloc
{
    _forum_id = nil;
    _forum_name = nil;
    _description = nil;
    _parent_id = nil;
    _logo_url = nil;
    _url = nil;
    _child = nil;
    _topics = nil;
    _prefix_display_name = nil;
    _prefix_id = nil;
    _prefixes = nil;
}

@end
