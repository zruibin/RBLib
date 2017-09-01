//
//  RBURLProtocol.m
//  RBLib
//
//  Created by Ruibin.Chow on 6/21/16.
//  Copyright © 2016 zruibin. All rights reserved.
//

#import "RBURLProtocol.h"
#import "RBMacros.h"

static NSString * const RBURLProtocolHandledKey = @"RBURLProtocolHandledKey";

@interface RBURLProtocol () <NSURLSessionDelegate>

@property (atomic, strong, readwrite) NSURLSessionDataTask *task;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSDate  *startDate;

@end

@implementation RBURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame))
    {
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:RBURLProtocolHandledKey inRequest:request]) {
            return NO;
        }
        
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    /** 可以在此处添加头等信息  */
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    return [mutableReqeust copy];
}

- (void)startLoading
{
    DLog(@"RBURLProtocol__startLoading");
    
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    
    //打标签，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:RBURLProtocolHandledKey inRequest:mutableReqeust];
    
    NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    self.session  = [NSURLSession sessionWithConfiguration:configure delegate:self delegateQueue:queue];
    self.task = [self.session dataTaskWithRequest:mutableReqeust];
    [self.task resume];
}

- (void)stopLoading
{
    [self.session invalidateAndCancel];
    self.session = nil;
    DLog(@"RBURLProtocol__stopLoading");
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *duration = [NSString stringWithFormat:@"%fs",[[NSDate date] timeIntervalSince1970] - [self.startDate timeIntervalSince1970]];
    DLog(@"NSURLSession duartion:%@", duration);
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error != nil) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response
            completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler
{
    completionHandler(proposedResponse);
}

//TODO: 重定向
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    NSMutableURLRequest *redirectRequest= [newRequest mutableCopy];
    [[self class] removePropertyForKey:RBURLProtocolHandledKey inRequest:redirectRequest];
    [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
    
    [self.task cancel];
    [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
}

- (instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client
{
    
    NSMutableURLRequest*    redirectRequest;
    redirectRequest = [request mutableCopy];
    
    //添加认证信息
//    NSString *authString = [[[NSString stringWithFormat:@"%@:%@", kGlobal.userInfo.sAccount, kGlobal.userInfo.sPassword] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
//    authString = [NSString stringWithFormat: @"Basic %@", authString];
//    [redirectRequest setValue:authString forHTTPHeaderField:@"Authorization"];
    DLog(@"拦截的请求:%@",request.URL.absoluteString);
    
    self = [super initWithRequest:redirectRequest cachedResponse:cachedResponse client:client];
    if (self) {
        
        // Some stuff
    }
    return self;
}


/*
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    
    DLog(@"自定义Protocol开始认证...");
    NSString *authMethod = [[challenge protectionSpace] authenticationMethod];
    DLog(@"%@认证...",authMethod);
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodNTLM]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialWithUser:kGlobal.userInfo.sAccount password:kGlobal.userInfo.sPassword persistence:NSURLCredentialPersistenceForSession];
            [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }else{
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge,nil);
        }
    }
    
    DLog(@"自定义Protocol认证结束");
}
//*/


@end
