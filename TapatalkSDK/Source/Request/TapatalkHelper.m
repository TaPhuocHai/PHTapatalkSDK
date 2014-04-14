//
//  TapatalkHelper.m
//  ProjectLana
//
//  Created by TAPHUOCHAI on 11/1/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import "TapatalkHelper.h"
#import "TouchXML.h"

#import "ModelForum.h"
#import "ModelTopic.h"
#import "ModelPost.h"
#import "ModelPrefix.h"

@implementation TapatalkHelper

+ (NSDictionary*)parseStructRespondToDictionary:(NSArray*)arr
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    for (CXMLElement * node in arr) {
        CXMLNode * valueNode = [node nodeForXPath:@"./value/*" error:nil];
        NSString * memberName = [[node childAtIndex:0] stringValue];
        
        // For get_forum
        if ([memberName isEqualToString:@"child"])
        {
            NSArray *arrChildNodes = [valueNode nodesForXPath:@"./data/*" error:nil];
            NSMutableArray *childForm = [[NSMutableArray alloc] init];
            for (CXMLElement *childNode in arrChildNodes) {
                NSArray *arrValueNode = [childNode  nodesForXPath:@"./struct/*" error:nil];
                NSDictionary *dicForum = [TapatalkHelper parseStructRespondToDictionary:arrValueNode];
                ModelForum *forum = [[ModelForum alloc] initWithDictionary:dicForum];
                [childForm addObject:forum];
            }
            [result setObject:childForm forKey:[[node childAtIndex:0] stringValue]];
            continue;
        }
        
        // For get_topic
        if ([memberName isEqualToString:@"topics"])
        {
            NSArray * arrChildNodes    = [valueNode nodesForXPath:@"./data/*" error:nil];
            NSMutableArray * childForm = [[NSMutableArray alloc] init];
            for (CXMLElement * childNode in arrChildNodes) {
                NSArray      * arrValueNode  = [childNode  nodesForXPath:@"./struct/*" error:nil];
                NSDictionary * dicForum      = [TapatalkHelper parseStructRespondToDictionary:arrValueNode];
                ModelTopic   * topic         = [[ModelTopic alloc] initWithDictionary:dicForum];
                [childForm addObject:topic];
            }
            [result setObject:childForm forKey:[[node childAtIndex:0] stringValue]];
            continue;
        }
        
        // for get_topic
        // xử lý prefix data
        if ([memberName isEqualToString:@"prefixes"]) {
            NSArray * arrChildNodes    = [valueNode nodesForXPath:@"./data/*" error:nil];
            NSMutableArray * arrPrefixes = [[NSMutableArray alloc] init];
            for (CXMLElement *childNode in arrChildNodes) {
                NSArray * arrValueNode  = [childNode  nodesForXPath:@"./struct/*" error:nil];
                NSDictionary * dicPrefix = [TapatalkHelper parseStructRespondToDictionary:arrValueNode];
                ModelPrefix  * prefix   = [[ModelPrefix alloc] initWithDictionary:dicPrefix];
                [arrPrefixes addObject:prefix];
            }
            [result setObject:arrPrefixes forKey:[[node childAtIndex:0] stringValue]];
            continue;
        }
        
        // For get_thread
        if ([memberName isEqualToString:@"posts"])
        {            
            NSArray *arrChildNodes = [valueNode nodesForXPath:@"./data/*" error:nil];
            NSMutableArray *childForm = [[NSMutableArray alloc] init];
            for (CXMLElement *childNode in arrChildNodes) {
                NSArray *arrValueNode = [childNode  nodesForXPath:@"./struct/*" error:nil];
                NSDictionary *dicForum = [TapatalkHelper parseStructRespondToDictionary:arrValueNode];
                ModelPost *post = [[ModelPost alloc] initWithDictionary:dicForum];
                [childForm addObject:post];
            }
            [result setObject:childForm forKey:[[node childAtIndex:0] stringValue]];
            continue;
        }
        
        [result setObject:[valueNode stringValue] forKey:[[node childAtIndex:0] stringValue]];
    }
    return result;
}

