//
//  TapatalkAPI.m
//  ProjectLana
//
//  Created by Ta Phuoc Hai on 3/15/13.
//  Copyright (c) 2013 Project Lana. All rights reserved.
//

#import "TapatalkAPI.h"
#import "LNRequest.h"
#import "LNRequestHelper.h"
#import "TapatalkHelper.h"
#import "LNTapatalkSDK.h"

#import "NSData+Base64.h"
#import <CommonCrypto/CommonDigest.h>

@implementation TapatalkAPI

static NSString * _kForumUrl;
static NSString * _kForumUrlTaptalk;
static NSURL    * _kNSURLServer;
static NSURL    * _kNSURLServerTapatalk;
static NSURL    * _kNSURLServerTapatalkUpload;

+ (void)shareInstanceWithUrl:(NSString*)forumUrl
{
    _kForumUrl               = forumUrl;
    _kForumUrlTaptalk        = [NSString stringWithFormat:@"%@/mobiquo/mobiquo.php", _kForumUrl];
    
    _kNSURLServer                = [NSURL URLWithString:_kForumUrl];
    _kNSURLServerTapatalk        = [NSURL URLWithString:_kForumUrlTaptalk];
    _kNSURLServerTapatalkUpload  = [NSURL URLWithString:[NSString stringWithFormat:@"%@/mobiquo/upload.php",_kForumUrl]];
}

#pragma mark - Login

+ (void)loginWithUsername:(NSData*)username
                 password:(NSData*)password
        completionHandler:(void (^)(ModelUser* result, NSError *error))_completionHander
{
    NSArray *params = [NSArray arrayWithObjects:username, password , @NO, @"1" ,  nil];
    
    LNRequestHelper *request = [[LNRequestHelper alloc] initWithURL:_kNSURLServerTapatalk];
    [request requestWithMethod:@"login" prarameters:params success:^(XMLRPCResponse *response, NSDictionary *result)
    {
        ModelUser *user = [[ModelUser alloc] initWithDictionary:result];
        if(_completionHander) _completionHander(user,nil);
    } fail:^(NSError *error, NSDictionary *result) {
        if(_completionHander) _completionHander(nil,error);
    }];
}

#pragma mark - Forum

/* Hiện tại chỉ gọi function này 1 lần duy nhất với tham số _forum_id = nil để lấy cấu trúc thư mục forum */
+ (void)getForum:(NSString*)_forum_id returnDescription:(BOOL)returnDescription completionHandler:(void (^)(ModelForum *result))_completionHandler failureHandler:(void (^)(NSError *error))_failureHandler
{
    // login befor get data
    [LNAccountManager autoLoginOnCompletionHander:^(ModelUser *result, NSError *error)
    {
        NSMutableArray *params = [[NSMutableArray alloc] init];
        if (_forum_id) {
            [params addObject:[NSNumber numberWithBool:returnDescription]];
            [params addObject:_forum_id];
        }
        
        LNRequest *request = [[LNRequest alloc] initWithURL:_kNSURLServerTapatalk];
        [request requestWithMethod:@"get_forum" prarameters:params onReceiveResponse:^(XMLRPCResponse *response)
        {
            CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[[response body]
                                                                    dataUsingEncoding:NSUTF8StringEncoding]
                                                          encoding:NSUTF8StringEncoding
                                                           options:0
                                                             error:nil];
            
            // Parse XML
            NSArray * nodes = [doc nodesForXPath:@"//methodResponse/params/param/value/array/data/*"
                                           error:nil];
            
            NSMutableArray *result = [[NSMutableArray alloc] init];
            for (CXMLElement * node in nodes) {
                NSArray * arrValueNode  = [node  nodesForXPath:@"./struct/*" error:nil];
                NSDictionary * dicForum = [TapatalkHelper parseStructRespondToDictionary:arrValueNode];
                ModelForum   * forum    = [[ModelForum alloc] initWithDictionary:dicForum];
                [result addObject:forum];
            }
            
            ModelForum * requestForum;
            if (_forum_id) {
                // Get sub-forum from _form (big forum)
                if ([LNTapatalkSDK rootForum]) {
                    requestForum = [[LNTapatalkSDK rootForum] findSubForumWithId:_forum_id];
                }
                
                if (!requestForum) {
                    requestForum = [[ModelForum alloc] initWithId:_forum_id name:nil logo:nil description:nil];
                }
                
                // Return complete
                if(_completionHandler) _completionHandler(requestForum);
            } else {
                requestForum = [[ModelForum alloc] initWithId:nil name:@"FORUM" logo:nil description:nil];
                requestForum.child = result;
                if(_completionHandler) _completionHandler(requestForum);
            }
            //[self printForum:result];
        }onPercent:^(float percent) {
        }fail:^(NSError *error){
            if(_failureHandler) _failureHandler(error);
        }];
    }];
}

