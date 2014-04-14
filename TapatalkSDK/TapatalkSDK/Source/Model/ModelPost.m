//
//  ModelPost.m
//  ProjectLana
//
//  Created by TAPHUOCHAI on 10/31/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import "ModelPost.h"

#import "LNRequestHelper.h"

#import "NSData+Base64.h"
#import <CommonCrypto/CommonDigest.h>


@implementation ModelPost

@synthesize allow_smilies, attachment_authority, icon_url, is_approved, post_author_id, post_author_name, post_content, post_count, post_id, post_time, post_title, topic_id;

- (id)initWithDictionary:(NSDictionary*)dic
{
    //NSLog(@"init Model Post - dic = %@", dic);
    if (self = [super init]) {
        self.allow_smilies        = [[dic objectForKey:@"allow_smilies"] boolValue];
        self.attachment_authority = [[dic objectForKey:@"attachment_authority"] intValue];
        self.icon_url             = [dic objectForKey:@"icon_url"];
        self.is_approved          = [[dic objectForKey:@"is_approved"] boolValue];
        self.post_author_id       = [[dic objectForKey:@"post_author_id"] intValue];
        self.post_author_name     = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"post_author_name"]]
                                                          encoding:NSUTF8StringEncoding];
        self.post_content         = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"post_content"]]
                                                          encoding:NSUTF8StringEncoding];
        self.post_count           = [[dic objectForKey:@"post_count"] intValue];
        self.post_id              = [dic objectForKey:@"post_id"];
        self.post_time            = [dic objectForKey:@"post_time"];
        self.post_title           = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"post_title"]]
                                                          encoding:NSUTF8StringEncoding];
        self.topic_id             = [dic objectForKey:@"topic_id"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    ModelPost *another = [[ModelPost alloc] init];
    another.allow_smilies = self.allow_smilies;
    another.attachment_authority = self.attachment_authority;
    another.icon_url = self.icon_url;
    another.is_approved = self.is_approved;
    another.post_author_id = self.post_author_id;
    another.post_author_name = self.post_author_name;
    another.post_content = self.post_content;
    another.post_count = self.post_count;
    another.post_id = self.post_id;
    another.post_time = self.post_time;
    another.post_title = self.post_title;
    another.topic_id = self.topic_id;
    return another;
}

@end