+ (NSString*)formatHTML:(NSString*)content
{
    NSString *result = content;
    
    result = [self find:@"color" replace:@"something" onText:result];
    result = [self find:@"#cccccc" replace:@"" onText:result];
    
    if (content) {
        result = [self findAndReplaceHTMLKey:@"[IMG]" andKey:@"[/IMG]" onText:result];
        result = [self findAndReplaceHTMLKey:@"[img]" andKey:@"[/img]" onText:result];
        
        result = [self findAndReplaceHTMLKey:@"[QUOTE]" andKey:@"[/QUOTE]" onText:result];
        result = [self findAndReplaceHTMLKey:@"[quote]" andKey:@"[/quote]" onText:result];
        
        result = [self findAndReplaceHTMLKey:@"[URL]" andKey:@"[/URL]" onText:result];
        result = [self findAndReplaceHTMLKey:@"[url]" andKey:@"[/url]" onText:result];
        
        // Thẻ [URL="value"][URL]
        result = [self findAndReplaceHTMLKey:@"[URL=&quot;" middleKey:@"&quot;]" andKey:@"[/URL]" onText:result];
        result = [self findAndReplaceHTMLKey:@"[url=&quot;" middleKey:@"&quot;]" andKey:@"[/url]" onText:result];
        
        // progress link youtube
        result = [self linkYoutubeProgress:result];
        
        // Thẻ [URL=value][URL]
        result = [self findAndReplaceHTMLKey:@"[URL=" middleKey:@"]" andKey:@"[/URL]" onText:result];
        result = [self findAndReplaceHTMLKey:@"[url=" middleKey:@"]" andKey:@"[/url]" onText:result];
        
        result = [self findAndReplaceHTMLKey:@"[TD=&quot;" middleKey:@"&quot;]" andKey:@"[/TD]" onText:result];
        result = [self findAndReplaceHTMLKey:@"[td=&quot;" middleKey:@"&quot;]" andKey:@"[/td]" onText:result];
    }
    
    result = [self find:@"[h=1]" replace:@"" onText:result];
    result = [self find:@"[h=2]" replace:@"" onText:result];
    result = [self find:@"[h=3]" replace:@"" onText:result];
    result = [self find:@"[h=4]" replace:@"" onText:result];
    result = [self find:@"[h=5]" replace:@"" onText:result];
    result = [self find:@"[h=6]" replace:@"" onText:result];
    result = [self find:@"[/h]" replace:@"" onText:result];
    
    result = [self find:@"<font" replace:@"<my" onText:result];
    result = [self find:@"</font>" replace:@"</my>" onText:result];
    result = [self find:@"</b>" replace:@"" onText:result];
    result = [self find:@"</B>" replace:@"" onText:result];
    result = [self find:@"<b>" replace:@"" onText:result];
    result = [self find:@"<B>" replace:@"" onText:result];
    
    result = [self find:@"something:" replace:@"" onText:result];
    result = [self find:@"[/QUOTE]" replace:@"" onText:result];
    
    if (result == nil)
    {
        result = @"Dữ liệu lỗi";
    }
    NSString *text = [[NSString stringWithFormat:@"<div style=\"color:#000000;\" >"] stringByAppendingString:result];//font-style:Light//58595b
    
    text = [text stringByAppendingString:@"</div>"];
//   NSLog(@"content = %@", text);
    return text;
}

#pragma mark - 

static NSDictionary *_htmlDataKey;
static NSDictionary *_htmlDataKeyMiddle;

// Chỉ áp dụng cho các dạng [KEY]content[/KEY]
+ (NSString*)findAndReplaceHTMLKey:(NSString*)startKey
                            andKey:(NSString*)endKey
                            onText:(NSString*)content
{
    
    if (startKey == nil || endKey == nil) {
        return content;
    }
    
    if (_htmlDataKey == nil) {
        _htmlDataKey = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"<img src='", @"[IMG]",
                        @"<img src='", @"[img]",
                        @"' width=300 >", @"[/IMG]",
                        @"' width=300 >", @"[/img]",
                        @"< href='", @"[URL]",
                        @"< href='", @"[url]",
                        @"'></a>", @"[/URL]",
                        @"'></a>", @"[/url]",
                        [NSString stringWithFormat:@"<div style=\"padding:0 0 0 15; color:#777777;font-style:italic; font-size:16px;\">"], @"[QUOTE]",
                        @"</div>", @"[/QUOTE]",
                        [NSString stringWithFormat:@"<div style=\"padding:0 0 0 15; color:#777777;font-style:italic; font-size:16px;\">"], @"[quote]",
                        @"</div>", @"[/quote]",
                     nil];
    }
    
    NSString *result = content;
    NSRange rgStartKey = [result rangeOfString:startKey];
    while (rgStartKey.length != 0) {
        if ([_htmlDataKey objectForKey:startKey]) {
            result = [result stringByReplacingCharactersInRange:rgStartKey withString:[_htmlDataKey objectForKey:startKey]];
        }
        
        NSRange rgEndKey = [result rangeOfString:endKey];
        if (rgEndKey.location == NSNotFound) {
            rgEndKey = [[result lowercaseString] rangeOfString:endKey];
        }
        if (rgEndKey.location == NSNotFound) {
            rgEndKey = [[result uppercaseString] rangeOfString:endKey];
        }
        if (rgStartKey.location > rgEndKey.location || rgEndKey.location > content.length || rgEndKey.length > content.length) {
            break;
        }
        if([_htmlDataKey objectForKey:endKey]) {
            result = [result stringByReplacingCharactersInRange:rgEndKey withString:[_htmlDataKey objectForKey:endKey]];
        }
        
        rgStartKey = [result rangeOfString:startKey];
    }
    return result;
}

