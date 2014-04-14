//
//  LNPagingSearch.m
//  ProjectLana
//
//  Created by Ta Phuoc Hai on 3/15/13.
//  Copyright (c) 2013 Project Lana. All rights reserved.
//

#import "LNPagingSearch.h"
#import "TapatalkAPI.h"

@implementation LNPagingSearch

- (void)startPagingOnSuccess:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild
{
    if (self.searchString.length == 0) {
        _onFaild(nil);
        return;
    }
    _currentPage = 1;
    [TapatalkAPI searchTopic:self.searchString startNumber:0 lastNumber:(self.countPaging - 1) searchId:self.searchId completionHandler:^(NSString *searchId, NSArray *arrTopic, int totalTopicNum, NSError *error) {
        if (!error) {
            
            _data = [[NSMutableArray alloc] init];
            for (ModelTopic *topic in arrTopic) {
                [self.data addObject:topic];
            }
            
            _totalCountData = totalTopicNum;
            self.searchId = searchId;
            
            _startNum = 0;
            _lastNum = self.countPaging - 1;
            
            if(_onSuccess) _onSuccess(self.data);
        } else {
            if(_onFaild) _onFaild(error);
        }
    } onPercent:^(float percent) {
    }];
}

- (void)loadNextPageOnSuccess:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild
{
    int nextStart = self.startNum;
    int nextLast = self.lastNum + self.countPaging;
    if (nextLast > self.totalCountData) nextLast = self.totalCountData;
    
    [TapatalkAPI searchTopic:self.searchString startNumber:nextStart lastNumber:nextLast searchId:self.searchId completionHandler:^(NSString *searchId, NSArray *arrTopic, int totalTopicNum, NSError *error) {
        
        if (!error) {
            for (ModelTopic *topic in arrTopic) {
                [self.data addObject:topic];
            }
            _totalCountData = totalTopicNum;
            
            _startNum = nextStart;
            _lastNum = nextLast;
            
            if(_onSuccess) _onSuccess(arrTopic);
        } else {
            if(_onFaild) _onFaild(error);
        }
    } onPercent:^(float percent) {
    }];
}

@end