+ (void)getTopicWithForum:(NSString*)forumId
                     mode:(NSString*)mode
                 startNum:(int)startNum
                  lastNum:(int)lastNum
        completionHandler:(void (^)(ModelForum *result, NSError *error))_completionHander
                onPercent:(void (^)(float percent))_percent
{
    
    if (forumId == nil || [forumId isEqualToString:@""]) {
        if(_completionHander) _completionHander(nil,[NSError errorWithDomain:_kForumUrl
                                                                        code:1
                                                                    userInfo:@{@"error" : @"Forum Id không được rỗng"}]);
        return;
    }
    
    NSMutableArray *params = [[NSMutableArray alloc] init];
    [params addObject:forumId];
    [params addObject:[NSNumber numberWithInt:startNum]];
    [params addObject:[NSNumber numberWithInt:lastNum]];
    if (mode == nil) {
        mode = @"";
    }
    [params addObject:mode];
    
    LNRequest *request = [[LNRequest alloc] initWithURL:_kNSURLServerTapatalk];
    [request requestWithMethod:@"get_topic" prarameters:params onReceiveResponse:^(XMLRPCResponse *response)
    {
        ModelForum *forum = [[ModelForum alloc] init];
        forum.forum_id = forumId;
        
        CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[[response body] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding options:0 error:nil];
        
        NSArray      * nodes    = [doc nodesForXPath:@"//methodResponse/params/param/value/struct/*" error:nil];
        NSDictionary * dic      = [TapatalkHelper parseStructRespondToDictionary:nodes];
        // fill dữ liệu
        forum.can_post              = [[dic objectForKey:@"can_post"] boolValue];
        forum.total_topic_num       = [[dic objectForKey:@"total_topic_num"] intValue];
        forum.unread_sticky_cout    = [[dic objectForKey:@"unread_sticky_cout"] intValue];
        forum.unread_announce_count = [[dic objectForKey:@"unread_announce_count"] intValue];
        forum.topics                = [dic objectForKey:@"topics"];
        forum.require_prefix        = [[dic objectForKey:@"require_prefix"] boolValue];
        if ([dic objectForKey:@"topics"]) {
            forum.prefix_id         = [dic objectForKey:@"prefix_id"];
        }
        if ([dic objectForKey:@"prefix_display_name"]) {
            forum.prefix_display_name = [dic objectForKey:@"prefix_display_name"];
        }
        if ([dic objectForKey:@"prefixes"]) {
            forum.prefixes            = [dic objectForKey:@"prefixes"];
        }
        
        
        if(_completionHander) _completionHander(forum, nil);
        
    }onPercent:^(float percent) {
        if(_percent) _percent(percent);
    }fail:^(NSError *error){
        if(_completionHander) _completionHander(nil,error);
    }];
}

