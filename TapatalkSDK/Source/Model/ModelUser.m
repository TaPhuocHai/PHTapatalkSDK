//
//  ModelUser.m
//  ProjectLana
//
//  Created by TGM on 10/30/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import "ModelUser.h"

#import "XML+NSData+Base64.h"

@implementation ModelUser

@synthesize user_id, post_count, can_pm, can_moderate, can_search, can_send_pm, can_upload_avatar, can_whosonline, max_attachment, max_jpg_size, max_png_size, result_text, username, icon_url;

- (id)initWithDictionary:(NSDictionary*)dic{
    if(self = [super init]) {
        [self parseDataFromDictionary:dic];
    }
    return self;
}

- (void)parseDataFromDictionary:(NSDictionary*)dic
{
    self.user_id           = [[dic objectForKey:@"user_id"] intValue];
    self.post_count        = [[dic objectForKey:@"post_count"] intValue];
    self.can_pm            = [[dic objectForKey:@"can_pm"] boolValue];
    self.can_moderate      = [[dic objectForKey:@"can_moderate"] boolValue];
    self.can_search        = [[dic objectForKey:@"can_search"] boolValue];
    self.can_send_pm       = [[dic objectForKey:@"can_send_pm"] boolValue];
    self.can_upload_avatar = [[dic objectForKey:@"can_upload_avatar"] boolValue];
    self.can_whosonline    = [[dic objectForKey:@"can_whosonline"] boolValue];
    self.max_attachment    = [[dic objectForKey:@"max_attachment"] intValue];
    self.max_jpg_size      = [[dic objectForKey:@"max_jpg_size"] intValue];
    self.max_png_size      = [[dic objectForKey:@"max_png_size"] intValue];
    NSData *resultTextData = [NSData dataFromBase64String:[dic objectForKey:@"result_text"]];
    self.result_text       = [[NSString alloc] initWithData:resultTextData encoding:NSUTF8StringEncoding];
    NSData *userData       = [NSData dataFromBase64String:[dic objectForKey:@"username"]];
    self.username          = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
    self.icon_url          = [dic objectForKey:@"icon_url"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        self.user_id           = [coder decodeIntForKey:@"user_id"];
        self.post_count        = [coder decodeIntForKey:@"post_count"];
        self.can_pm            = [coder decodeBoolForKey:@"can_pm"];
        self.can_moderate      = [coder decodeBoolForKey:@"can_moderate"];
        self.can_search        = [coder decodeBoolForKey:@"can_search"];
        self.can_send_pm       = [coder decodeBoolForKey:@"can_send_pm"];
        self.can_upload_avatar = [coder decodeBoolForKey:@"can_upload_avatar"];
        self.can_whosonline    = [coder decodeBoolForKey:@"can_whosonline"];
        self.max_attachment    = [coder decodeIntForKey:@"max_attachment"];
        self.max_jpg_size      = [coder decodeIntForKey:@"max_jpg_size"];
        self.max_png_size      = [coder decodeIntForKey:@"max_png_size"];
        self.username          = [coder decodeObjectForKey:@"username"];
        self.icon_url          = [coder decodeObjectForKey:@"icon_url"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt:self.user_id     forKey:@"user_id"];
    [coder encodeInt:self.post_count forKey:@"post_count"];
    [coder encodeBool:self.can_pm forKey:@"can_pm"];
    [coder encodeBool:self.can_moderate forKey:@"can_moderate"];
    [coder encodeBool:self.can_search forKey:@"can_search"];
    [coder encodeBool:self.can_send_pm forKey:@"can_send_pm"];
    [coder encodeBool:self.can_upload_avatar forKey:@"can_upload_avatar"];
    [coder encodeBool:self.can_whosonline forKey:@"can_whosonline"];
    [coder encodeInt:self.max_attachment forKey:@"max_attachment"];
    [coder encodeInt:self.max_jpg_size forKey:@"max_jpg_size"];
    [coder encodeInt:self.max_png_size forKey:@"max_png_size"];
    [coder encodeObject:self.username forKey:@"username"];
    [coder encodeObject:self.icon_url forKey:@"icon_url"];
}

- (void)dealloc
{
    NSLog(@"dealloc ModelUser");
    result_text = nil;
    username = nil;
    icon_url = nil;
}

@end
