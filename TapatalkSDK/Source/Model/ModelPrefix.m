//
//  ModelPrefixe.m
//  ProjectLana
//
//  Created by Ta Phuoc Hai on 11/29/13.
//  Copyright (c) 2013 Project Lana. All rights reserved.
//

#import "ModelPrefix.h"

#import "XML+NSData+Base64.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ModelPrefix

@synthesize prefix_id = _prefix_id, prefix_display_name = _prefix_display_name;

- (id)initWithDictionary:(NSDictionary*)dic
{
    if (self = [super init]) {
        _prefix_id = [dic objectForKey:@"prefix_id"];
        _prefix_display_name       = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"prefix_display_name"]]
                                                           encoding:NSUTF8StringEncoding];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        _prefix_id = [coder decodeObjectForKey:@"_prefix_id"];
        _prefix_display_name = [coder decodeObjectForKey:@"_prefix_display_name"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_prefix_id forKey:@"_prefix_id"];
    [coder encodeObject:_prefix_display_name forKey:@"_prefix_display_name"];
}

- (void)dealloc
{
    _prefix_id = nil;
    _prefix_display_name = nil;
}

@end