// Áp dụng cho các dạng [KEY='value']content[/KEY]
+ (NSString*)findAndReplaceHTMLKey:(NSString*)startKey
                         middleKey:(NSString*)middleKey
                            andKey:(NSString*)endKey
                            onText:(NSString*)content
{
    
    if (startKey == nil || middleKey == nil || endKey == nil) {
        return content;
    }
    
    if (_htmlDataKeyMiddle == nil) {
        _htmlDataKeyMiddle = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"<a href='%@'>", @"[URL=&quot;",
                              @"<a href='%@'>", @"[URL=",
                              @"<a href='%@'>", @"[url=&quot;",
                              @"<a href='%@'>", @"[url=",
                              @"</a>", @"[/URL]",
                              @"</a>", @"[/url]",
                              @"", @"[TD=&quot;",
                              @"", @"[td=&quot;",
                              @"", @"[/TD]",
                              @"", @"[/td]",
                              nil];
    }
    
    NSString *result = content;
    NSRange rgStartKey = [result rangeOfString:startKey];
    while (rgStartKey.length != 0) {
        NSRange rg2StartKey = [result rangeOfString:middleKey];
        
        // get link string
        NSRange rangeLink;
        rangeLink.location = rgStartKey.location + rgStartKey.length;
        rangeLink.length = rg2StartKey.location - (rgStartKey.location + rgStartKey.length);
        
        if (rangeLink.length <= 0 || rangeLink.length > result.length) {
            return result;
        }
        NSString *linkString = [result substringWithRange:rangeLink];
        
        NSRange rangeToRemove;
        rangeToRemove.location = rgStartKey.location;
        if (rgStartKey.location > rg2StartKey.location) {
            break;
        }
        rangeToRemove.length = rg2StartKey.location - rgStartKey.location + middleKey.length;
        if ([_htmlDataKeyMiddle objectForKey:startKey]) {
            result = [result stringByReplacingCharactersInRange:rangeToRemove withString:[NSString stringWithFormat:[_htmlDataKeyMiddle objectForKey:startKey],linkString]];
        }
        
        //
        NSRange rgEndKey = [result rangeOfString:endKey];
        if (rgEndKey.location == NSNotFound) {
            rgEndKey = [[result lowercaseString] rangeOfString:endKey];
        }
        if (rgEndKey.location == NSNotFound) {
            rgEndKey = [[result uppercaseString] rangeOfString:endKey];
        }
        if (rgStartKey.location > rgEndKey.location || rgEndKey.location > content.length || rgEndKey.length > content.length) {
            break;
        }
        if ([_htmlDataKeyMiddle objectForKey:endKey]) {
            result = [result stringByReplacingCharactersInRange:rgEndKey withString:[_htmlDataKeyMiddle objectForKey:endKey]];
        }
        
        rgStartKey = [result rangeOfString:startKey];
    }
    return result;
}

