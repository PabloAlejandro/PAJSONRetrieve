//
//  PAJSONRetrieve.m
//  PAJSONRetrieve
//
//  Created by Pau on 08/05/2016.
//  Copyright © 2016 Pablo Alejandro. All rights reserved.
//

#import "JSONRequestsManager.h"
#import "ServerRequestUtils.h"
#import "NetworkFactoryRequests.h"

@interface JSONRequestsManager ()

@property (nonatomic, strong) NetworkFactoryRequests * networkFactoryRequests;

@end

@implementation JSONRequestsManager {
    NSOperationQueue *queue;
}

@synthesize timeout;

- (id)init {
    
    if ((self = [super init])) {
        [self setup];
    }
    return self;
}

#pragma mark - Private methods

- (void)setup
{
    queue = [NSOperationQueue new];
    [queue setName:@"com.ServerRequestQueue"];
    timeout = 60;
}

#pragma mark - Public instance methods

- (void)getObjectFromServer:(NSURL *)server endPoint:(NSString *)endPoint parameters:(NSDictionary *)parameters httpHeaderFields:(NSDictionary *)httpHeaderFields method:(NSString *)method referer:(NSURL *)referer requestKey:(NSString *)requestKey requestSecretKey:(NSString *)requestSecretKey userAgent:(NSString *)userAgent data:(NSData *)data userToken:(NSString *)userToken done:(void (^)(NSObject *object, NSError *error))doneBlock
{
    NSString *urlRequest = [NSString stringWithFormat:@"%@/%@", server, endPoint];
    
    for(NSString *key in parameters) {
        urlRequest = [ServerRequestUtils addObject:[parameters objectForKey:key] key:key toRequest:urlRequest];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableURLRequest *request = [ServerRequestUtils newRequestWithUrl:urlRequest timeoutInterval:timeout];
        
        [request setHTTPMethod:method];
        
        for(NSString *key in httpHeaderFields) {
            [request setValue:[httpHeaderFields objectForKey:key] forHTTPHeaderField:key];
        }
        
        if(data) {
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody: data];
        }
        
        request = [ServerRequestUtils addToken:userToken toURLRequest:request];
        request = [ServerRequestUtils addReferer:referer toURLRequest:request];
        request = [ServerRequestUtils addRequestKey:requestKey toURLRequest:request];
        request = [ServerRequestUtils addRequestSecretKey:requestSecretKey toURLRequest:request];
        request = [ServerRequestUtils addUserAgent:userAgent toURLRequest:request];
        
        if(self.debug) {
            NSLog(@"%s %@", __func__, urlRequest);
            NSLog(@"%s %@", __func__, [request allHTTPHeaderFields]);
        }
        
        [self.networkFactoryRequests sendAsynchronousRequest:request
                                                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                           
                                                           if(self.debug) {
                                                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                               NSNumber *statusCode = [NSNumber numberWithInteger:[httpResponse statusCode]];
                                                               
                                                               NSLog(@"statusCode: %@", statusCode);
                                                           }
                                                           
                                                           if (error != nil) {
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   doneBlock(nil, error);
                                                               });
                                                           }
                                                           else {
                                                               [ServerRequestUtils processData:data done:doneBlock];
                                                           }
                                                       }];
    });
}

- (void)getObjectFromUrl:(NSURL *)url parameters:(NSDictionary *)parameters httpHeaderFields:(NSDictionary *)httpHeaderFields method:(NSString *)method referer:(NSURL *)referer requestKey:(NSString *)requestKey requestSecretKey:(NSString *)requestSecretKey userAgent:(NSString *)userAgent data:(NSData *)data userToken:(NSString *)userToken done:(void (^)(NSObject *object, NSError *error))doneBlock
{
    NSString *urlRequest = [url absoluteString];
    
    for(NSString *key in parameters) {
        urlRequest = [ServerRequestUtils addObject:[parameters objectForKey:key] key:key toRequest:urlRequest];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableURLRequest *request = [ServerRequestUtils newRequestWithUrl:urlRequest timeoutInterval:timeout];
        
        [request setHTTPMethod:method];

        for(NSString *key in httpHeaderFields) {
            [request setValue:[httpHeaderFields objectForKey:key] forHTTPHeaderField:key];
        }
        
        if(data) {
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody: data];
        }
        
        request = [ServerRequestUtils addToken:userToken toURLRequest:request];
        request = [ServerRequestUtils addReferer:referer toURLRequest:request];
        request = [ServerRequestUtils addRequestKey:requestKey toURLRequest:request];
        request = [ServerRequestUtils addRequestSecretKey:requestSecretKey toURLRequest:request];
        request = [ServerRequestUtils addUserAgent:userAgent toURLRequest:request];
        
        if(self.debug) {
            NSLog(@"%s %@", __func__, urlRequest);
            NSLog(@"%s %@", __func__, [request allHTTPHeaderFields]);
        }
        
        [self.networkFactoryRequests sendAsynchronousRequest:request
                                                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                           
                                                           if(self.debug) {
                                                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                               NSNumber *statusCode = [NSNumber numberWithInteger:[httpResponse statusCode]];
                                                               
                                                               NSLog(@"statusCode: %@", statusCode);
                                                           }
                                                           
                                                           if (error != nil) {
                                                               
                                                               if(self.debug) {
                                                                   NSLog(@"%s Error: %@", __func__, error);
                                                               }
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   doneBlock(nil, error);
                                                               });
                                                           }
                                                           else {
                                                               [ServerRequestUtils processData:data done:doneBlock];
                                                           }
                                                       }];
    });
}

#pragma mark - Getters

- (NetworkFactoryRequests * )networkFactoryRequests
{
    if(_networkFactoryRequests == nil) {
        _networkFactoryRequests = [[NetworkFactoryRequests alloc] init];
    }
    return _networkFactoryRequests;
}

@end
