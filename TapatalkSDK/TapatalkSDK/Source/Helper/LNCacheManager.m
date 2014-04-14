//
//  LNCacheManager.m
//  TapatalkSDK
//
//  Created by Ta Phuoc Hai on 4/11/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "LNCacheManager.h"
#import "FMDatabase.h"

#define kNSDidCopyDatabase @"DID_COPY_DATABASE"

@interface LNCacheManager ()

@property (nonatomic, strong) FMDatabase * database;

@end

@implementation LNCacheManager

static LNCacheManager * _cacheManager;
+ (LNCacheManager*)shareInstance
{
    if (!_cacheManager) {
        _cacheManager = [[LNCacheManager alloc] init];
    }
    return _cacheManager;
}

- (id)init
{
    if (self = [super init]) {
        [self initDatabase];
    }
    return self;
}

#pragma mark - Database

- (void)initDatabase
{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *bundleDbPath = [[NSBundle mainBundle] pathForResource:@"forum" ofType:@"db" inDirectory:nil];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"forum.db"];
    
    NSUserDefaults * pref = [NSUserDefaults standardUserDefaults];
    if (![pref boolForKey:kNSDidCopyDatabase]) {
        // Copy database from bundle to isolated storage
        NSFileManager * fileManager = [[NSFileManager alloc] init];
        NSError       * error = nil;
        if (![fileManager fileExistsAtPath:dbPath]) {
            [fileManager copyItemAtPath:bundleDbPath toPath:dbPath error:&error];
        }
        
        // Copy success
        if (!error) {
            // Save did copy database
            [pref setBool:YES forKey:kNSDidCopyDatabase];
            [pref synchronize];
        }
    }
    
    // Open database
    self.database = [FMDatabase databaseWithPath:dbPath];
}

#pragma mark - 

- (void)getForumById:(int)forumId
   completionHandler:(void (^)(NSArray * childForum, NSArray * topics))_completionHandler
      failureHandler:(void (^)(NSError * error))_failureHandler
{
    if (!self.database) {
        NSLog(@"Failed open database");
        if (_failureHandler) _failureHandler(nil);
        return;
    }
    
    //
    NSString * sql = @"SELECT"
}

@end
