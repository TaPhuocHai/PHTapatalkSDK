//
//  ModelPrefixe.h
//  ProjectLana
//
//  Created by Ta Phuoc Hai on 11/29/13.
//  Copyright (c) 2013 Project Lana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelPrefix : NSObject

@property (nonatomic, strong) NSString * prefix_id;
@property (nonatomic, strong) NSString * prefix_display_name;

- (id)initWithDictionary:(NSDictionary*)dic;
- (id)copyWithZone:(NSZone *)zone;

@end