+ (void)getUnreadTopicWithStartNum:(int)start_num
                           lastNum:(int)last_num
                 completionHandler:(void (^)(NSArray *arrTopic, int totalTopicNum , NSError *error))_completionHander
                         onPercent:(void (^)(float percent))_percent
{
    NSMutableArray *params = [[NSMutableArray alloc] init];
    [params addObject:[NSNumber numberWithInt:start_num]];
    [params addObject:[NSNumber numberWithInt:last_num]];
    
    LNRequest *request = [[LNRequest alloc] initWithURL:_kNSURLServerTapatalk];
    [request requestWithMethod:@"get_unread_topic" prarameters:params onReceiveResponse:^(XMLRPCResponse *response) {
        
        //NSLog(@"content = %@", [response body]);
        CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[[response body] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding options:0 error:nil];
        
        // Parse XML
        NSArray *nodes    = [doc nodesForXPath:@"//methodResponse/params/param/value/struct/*" error:nil];
        NSDictionary *dic = [TapatalkHelper parseStructRespondToDictionary:nodes];
        
        if (![dic objectForKey:@"result_text"]) {
            if(_completionHander) _completionHander([dic objectForKey:@"topics"],[[dic objectForKey:@"total_unread_num"] intValue],nil);
        } else {
            NSString *textError = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"result_text"]]
                                                        encoding:NSUTF8StringEncoding];
            if(_completionHander) _completionHander(nil,0,[NSError errorWithDomain:_kForumUrl code:1 userInfo:@{@"error" : textError}]);
        }
        
    }onPercent:^(float percent) {
        if(_percent) _percent(percent);
    }fail:^(NSError *error){
        if(_completionHander) _completionHander(nil,0,error);
    }];
}

+ (void)newTopicWithForumId:(NSString*)forum_id
                    subject:(NSString*)subject
                       body:(NSString*)body
                     prefix:(ModelPrefix*)prefix
                    success:(void (^)(NSString* topic_id))_onSuccess
                      faild:(void (^)(NSError *error))_onFaild
{    
    NSMutableArray *params = [[NSMutableArray alloc] init];
    [params addObject:forum_id];
    NSData  *subjectData = [subject dataUsingEncoding:NSUTF8StringEncoding];
    [params addObject:[NSData dataFromBase64String:[subjectData base64EncodedString]]];
    NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    [params addObject:[NSData dataFromBase64String:[bodyData base64EncodedString]]];
    if (prefix) {
        [params addObject:prefix.prefix_id];
    } else {
        [params addObject:@""];             // prefix_id
    }
    [params addObject:[NSArray array]]; // attachment_id_array
    [params addObject:@""];             // groupd_id
    
    LNRequestHelper *request = [[LNRequestHelper alloc] initWithURL:_kNSURLServerTapatalk];
    [request requestWithMethod:@"new_topic" prarameters:params success:^(XMLRPCResponse *response, NSDictionary *result) {
        _onSuccess([result objectForKey:@"topic_id"]);
    } fail:^(NSError *error, NSDictionary *result) {
        [LNAccountManager autoLoginOnCompletionHander:^(ModelUser *result2, NSError *error2) {
            if (error2) {
                _onFaild(error);
            } else {
                LNRequestHelper *request = [[LNRequestHelper alloc] initWithURL:_kNSURLServerTapatalk];
                [request requestWithMethod:@"new_topic" prarameters:params success:^(XMLRPCResponse *response3, NSDictionary *result3) {
                    _onSuccess([result3 objectForKey:@"topic_id"]);
                } fail:^(NSError *error, NSDictionary *result) {
                    _onFaild(error);
                }];
            }
        }];
    }];
}

#pragma mark - Topic

