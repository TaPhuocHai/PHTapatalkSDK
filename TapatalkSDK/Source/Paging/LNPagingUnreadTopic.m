//
//  LNPagingUnreadTopic.m
//  ProjectLana
//
//  Created by Ta Phuoc Hai on 3/18/13.
//  Copyright (c) 2013 Project Lana. All rights reserved.
//

#import "LNPagingUnreadTopic.h"
#import "TapatalkAPI.h"
#import "ModelTopic.h"

@implementation LNPagingUnreadTopic

- (void)startPagingOnSuccess:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild
{
    _currentPage = 1;
    [TapatalkAPI getUnreadTopicWithStartNum:0 lastNum:(self.countPaging - 1) completionHandler:^(NSArray *arrTopic_, int totalTopicNum , NSError *error) {
        if (!error) {
            
            _data = [[NSMutableArray alloc] initWithArray:arrTopic_];
            _totalCountData = totalTopicNum;
            _startNum = 0;
            _lastNum = self.countPaging - 1;
            
            _onSuccess(arrTopic_);
        } else {
            _onFaild(error);
        }
    } onPercent:^(float percent) {
    }];    
}

- (void)loadNextPageOnSuccess:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild
{
    int nextStart = self.startNum;
    int nextLast = self.lastNum + self.countPaging;
    if (nextLast > self.totalCountData) nextLast = self.totalCountData;
    
    [TapatalkAPI getUnreadTopicWithStartNum:nextStart lastNum:nextLast completionHandler:^(NSArray *arrTopic_, int totalTopicNum , NSError *error) {
        if (!error) {
            
            for (ModelTopic *topic in arrTopic_) {
                [self.data addObject:topic];
            }
            
            _totalCountData = totalTopicNum;
            _startNum = nextStart;
            _lastNum = nextLast;
            
            _onSuccess(arrTopic_);
        } else {
            _onFaild(error);
        }
    } onPercent:^(float percent) {
    }];
}

@end
