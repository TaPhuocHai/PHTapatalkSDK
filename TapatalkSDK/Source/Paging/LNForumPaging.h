//
//  LNPagingForum.h
//  ProjectLana
//
//  Created by Ta Phuoc Hai on 3/15/13.
//  Copyright (c) 2013 Project Lana. All rights reserved.
//

#import "LNBasePaging.h"

@class ModelForum;

@interface LNForumPaging : LNBasePaging <LNBasePagingDelegate>

@property (nonatomic, readonly) ModelForum * forum;

- (id)initWithForum:(ModelForum*)forum;
- (id)initWithForum:(ModelForum*)forum perPage:(NSInteger)numberOfPerPage;

@end
