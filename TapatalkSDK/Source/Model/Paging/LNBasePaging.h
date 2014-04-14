//
//  LNBasePaging.h
//  ProjectLana
//
//  Created by TAPHUOCHAI on 12/25/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNBasePaging : NSObject {
    int _maxIndexPageLoaded;
    int _currentPage;
    int _totalCountData;
    int _totalPage;
    int _startNum;
    int _lastNum;
    NSMutableArray * _data;
    int _countPaging;
}

@property (nonatomic, readonly) int     maxIndexPageLoaded; // Số trang lớn nhất đã đc load
@property (nonatomic, readonly) int     currentPage;        // Trang hiện tại
@property (nonatomic, readonly) int     totalCountData;     // Số lượng data
@property (nonatomic, readonly) int     totalPage;          // Số trang
@property (nonatomic, readonly) int     startNum;           // Trong trang hiện tại, vị trí data bắt đầu được lấy
@property (nonatomic, readonly) int     lastNum;            // Trong trang hiện tại, vị trí data cuối cùng được lấy
@property (nonatomic, readonly) NSMutableArray * data;        // Dữ liệu

@property (nonatomic, readonly)           int     countPaging;        // Số lượng dữ liệu trong 1 trang

- (id)init;
- (id)initWithPaging:(int)paging;

- (BOOL)isNextPage;
- (void)startPagingOnSuccess:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild;
- (void)loadNextPageOnSuccess:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild;
- (void)reloadPagingOnSuccess:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild;

@end
