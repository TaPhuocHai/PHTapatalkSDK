//
//  LNRequestHelper.m
//  ProjectLana
//
//  Created by TAPHUOCHAI on 12/24/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import "LNRequestHelper.h"

#import "ModelTopic.h"
#import "ModelPost.h"
#import "TapatalkHelper.h"

#import "NSString+LNTapatalkHelper.h"
#import "XML+NSData+Base64.h"
#import <CommonCrypto/CommonDigest.h>

@implementation LNRequestHelper

// Request này tự động parse data trả về
// Chỉ sử dụng hàm này khi dữ liệu trả về là một struct response
- (void)requestWithMethod:(NSString*)method prarameters:(NSArray*)params success:(void (^)(XMLRPCResponse *response, NSDictionary *result))_onSuccess fail:(void (^)(NSError* error, NSDictionary *result))_onFail
{
    _blockSuccess = _onSuccess;
    _blockFaild   = _onFail;
    
    XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
    [self  setMethod:method withParameters:params];
    
    NSString *identifier = [manager spawnConnectionWithXMLRPCRequest:self delegate: self];
    [[LNRequest shareConnection] addObject:identifier];
}


#pragma mark - XMLRPCConnectionDelegate

- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response {
    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[[response body] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding options:0 error:nil];
    
    NSArray *nodes    = [doc nodesForXPath:@"//methodResponse/params/param/value/struct/*" error:nil];
    NSDictionary *dic = [TapatalkHelper parseStructRespondToDictionary:nodes];
    
    if (![dic objectForKey:@"result_text"] || [[dic objectForKey:@"result"] intValue] == 1) {
        _blockSuccess(response, dic);
    } else {
        NSString *textError = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"result_text"]]
                                                    encoding:NSUTF8StringEncoding];
        _blockFaild([NSError errorWithDomain:@"" code:1 userInfo:@{@"error" : textError}], dic);
    }
}

- (void)request: (XMLRPCRequest *)request didSendBodyData: (float)percent { }
- (void)request: (XMLRPCRequest *)request didFailWithError: (NSError *)error{
    _blockFaild(error, nil);
}

- (BOOL)request: (XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace: (NSURLProtectionSpace *)protectionSpace { return YES; }
- (void)request: (XMLRPCRequest *)request didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge {}
- (void)request: (XMLRPCRequest *)request didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge {}

@end
