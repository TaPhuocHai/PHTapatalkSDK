//
//  ModelPrefixe.h
//  ProjectLana
//
//  Created by Ta Phuoc Hai on 11/29/13.
//  Copyright (c) 2013 Project Lana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelPrefix : NSObject {
    NSString * _prefix_id;
    NSString * _prefix_display_name;
}

@property (nonatomic, readonly) NSString * prefix_id;
@property (nonatomic, readonly) NSString * prefix_display_name;

- (id)initWithDictionary:(NSDictionary*)dic;

@end