+ (void)getThreadWithTopic:(NSString*)topic_id returnHTML:(BOOL)return_html startNum:(int)_startNum lastNum:(int)_lastNum completionHandler:(void (^)(ModelTopic *result, NSError *error))_completionHander onPercent:(void (^)(float percent))_percent {
    if (topic_id == nil || [topic_id isEqualToString:@""]) {
        if(_completionHander) _completionHander(nil,[NSError errorWithDomain:_kForumUrl code:1 userInfo:@{@"error" : @"Topic Id không được rỗng"}]);
        return;
    }
    
    NSMutableArray *params = [[NSMutableArray alloc] init];
    [params addObject:topic_id];
    [params addObject:[NSNumber numberWithInt:_startNum]];
    [params addObject:[NSNumber numberWithInt:_lastNum]];
    [params addObject:[NSNumber numberWithBool:return_html]];
    
    LNRequest *request = [[LNRequest alloc] initWithURL:_kNSURLServerTapatalk];
    [request requestWithMethod:@"get_thread" prarameters:params onReceiveResponse:^(XMLRPCResponse *response) {
        
        CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[[response body] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding options:0 error:nil];
        
        NSArray *nodes    = [doc nodesForXPath:@"//methodResponse/params/param/value/struct/*" error:nil];
        NSDictionary *dic = [TapatalkHelper parseStructRespondToDictionary:nodes];
        
        if (![dic objectForKey:@"result_text"]) {
            // fill dữ liệu
            ModelTopic *result = [[ModelTopic alloc] initWithDictionary:dic];
            if(_completionHander) _completionHander(result,nil);
        } else {
            NSString *textError = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"result_text"]]
                                                        encoding:NSUTF8StringEncoding];
            if(_completionHander) _completionHander(nil,[NSError errorWithDomain:_kForumUrl code:1 userInfo:@{@"error" : textError}]);
        }
        
    }onPercent:^(float percent) {
        if(_percent) _percent(percent);
    }fail:^(NSError *error){
        if(_completionHander) _completionHander(nil,error);
    }];
}

+ (void)getThreadUnread:(NSString*)topic_id returnHTML:(BOOL)return_html postsPerRequest:(int)posts_per_request completionHandler:(void (^)(ModelTopic *result,int position, NSError *error))_completionHander{
    if (topic_id == nil || [topic_id isEqualToString:@""]) {
        if(_completionHander) _completionHander(nil,-1,[NSError errorWithDomain:_kForumUrl code:1 userInfo:@{@"error" : @"Topic Id không được rỗng"}]);
        return;
    }
    
    NSMutableArray *params = [[NSMutableArray alloc] init];
    [params addObject:topic_id];
    [params addObject:[NSNumber numberWithInt:posts_per_request]];
    [params addObject:[NSNumber numberWithBool:return_html]];
    
    LNRequest *request = [[LNRequest alloc] initWithURL:_kNSURLServerTapatalk];
    [request requestWithMethod:@"get_thread_by_unread" prarameters:params onReceiveResponse:^(XMLRPCResponse *response) {
        
        CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[[response body] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding options:0 error:nil];
        
        NSArray *nodes    = [doc nodesForXPath:@"//methodResponse/params/param/value/struct/*" error:nil];
        NSDictionary *dic = [TapatalkHelper parseStructRespondToDictionary:nodes];
        
        if (![dic objectForKey:@"result_text"]) {
            // fill dữ liệu
            ModelTopic *result = [[ModelTopic alloc] initWithDictionary:dic];
            if(_completionHander) _completionHander(result,[[dic objectForKey:@"position"] intValue],nil);
        } else {
            NSString *textError = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"result_text"]]
                                                        encoding:NSUTF8StringEncoding];
            if(_completionHander) _completionHander(nil,-1,[NSError errorWithDomain:_kForumUrl code:1 userInfo:@{@"error" : textError}]);
        }
        
    }onPercent:^(float percent) {
    }fail:^(NSError *error){
        if(_completionHander) _completionHander(nil,-1,error);
    }];
}

