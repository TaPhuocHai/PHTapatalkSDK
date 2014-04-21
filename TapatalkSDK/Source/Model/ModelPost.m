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

@end
