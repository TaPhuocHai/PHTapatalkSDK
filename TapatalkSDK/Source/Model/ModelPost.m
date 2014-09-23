//
//  ModelPost.m
//  ProjectLana
//
//  Created by TAPHUOCHAI on 10/31/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import "ModelPost.h"

#import "LNRequestHelper.h"

#import "XML+NSData+Base64.h"
#import <CommonCrypto/CommonDigest.h>


@implementation ModelPost

@synthesize allow_smilies = _allow_smilies,
attachment_authority = _attachment_authority,
icon_url = _icon_url,
is_approved = _is_approved,
post_author_id = _post_author_id,
post_author_name = _post_author_name,
post_content = _post_content,
post_count = _post_count,
post_id = _post_id,
post_time = _post_time,
post_title = _post_title,
topic_id = _topic_id,
date = _date;

- (id)initWithDictionary:(NSDictionary*)dic
{
    //NSLog(@"init Model Post - dic = %@", dic);
    if (self = [super init]) {
        _allow_smilies        = [[dic objectForKey:@"allow_smilies"] boolValue];
        _attachment_authority = [[dic objectForKey:@"attachment_authority"] intValue];
        _icon_url             = [dic objectForKey:@"icon_url"];
        _is_approved          = [[dic objectForKey:@"is_approved"] boolValue];
        _post_author_id       = [[dic objectForKey:@"post_author_id"] intValue];
        _post_author_name     = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"post_author_name"]]
                                                          encoding:NSUTF8StringEncoding];
        _post_content         = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"post_content"]]
                                                          encoding:NSUTF8StringEncoding];
        _post_count           = [[dic objectForKey:@"post_count"] intValue];
        _post_id              = [dic objectForKey:@"post_id"];
        _post_time            = [dic objectForKey:@"post_time"];
        _post_title           = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"post_title"]]
                                                          encoding:NSUTF8StringEncoding];
        _topic_id             = [dic objectForKey:@"topic_id"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        _allow_smilies        = [coder decodeBoolForKey:@"_allow_smilies"];
        _attachment_authority = (int)[coder decodeIntegerForKey:@"_attachment_authority"];
        _icon_url             = [coder decodeObjectForKey:@"_icon_url"];
        _is_approved          = [coder decodeBoolForKey:@"_is_approved"];
        _post_author_id       = (int)[coder decodeIntegerForKey:@"_post_author_id"];
        _post_author_name     = [coder decodeObjectForKey:@"_post_author_name"];
        _post_content         = [coder decodeObjectForKey:@"_post_content"];
        _post_count           = (int)[coder decodeIntegerForKey:@"_post_count"];
        _post_id              = [coder decodeObjectForKey:@"_post_id"];
        _post_time            = [coder decodeObjectForKey:@"_post_time"];
        _post_title           = [coder decodeObjectForKey:@"_post_title"];
        _topic_id             = [coder decodeObjectForKey:@"_topic_id"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeBool:_allow_smilies forKey:@"_allow_smilies"];
    [coder encodeInteger:_attachment_authority forKey:@"_attachment_authority"];
    [coder encodeObject:_icon_url forKey:@"_icon_url"];
    [coder encodeBool:_is_approved forKey:@"_is_approved"];
    [coder encodeInteger:_post_author_id forKey:@"_post_author_id"];
    [coder encodeObject:_post_author_name forKey:@"_post_author_name"];
    [coder encodeObject:_post_content forKey:@"_post_content"];
    [coder encodeInteger:_post_count forKey:@"_post_count"];
    [coder encodeObject:_post_id forKey:@"_post_id"];
    [coder encodeObject:_post_time forKey:@"_post_time"];
    [coder encodeObject:_post_title forKey:@"_post_title"];
    [coder encodeObject:_topic_id forKey:@"_topic_id"];
}

- (void)dealloc
{
    _icon_url = nil;
    _post_author_name = nil;
    _post_content = nil;
    _post_id = nil;
    _post_time = nil;
    _post_title = nil;
    _topic_id = nil;
}

@end
