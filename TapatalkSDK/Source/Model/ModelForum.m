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
        self.forum_id       = forumId;
        self.forum_name     = forumName;
        self.description    = description;
        self.logo_url       = logoUrl;
        self.child          = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Private helper

- (void)parseDataFormDictionary:(NSDictionary*)dic
{
    self.forum_id         = [dic objectForKey:@"forum_id"];
    self.forum_name       = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"forum_name"]]
                                                  encoding:NSUTF8StringEncoding];
    self.description      = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"description"]]
                                                  encoding:NSUTF8StringEncoding];
    self.parent_id        = [dic objectForKey:@"parent_id"];
    self.logo_url         = [dic objectForKey:@"logo_url"];
    self.new_post         = [[dic objectForKey:@"new_post"] boolValue];
    self.is_protected     = [[dic objectForKey:@"is_protected"] boolValue];
    self.is_subscribed    = [[dic objectForKey:@"is_subscribed"] boolValue];
    self.can_subscribe    = [[dic objectForKey:@"can_subscribe"] boolValue];
    self.url              = [dic objectForKey:@"url"];
    self.sub_only         = [[dic objectForKey:@"sub_only"] boolValue];

    self.child            = [dic objectForKey:@"child"];
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