+ (void)replyTopic:(ModelTopic*)topic
       withSubject:(NSString*)subject
              body:(NSString*)body
        attachment:(NSArray*)attack
 completionHandler:(void (^)(NSError *error))_completionHander
         onPercent:(void (^)(float percent))_percent
{
    NSMutableArray * params = [[NSMutableArray alloc] init];
    [params addObject:topic.forum_id];
    [params addObject:topic.topic_id];
    NSData  *subjectData = [subject dataUsingEncoding:NSUTF8StringEncoding];
    [params addObject:[NSData dataFromBase64String:[subjectData base64EncodedString]]];
    NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    [params addObject:[NSData dataFromBase64String:[bodyData base64EncodedString]]];
    [params addObject:[NSArray array]];
    [params addObject:@""];
    [params addObject:[NSNumber numberWithBool:YES]];
    
    LNRequestHelper *request = [[LNRequestHelper alloc] initWithURL:_kNSURLServerTapatalk];
    [request requestWithMethod:@"reply_post" prarameters:params success:^(XMLRPCResponse *response, NSDictionary *result) {
        if(_completionHander) _completionHander(nil);
    } fail:^(NSError *error, NSDictionary *result) {
        [LNAccountManager autoLoginOnCompletionHander:^(ModelUser *result2, NSError *error2) {
            if (error2) {
                if(_completionHander) _completionHander(error);
            } else {
                LNRequestHelper *request = [[LNRequestHelper alloc] initWithURL:_kNSURLServerTapatalk];
                [request requestWithMethod:@"reply_post" prarameters:params success:^(XMLRPCResponse *response3, NSDictionary *result3) {
                    if(_completionHander) _completionHander(nil);
                } fail:^(NSError *error3, NSDictionary *result3) {
                    if(_completionHander) _completionHander(error);
                }];
            }
        }];
    }];
}

#pragma mark - Search

+ (void)searchTopic:(NSString*)searchString startNumber:(int)startNumber lastNumber:(int)lastNumber searchId:(NSString*)searchId completionHandler:(void (^)(NSString *searchId, NSArray *arrTopic, int totalTopicNum , NSError *error))_completionHander onPercent:(void (^)(float percent))_percent {
    
    NSMutableArray *params = [[NSMutableArray alloc] init];
    [params addObject:[searchString  dataUsingEncoding:NSUTF8StringEncoding]];
    [params addObject:[NSNumber numberWithInt:startNumber]];
    [params addObject:[NSNumber numberWithInt:lastNumber]];
    if (searchId == nil) {
        searchId = @"";
    }
    [params addObject:searchId];
    
    LNRequest *request = [[LNRequest alloc] initWithURL:_kNSURLServerTapatalk];
    [request requestWithMethod:@"search_topic" prarameters:params onReceiveResponse:^(XMLRPCResponse *response) {
        
        CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[[response body] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding options:0 error:nil];
        
        NSArray *nodes    = [doc nodesForXPath:@"//methodResponse/params/param/value/struct/*" error:nil];
        NSDictionary *dic = [TapatalkHelper parseStructRespondToDictionary:nodes];
        
        if (![dic objectForKey:@"result_text"]) {
            if(_completionHander) _completionHander([dic objectForKey:@"search_id"],[dic objectForKey:@"topics"],[[dic objectForKey:@"total_topic_num"] intValue],nil);
        } else {
            NSString *textError = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"result_text"]]
                                                        encoding:NSUTF8StringEncoding];
            if(_completionHander) _completionHander(nil,nil,0,[NSError errorWithDomain:_kForumUrl code:1 userInfo:@{@"error" : textError}]);
        }
        
    }onPercent:^(float percent) {
        if(_percent) _percent(percent);
    }fail:^(NSError *error){
        if(_completionHander) _completionHander(nil,nil,0,error);
    }];
}

#pragma mark - Subscribe

+ (void)getSubscribeTopic:(int)_startNum lastNum:(int)_lastNum completionHandler:(void (^)(NSArray *arrTopic, int totalTopicNum, NSError *error))_completionHander{
    
    // build params
    NSMutableArray *params = [[NSMutableArray alloc] init];
    [params addObject:[NSNumber numberWithInt:_startNum]];
    [params addObject:[NSNumber numberWithInt:_lastNum]];
    
    // request
    LNRequest *request = [[LNRequest alloc] initWithURL:_kNSURLServerTapatalk];
    [request requestWithMethod:@"get_subscribed_topic" prarameters:params onReceiveResponse:^(XMLRPCResponse *response) {
        
        CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[[response body] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding options:0 error:nil];
        
        NSArray *nodes    = [doc nodesForXPath:@"//methodResponse/params/param/value/struct/*" error:nil];
        NSDictionary *dic = [TapatalkHelper parseStructRespondToDictionary:nodes];
        
        if (![dic objectForKey:@"result_text"]) {
            // fill dữ liệu
            if(_completionHander) _completionHander([dic objectForKey:@"topics"],[[dic objectForKey:@"total_topic_num"] intValue],nil);
        } else {
            NSString *textError = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"result_text"]]
                                                        encoding:NSUTF8StringEncoding];
            if(_completionHander) _completionHander(nil,0,[NSError errorWithDomain:_kForumUrl code:1 userInfo:@{@"error" : textError}]);
        }
        
    }onPercent:^(float percent) {
    }fail:^(NSError *error){
        if(_completionHander) _completionHander(nil,0,error);
    }];
}

