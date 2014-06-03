//
//  PHLogTime.m
//  WebTreTho3.0
//
//  Created by Ta Phuoc Hai on 6/3/14.
//  Copyright (c) 2014 PH. All rights reserved.
//

#import "PHLogTime.h"

@implementation PHLogTime {
    NSMutableDictionary * _startTimeKey;
    bool _enableListen;
}


static PHLogTime * _shareInstance;
+ (PHLogTime*)share{
    if (!_shareInstance) {
        _shareInstance = [[PHLogTime alloc] init];
        _shareInstance->_startTimeKey = [NSMutableDictionary dictionary];
    }
    return _shareInstance;
}

+ (void)enableListen:(BOOL)enable
{
    [self share]->_enableListen = enable;
}

+ (void)startListenWithKey:(NSString*)key
{
    if (![self share]->_enableListen) {
        return;
    }
    
    NSLog(@"Start time listen : %@", key);
    [self share]->_startTimeKey[key] = @([[NSDate date] timeIntervalSince1970]);
}

+ (void)endListenWithKey:(NSString*)key
{
    if (![self share]->_enableListen) {
        return;
    }
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSLog(@"End time listen : %@ - %f", key, now - [[self share]->_startTimeKey[key] doubleValue]);
}

- (void)dealloc
{
    _startTimeKey = nil;
}

@end
