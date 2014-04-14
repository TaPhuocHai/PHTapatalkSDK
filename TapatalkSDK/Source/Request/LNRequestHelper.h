//
//  LNRequestHelper.h
//  ProjectLana
//
//  Created by TAPHUOCHAI on 12/24/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNRequest.h"

@interface LNRequestHelper : XMLRPCRequest <XMLRPCConnectionDelegate> {
    void (^_blockSuccess)(XMLRPCResponse *response, NSDictionary *result);
    void (^_blockFaild)(NSError* error, NSDictionary *result);
}

// Chỉ sử dụng hàm này khi dữ liệu trả về là một struct response
- (void)requestWithMethod:(NSString*)method
              prarameters:(NSArray*)params
                  success:(void (^)(XMLRPCResponse *response, NSDictionary *result))_onSuccess
                     fail:(void (^)(NSError* error, NSDictionary *result))_onFail;

@end
