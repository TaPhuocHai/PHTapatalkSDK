//
//  LNRequest.h
//  ProjectLana
//
//  Created by TAPHUOCHAI on 11/1/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//
#import "TouchXML.h"
#import "XMLRPC.h"

@interface LNRequest : XMLRPCRequest <XMLRPCConnectionDelegate> {
  void (^_blockResponse)(XMLRPCResponse *response);
  void (^_blockError)(NSError *error);
  void (^_blockPercent)(float percent);
}

- (void)requestWithMethod:(NSString*)method prarameters:(NSArray*)params onReceiveResponse:(void (^)(XMLRPCResponse *))response onPercent:(void (^)(float percent))percent fail:(void (^)(NSError*))error;
- (void)requestWithMethod:(NSString*)method onReceiveResponse:(void (^)(XMLRPCResponse *))response onPercent:(void (^)(float percent))percent fail:(void (^)(NSError*))error;

#pragma mark -
+ (NSMutableArray*)shareConnection;
+ (void)clearConnection;

@end
