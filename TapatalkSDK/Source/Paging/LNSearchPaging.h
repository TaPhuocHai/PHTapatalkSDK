//
//  LNPagingSearch.h
//  ProjectLana
//
//  Created by Ta Phuoc Hai on 3/15/13.
//  Copyright (c) 2013 Project Lana. All rights reserved.
//

#import "LNBasePaging.h"

@interface LNSearchPaging : LNBasePaging <LNBasePagingDelegate>

@property (nonatomic, strong) NSString * searchString;
@property (nonatomic, strong) NSString * searchId;

@end
