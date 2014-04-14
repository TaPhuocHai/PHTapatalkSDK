//
//  LNPagingForum.h
//  ProjectLana
//
//  Created by Ta Phuoc Hai on 3/15/13.
//  Copyright (c) 2013 Project Lana. All rights reserved.
//

#import "LNBasePaging.h"

@class ModelForum;

@interface LNPagingForum : LNBasePaging

@property (nonatomic, strong) ModelForum *forum;

- (id)initWithForum:(ModelForum*)forum_;

@end
