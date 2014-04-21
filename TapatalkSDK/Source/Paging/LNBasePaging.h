//
//  LNBasePaging.h
//  ProjectLana
//
//  Created by TAPHUOCHAI on 12/25/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LNBasePagingDelegate <NSObject>
@required
- (void)loadDataFrom:(NSInteger)from
                  to:(NSInteger)to
          completion:(void (^)(NSArray * data, NSInteger totalDataNumber))completeBlock
             failure:(void (^)(NSError * error))failureBlock;
@end

@interface LNBasePaging : NSObject {
}

@property (nonatomic, readonly) NSInteger     perPage;            // Số lượng dữ liệu trong 1 trang
@property (nonatomic, readonly) NSInteger     lastRequestPage;    // Trang cuối cùng gọi request
@property (nonatomic, readonly) NSInteger     totalDataNumber;    // Số lượng data
@property (nonatomic, readonly) NSInteger     totalPage;          // Số trang

@property (nonatomic, readonly) NSMutableDictionary  * dataOfPage;

@property (nonatomic, assign) id<LNBasePagingDelegate> delegate;

- (id)init;
- (id)initWithPerPage:(NSInteger)numberOfPerPage;

- (void)startRequestOnComplete:(void (^)(NSArray *arrData))completeBlock
                     onFailure:(void (^)(NSError *error))failureBlock;
- (void)loadNextPageOnComplete:(void (^)(NSArray *arrData))completeBlock
                     onFailure:(void (^)(NSError *error))failureBlock;

@end
