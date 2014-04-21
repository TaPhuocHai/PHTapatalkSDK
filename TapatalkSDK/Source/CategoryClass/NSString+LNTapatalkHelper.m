//
//  NSString+Helper.m
//  ProjectLana
//
//  Created by TAPHUOCHAI on 11/27/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import "NSString+LNTapatalkHelper.h"

@implementation NSString (LNTapatalkHelper)

/*viết hoa chữ cái đầu tiên trong câu*/
-(NSString*)uppercaseFirstCharactor {
    NSString *result = [self lowercaseString];
    result=[[[result substringToIndex:1] uppercaseString] stringByAppendingString:[result substringFromIndex:1]];
    return result;
}

/* Đảo ngược chuỗi */
- (NSString *)reverseString {
    NSUInteger stringLength = self.length;
    
    NSMutableString *reversedString = [[NSMutableString alloc] initWithCapacity:stringLength];
    while (stringLength) {
        [reversedString appendFormat:@"%C", [self characterAtIndex:--stringLength]];
    }
    return reversedString;
}

/* Cắt chuỗi */
- (NSString*)getWordInFirstCharactor:(int)len
{    
    if (self.length <= len) {
        return self;
    }
    
    NSRange range;
    range.location = 0;
    range.length = len;
    
    NSString *cutString = [self substringWithRange:range];
    
    NSString *reverseString = [cutString reverseString];

    // Tìm ra khoảng trắng đầu tiên
    NSRange rgWhiteCharactor = [reverseString rangeOfString:@" "];
    rgWhiteCharactor.length = rgWhiteCharactor.location + 1;
    rgWhiteCharactor.location = 0;
    
    // Remove nó
    if (rgWhiteCharactor.length > self.length || rgWhiteCharactor.location > self.length) {
        return self;
    }
    NSString *result = [reverseString stringByReplacingCharactersInRange:rgWhiteCharactor withString:@""];
    result = [result reverseString];
    result = [result stringByAppendingString:@" ..."];
    return result;
}
@end
