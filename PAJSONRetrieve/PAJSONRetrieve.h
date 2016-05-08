//
//  PAJSONRetrieve.h
//  PAJSONRetrieve
//
//  Created by Pau on 08/05/2016.
//  Copyright © 2016 Pablo Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ServerRequestUtils.h"

typedef void(^RequestResultBlock)(id result, NSDictionary * userInfo);

@interface PAJSONRetrieve : NSObject

- (id) init __unavailable;
- (id)initWithUrl:(NSURL *)url completionBlock:(RequestResultBlock)completion;
- (id)initWithUrl:(NSURL *)url parameters:(NSDictionary *)parameters httpHeaderFields:(NSDictionary *)httpHeaderFields method:(HTTP_METHOD)method referer:(NSURL *)referer requestKey:(NSString *)requestKey requestSecretKey:(NSString *)requestSecretKey userAgent:(NSString *)userAgent data:(NSData *)data userToken:(NSString *)userToken completionBlock:(RequestResultBlock)completion;

- (void)retrieveData;
- (void)cancel;

@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, strong) NSDictionary *httpHeaderFields;
@property (nonatomic) HTTP_METHOD method;
@property (nonatomic, strong) NSURL *referer;
@property (nonatomic, strong) NSString *requestKey;
@property (nonatomic, strong) NSString *requestSecretKey;
@property (nonatomic, strong) NSString *userAgent;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSString *userToken;

/**
 * Timeout for requests
 */
@property (nonatomic) float timeout;

@end
