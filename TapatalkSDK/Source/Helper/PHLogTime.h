//
//  PHLogTime.h
//  WebTreTho3.0
//
//  Created by Ta Phuoc Hai on 6/3/14.
//  Copyright (c) 2014 PH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHLogTime : NSObject

+ (void)enableListen:(BOOL)enable;

+ (void)startListenWithKey:(NSString*)key;
+ (void)endListenWithKey:(NSString*)key;

@end
