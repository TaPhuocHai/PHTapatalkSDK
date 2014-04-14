//
//  LNPagingSubscribe.m
//  ProjectLana
//
//  Created by Ta Phuoc Hai on 3/15/13.
//  Copyright (c) 2013 Project Lana. All rights reserved.
//

#import "LNPagingSubscribe.h"
#import "PHTapatalkSDK.h"
#import "TapatalkAPI.h"

@implementation LNPagingSubscribe

- (void)startPagingOnSuccess:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild
{
    int startLoad = 0;
    int endLoad = self.countPaging - 1;
    _currentPage = 1;
    
    [TapatalkAPI getSubscribeTopic:startLoad lastNum:endLoad completionHandler:^(NSArray *arrTopic, int totalTopicNum, NSError *error) {
        if (!error) {
            self.data = [[NSMutableArray alloc] initWithArray:arrTopic];
            _totalCountData = totalTopicNum;
            _startNum = startLoad;
            _lastNum = endLoad;
            if (_onSuccess) _onSuccess(arrTopic);
        } else {
            // login and try againt
            [LNAccountManager autoLoginOnCompletionHander:^(ModelUser *result, NSError *error2) {
                if (error2) {
                    _onFaild(error);
                } else {
                    [TapatalkAPI getSubscribeTopic:startLoad lastNum:endLoad completionHandler:^(NSArray *arrTopic2, int totalTopicNum2, NSError *error3) {
                        if (!error2) {
                            self.data = [[NSMutableArray alloc] initWithArray:arrTopic2];
                            _totalCountData = totalTopicNum2;
                            _startNum = startLoad;
                            _lastNum = endLoad;
                            if (_onSuccess) _onSuccess(arrTopic2);
                        } else {
                            if (_onFaild) _onFaild(error3);
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)loadNextPageOnSuccess:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild
{
    int start = _currentPage*self.countPaging;
    int last = (_currentPage+1)*self.countPaging - 1;
    [TapatalkAPI getSubscribeTopic:start lastNum:last completionHandler:^(NSArray *arrTopic, int totalTopicNum, NSError *error) {
        if (!error) {
            for (ModelTopic *topic in arrTopic) {
                [self.data addObject:topic];
            }
            _currentPage = _currentPage + 1;
            _startNum = start;
            _lastNum = last;
            _totalCountData = totalTopicNum;
            if (_onSuccess) _onSuccess(arrTopic);
        } else {
            if (_onFaild) _onFaild(error);
        }
    }];
}

@end
