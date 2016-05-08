//
//  PAJSONRetrieve.m
//  PAJSONRetrieve
//
//  Created by Pau on 08/05/2016.
//  Copyright © 2016 Pablo Alejandro. All rights reserved.
//

#import "PAJSONRetrieve.h"
#import "JSONRequestsManager.h"

static NSTimeInterval const kMinTimeInterval = 5;

@interface PAJSONRetrieve ()

@property (nonatomic) NSTimeInterval timeInterval;
@property (nonatomic, strong) RequestResultBlock completion;
@property (nonatomic, strong) JSONRequestsManager *request;

@end

@implementation PAJSONRetrieve

- (id)initWithUrl:(NSURL *)url completionBlock:(RequestResultBlock)completion
{
    if(self = [super init]) {
        _url = url;
        _completion = completion;
    }
    return self;
}

- (id)initWithUrl:(NSURL *)url parameters:(NSDictionary *)parameters httpHeaderFields:(NSDictionary *)httpHeaderFields method:(HTTP_METHOD)method referer:(NSURL *)referer requestKey:(NSString *)requestKey requestSecretKey:(NSString *)requestSecretKey userAgent:(NSString *)userAgent data:(NSData *)data userToken:(NSString *)userToken completionBlock:(RequestResultBlock)completion
{
    if(self = [super init]) {
        _url = url;
        _parameters = parameters;
        _httpHeaderFields = httpHeaderFields;
        _method = method;
        _referer = referer;
        _requestKey = requestKey;
        _requestSecretKey = requestSecretKey;
        _userAgent = userAgent;
        _data = data;
        _userToken = userToken;
        _completion = completion;
    }
    return self;
}

- (void)retrieveData
{
    NSAssert(self.url != nil, @"URL can't be null");
    NSAssert(self.completion != nil, @"Completion can't be null");
    
    self.request.timeout = self.timeout;
    self.request.debug = NO;
    [self.request getObjectFromUrl:self.url parameters:self.parameters httpHeaderFields:self.httpHeaderFields method:[ServerRequestUtils methodName:self.method] referer:self.referer requestKey:self.requestKey requestSecretKey:self.requestSecretKey userAgent:self.userAgent data:self.data userToken:self.userToken done:^(NSObject *object, NSError *error) {
        [self handleResponse:object error:error];
    }];
}

- (void)cancel
{
    self.request = nil;
}

#pragma mark - Private methods

- (void)handleResponse:(NSObject *)object error:(NSError *)error
{
    if(error == nil) {
        
        self.timeInterval = kMinTimeInterval;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.completion(object, nil);
        });
    }
    else {
        
        // TODO: We can implement different options:
        // - Retry after a time (I recommend using Reachability library in order to check network connection)
        // - Let the user to manually retry with a popup (this option requires to implement a
        // delegate or callback in order to notify the parent)
        // - Implement other ways to manually retry (this also requires to notify the paren object)
        
        /**
         * This is an example of how we could catch the download error
         */
        // if(networkAvailable) ...
        [self performSelector:@selector(retrieveData) withObject:nil afterDelay:self.timeInterval];
        
        // We increase the time interval for the next try
        self.timeInterval *= 2;
    }
}

#pragma mark - Getters

- (NSTimeInterval)timeInterval
{
    if(_timeInterval <= 0) {
        _timeInterval = kMinTimeInterval;
    }
    return _timeInterval;
}

- (JSONRequestsManager *)request
{
    if(_request == nil) {
        _request = [JSONRequestsManager new];
    }
    return _request;
}

- (float)timeout
{
    if(_timeout <= 0) {
        _timeout = 30;
    }
    return _timeout;
}

@end