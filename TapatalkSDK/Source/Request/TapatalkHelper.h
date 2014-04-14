//
//  TapatalkHelper.h
//  ProjectLana
//
//  Created by TAPHUOCHAI on 11/1/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

@interface TapatalkHelper : NSObject

+ (NSDictionary*)parseStructRespondToDictionary:(NSArray*)arr;
+ (NSString*)formatHTML:(NSString*)content;

@end
