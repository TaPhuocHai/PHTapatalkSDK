//
//  NSString+Helper.h
//  ProjectLana
//
//  Created by TAPHUOCHAI on 11/27/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LNTapatalkHelper)

/*viết hoa chữ cái đầu tiên trong câu*/
- (NSString*)uppercaseFirstCharactor;

/* Đảo ngược chuỗi */
- (NSString*)reverseString;

/* Cắt chuỗi */
- (NSString*)getWordInFirstCharactor:(int)len;

@end
