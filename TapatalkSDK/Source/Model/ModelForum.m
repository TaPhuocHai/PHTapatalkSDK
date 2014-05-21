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

#import "NSData+Base64.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ModelForum

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

@end
