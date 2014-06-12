//
//  LNRequest.m
//  ProjectLana
//
//  Created by TAPHUOCHAI on 11/1/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import "LNRequest.h"

#import "ModelTopic.h"
#import "ModelPost.h"

#import "NSData+Base64.h"
#import <CommonCrypto/CommonDigest.h>

@interface LNRequest ()

@property (nonatomic, copy) void (^_blockResponse)(XMLRPCResponse *response);
@property (nonatomic, copy) void (^_blockError)(NSError *error);
@property (nonatomic, copy) void (^_blockPercent)(float percent);

@end

@implementation LNRequest

static NSMutableArray *identifierConnection;
+ (NSMutableArray*)shareConnection{
    if (!identifierConnection) {
        identifierConnection = [[NSMutableArray alloc] init];
    }
    return identifierConnection;
}

+ (void)clearConnection {
    XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
    for (NSString *identifier in identifierConnection) {
        [manager closeConnectionForIdentifier:identifier];
    }
    identifierConnection = [[NSMutableArray alloc] init];
}

#pragma mark -

- (void)requestWithMethod:(NSString*)method
        onReceiveResponse:(void (^)(XMLRPCResponse *))response
                onPercent:(void (^)(float percent))percent fail:(void (^)(NSError*))error
{
    [self requestWithMethod:method prarameters:nil onReceiveResponse:response onPercent:percent fail:error];
}

- (void)requestWithMethod:(NSString*)method
              prarameters:(NSArray*)params
        onReceiveResponse:(void (^)(XMLRPCResponse *))response
                onPercent:(void (^)(float percent))percent fail:(void (^)(NSError*))error {
    
    self._blockResponse = response;
    self._blockError = error;
    self._blockPercent = percent;
    
    XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
    [self  setMethod:method withParameters:params];
    
    NSString *identifier = [manager spawnConnectionWithXMLRPCRequest:self delegate: self];
    
    [[LNRequest shareConnection] addObject:identifier];
}

#pragma mark - XMLRPCConnectionDelegate

- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response {
    if(self._blockResponse) self._blockResponse(response);
    [self cleanUp];
}

- (void)request: (XMLRPCRequest *)request didSendBodyData: (float)percent {
    if(self._blockPercent) self._blockPercent(percent);
}
- (void)request: (XMLRPCRequest *)request didFailWithError: (NSError *)error{
    if(self._blockError) self._blockError(error);
    [self cleanUp];
}

- (BOOL)request: (XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace: (NSURLProtectionSpace *)protectionSpace { return YES; }
- (void)request: (XMLRPCRequest *)request didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge {}
- (void)request: (XMLRPCRequest *)request didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge {}

- (void)cleanUp
{
    self._blockResponse = nil;
    self._blockPercent = nil;
    self._blockError  = nil;
}

- (void)dealloc
{
    [self cleanUp];
}

@end
