//
//  ModelPrefixe.m
//  ProjectLana
//
//  Created by Ta Phuoc Hai on 11/29/13.
//  Copyright (c) 2013 Project Lana. All rights reserved.
//

#import "ModelPrefix.h"

#import "NSData+Base64.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ModelPrefix

- (id)initWithDictionary:(NSDictionary*)dic
{
    if (self = [super init]) {
        self.prefix_id = [dic objectForKey:@"prefix_id"];
        self.prefix_display_name       = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"prefix_display_name"]]
                                                               encoding:NSUTF8StringEncoding];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ModelPrefix * another = [[ModelPrefix alloc] init];
    another.prefix_id = self.prefix_id;
    another.prefix_display_name = self.prefix_display_name;
    return another;
}

@end
