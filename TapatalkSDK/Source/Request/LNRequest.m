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
    
    _blockResponse = response;
    _blockError = error;
    _blockPercent = percent;
    
    XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
    [self  setMethod:method withParameters:params];
    
    NSString *identifier = [manager spawnConnectionWithXMLRPCRequest:self delegate: self];
    [[LNRequest shareConnection] addObject:identifier];
}

#pragma mark - XMLRPCConnectionDelegate

- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response {
    if(_blockResponse) _blockResponse(response);
}

- (void)request: (XMLRPCRequest *)request didSendBodyData: (float)percent {
    if(_blockPercent) _blockPercent(percent);
}
- (void)request: (XMLRPCRequest *)request didFailWithError: (NSError *)error{
    if(_blockError) _blockError(error);
}

- (BOOL)request: (XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace: (NSURLProtectionSpace *)protectionSpace { return YES; }
- (void)request: (XMLRPCRequest *)request didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge {}
- (void)request: (XMLRPCRequest *)request didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge {}

@end