+ (void)subscribeTopic:(NSString*)topicId success:(void (^)(void))_onSuccess fail:(void (^)(NSError *error))_onFail
{
    // build params
    NSMutableArray *params = [[NSMutableArray alloc] init];
    [params addObject:topicId];
    // subscribe_mode
    // = 0 : No email notìication
    // = 1 : Instant notification by email
    // = 2 : Daily updates by email
    // = 3 : Weekly updates by email
    [params addObject:[NSNumber numberWithInt:0]];
    
    LNRequestHelper *request = [[LNRequestHelper alloc] initWithURL:_kNSURLServerTapatalk];
    [request requestWithMethod:@"subscribe_topic" prarameters:params success:^(XMLRPCResponse *response, NSDictionary *result) {
        if(_onSuccess) _onSuccess();
    } fail:^(NSError *error, NSDictionary *result) {
        // login and try again
        [LNAccountManager autoLoginOnCompletionHander:^(ModelUser *result2, NSError *error2) {
            if (error2) {
                if(_onFail) _onFail(error);
            } else {
                [request requestWithMethod:@"subscribe_topic" prarameters:params success:^(XMLRPCResponse *response2, NSDictionary *result2) {
                    if(_onSuccess) _onSuccess();
                } fail:^(NSError *error3, NSDictionary *result3) {
                    if(_onFail) _onFail(error);
                }];
            }
        }];
        
    }];
}

+ (void)unsubscribeTopic:(NSString*)topicId success:(void (^)(void))_onSuccess fail:(void (^)(NSError *error))_onFail
{
    NSMutableArray *params = [[NSMutableArray alloc] init];
    [params addObject:topicId];
    
    LNRequestHelper *request = [[LNRequestHelper alloc] initWithURL:_kNSURLServerTapatalk];
    [request requestWithMethod:@"unsubscribe_topic" prarameters:params success:^(XMLRPCResponse *response, NSDictionary *result) {
        if(_onSuccess) _onSuccess();
    } fail:^(NSError *error, NSDictionary *result) {
        if(_onFail) _onFail(error);
    }];
}

#pragma mark - Post

+ (void)reportPost:(NSString*)postId reason:(NSString*)message success:(void (^)(void))_onSuccess fail:(void (^)(NSError *error))_onFail
{
    NSMutableArray *params = [[NSMutableArray alloc] init];
    [params addObject:postId];
    [params addObject:message];
    
    LNRequestHelper *request = [[LNRequestHelper alloc] initWithURL:_kNSURLServerTapatalk];
    [request requestWithMethod:@"report_post" prarameters:params success:^(XMLRPCResponse *response, NSDictionary *result) {
        if(_onSuccess) _onSuccess();
    } fail:^(NSError *error, NSDictionary *result) {
        if(_onFail) _onFail(error);
    }];
}

+ (void)thanksPost:(NSString*)post_id completionHandler:(void (^)(NSError *error))_completionHander
{
    NSMutableArray *params = [[NSMutableArray alloc] init];
    [params addObject:post_id];
    
    LNRequestHelper *request = [[LNRequestHelper alloc] initWithURL:_kNSURLServerTapatalk];
    [request requestWithMethod:@"thank_post" prarameters:params success:^(XMLRPCResponse *response, NSDictionary *result) {
        CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[[response body] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding options:0 error:nil];
        
        NSArray *nodes    = [doc nodesForXPath:@"//methodResponse/params/param/value/struct/*" error:nil];
        NSDictionary *dic = [TapatalkHelper parseStructRespondToDictionary:nodes];
        
        if (![dic objectForKey:@"result_text"]) {
            if(_completionHander) _completionHander(nil);
        } else {
            NSString *textError = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"result_text"]]
                                                        encoding:NSUTF8StringEncoding];
            if(_completionHander) _completionHander([NSError errorWithDomain:_kForumUrl code:1 userInfo:@{@"error" : textError}]);
        }
    } fail:^(NSError *error, NSDictionary *result) {
        if(_completionHander) _completionHander(error);
    }];
}