// Áp dụng cho các dạng [KEY='value']content[/KEY]
+ (NSString*)findAndReplaceHTMLKey:(NSString*)startKey
                         middleKey:(NSString*)middleKey
                            andKey:(NSString*)endKey
                       replaceText:(NSString*)startText
                           andText:(NSString*)endText
                            onText:(NSString*)content
{
    NSString *result   = content;
    NSRange rgStartKey = [result rangeOfString:startKey];
    while (rgStartKey.length != 0) {
        NSRange rg2StartKey = [result rangeOfString:middleKey];
        
        // get link string
        NSRange rangeLink;
        rangeLink.location = rgStartKey.location + rgStartKey.length;
        rangeLink.length   = rg2StartKey.location - (rgStartKey.location + rgStartKey.length);
        
        if (rangeLink.length <= 0 || rangeLink.length > result.length) {
            return result;
        }
        NSString * linkString = [result substringWithRange:rangeLink];
        
        NSRange rangeToRemove;
        rangeToRemove.location = rgStartKey.location;
        if (rgStartKey.location > rg2StartKey.location) {
            break;
        }
        rangeToRemove.length = rg2StartKey.location - rgStartKey.location + middleKey.length;
        result = [result stringByReplacingCharactersInRange:rangeToRemove withString:[NSString stringWithFormat:startText,linkString]];
        
        //
        NSRange rgEndKey = [result rangeOfString:endKey];
        if (rgEndKey.location == NSNotFound) {
            rgEndKey = [[result lowercaseString] rangeOfString:endKey];
        }
        if (rgEndKey.location == NSNotFound) {
            rgEndKey = [[result uppercaseString] rangeOfString:endKey];
        }
        if (rgStartKey.location > rgEndKey.location || rgEndKey.location > content.length || rgEndKey.length > content.length) {
            break;
        }
        result = [result stringByReplacingCharactersInRange:rgEndKey withString:endText];
        
        rgStartKey = [result rangeOfString:startKey];
    }
    return result;
}

+ (NSString*)linkYoutubeProgress:(NSString*)content
{
    NSString * result = content;
    // thẻ [URL=http://www.youtube.com?watch?][URL]
    NSArray * searchData = @[@"[URL=http://www.youtube.com/watch?v=",
                             @"[url=http://www.youtube.com/watch?v=",
                             @"[URL=https://www.youtube.com/watch?v=",
                             @"[url=https://www.youtube.com/watch?v="];
    
    NSString * middleKey = @"]";
    NSString * endKey    = @"[/URL]";
    
    NSString * startTextToReplace = @"<iframe title='YouTube video player' class='youtube-player' type='text/html' width='640' height='480' src='https://www.youtube.com/embed/%@?color1=d6d6d6&amp;color2=f0f0f0&amp;border=0&amp;fs=1&amp;hl=en&amp;loop=0&amp;showinfo=0&amp;iv_load_policy=3&amp;showsearch=0&amp;rel=1&amp;hd=1' frameborder='0' allowfullscreen></iframe>";
    
    for (NSString * searchKey in searchData) {
        NSRange rgStartKey = [result rangeOfString:searchKey];
        while (rgStartKey.length != 0) {
            NSRange rg2StartKey = [result rangeOfString:middleKey];
            
            // get link string
            NSRange rangeLink;
            rangeLink.location = rgStartKey.location + rgStartKey.length;
            rangeLink.length   = rg2StartKey.location - (rgStartKey.location + rgStartKey.length);
            
            if (rangeLink.length <= 0 || rangeLink.length > result.length) {
                break;
            }
            NSString * linkString = [result substringWithRange:rangeLink];
            
            NSRange rangeToRemove;
            rangeToRemove.location = rgStartKey.location;
            if (rgStartKey.location > rg2StartKey.location) {
                break;
            }
            rangeToRemove.length = rg2StartKey.location - rgStartKey.location + middleKey.length;
            result = [result stringByReplacingCharactersInRange:rangeToRemove withString:[NSString stringWithFormat:startTextToReplace,linkString]];
            
            //
            NSRange rgEndKey = [result rangeOfString:endKey];
            if (rgEndKey.location == NSNotFound) {
                rgEndKey = [[result lowercaseString] rangeOfString:endKey];
            }
            if (rgEndKey.location == NSNotFound) {
                rgEndKey = [[result uppercaseString] rangeOfString:endKey];
            }
            if (rgStartKey.location > rgEndKey.location || rgEndKey.location > result.length || rgEndKey.length > result.length) {
                break;
            }
            result = [result stringByReplacingCharactersInRange:rgEndKey withString:@""];
            
            rgStartKey = [result rangeOfString:searchKey];
        }
    }
    return result;
}

+ (NSString*)find:(NSString*)find
          replace:(NSString*)replace
           onText:(NSString*)text
{
    NSString *result = text;
    NSRange keyRange = [result rangeOfString:find];
    while (keyRange.length != 0) {
        result = [result stringByReplacingCharactersInRange:keyRange withString:replace];
        keyRange = [result rangeOfString:find];
    }
    return result;
}

@end
