//
//  ModelUser.h
//  ProjectLana
//
//  Created by TGM on 10/30/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelUser : NSObject {
}

@property (nonatomic) int      user_id;
@property (nonatomic) int      post_count;
@property (nonatomic) BOOL     can_pm;
@property (nonatomic) BOOL     can_send_pm;
@property (nonatomic) BOOL     can_search;
@property (nonatomic) BOOL     can_whosonline;
@property (nonatomic) int      max_attachment;
@property (nonatomic) int      max_png_size;
@property (nonatomic) int      max_jpg_size;
@property (nonatomic) BOOL     can_upload_avatar;
@property (nonatomic) BOOL     can_moderate;
@property (nonatomic,strong) NSString *result_text;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *icon_url;

- (id)initWithDictionary:(NSDictionary*)dic;

- (id)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;

@end