+ (void)getQuotePost:(NSString*)post_id completionHandler:(void (^)(NSString *title, NSString *content, NSError *error))_completionHander
{
    NSMutableArray *params = [[NSMutableArray alloc] init];
    [params addObject:post_id];
    
    LNRequestHelper *request = [[LNRequestHelper alloc] initWithURL:_kNSURLServerTapatalk];
    [request requestWithMethod:@"get_quote_post" prarameters:params success:^(XMLRPCResponse *response, NSDictionary *result) {
        
        CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[[response body] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding options:0 error:nil];
        
        NSArray *nodes    = [doc nodesForXPath:@"//methodResponse/params/param/value/struct/*" error:nil];
        NSDictionary *dic = [TapatalkHelper parseStructRespondToDictionary:nodes];
        
        if (![dic objectForKey:@"result_text"]) {
            NSString *title = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"post_title"]]
                                                    encoding:NSUTF8StringEncoding];
            NSString *content = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"post_content"]]
                                                      encoding:NSUTF8StringEncoding];
            if(_completionHander) _completionHander(title, content,nil);
        } else {
            NSString *textError = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"result_text"]]
                                                        encoding:NSUTF8StringEncoding];
            if(_completionHander) _completionHander(nil,nil,[NSError errorWithDomain:_kForumUrl code:1 userInfo:@{@"error" : textError}]);
        }
    } fail:^(NSError *error, NSDictionary *result) {
        // login and try again
        [LNAccountManager autoLoginOnCompletionHander:^(ModelUser *result2, NSError *error2) {
            if (error2) {
                if(_completionHander) _completionHander(nil,nil,error);
            } else {
                [request requestWithMethod:@"get_quote_post" prarameters:params success:^(XMLRPCResponse *response, NSDictionary *result) {
                    
                    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[[response body] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding options:0 error:nil];
                    
                    NSArray *nodes    = [doc nodesForXPath:@"//methodResponse/params/param/value/struct/*" error:nil];
                    NSDictionary *dic = [TapatalkHelper parseStructRespondToDictionary:nodes];
                    
                    if (![dic objectForKey:@"result_text"]) {
                        NSString *title = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"post_title"]]
                                                                encoding:NSUTF8StringEncoding];
                        NSString *content = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"post_content"]]
                                                                  encoding:NSUTF8StringEncoding];
                        if(_completionHander) _completionHander(title, content,nil);
                    } else {
                        NSString *textError = [[NSString alloc] initWithData:[NSData dataFromBase64String:[dic objectForKey:@"result_text"]]
                                                                    encoding:NSUTF8StringEncoding];
                        if(_completionHander) _completionHander(nil,nil,[NSError errorWithDomain:_kForumUrl code:1 userInfo:@{@"error" : textError}]);
                    }
                } fail:^(NSError *error3, NSDictionary *result3) {
                    if(_completionHander) _completionHander(nil, nil,error);
                }];
            }
        }];
    }];
}

#pragma mark - Helper

+ (void)printForum:(NSArray*)forum {
    for (int i = 0 ; i < [forum count]; i ++) {
        ModelForum *child = [forum objectAtIndex:i];
        NSLog(@"%@ - %@",child.forum_id, child.forum_name);
        NSArray *childArr = child.child;
        for (ModelForum *childForm in childArr) {
            NSLog(@"--- %@ - %@",childForm.forum_id, childForm.forum_name);
        }
        if (childArr) {
            //[self printForum:childArr];
        }
    }
}

@end
