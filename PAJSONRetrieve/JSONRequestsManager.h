//
//  PAJSONRetrieve.m
//  PAJSONRetrieve
//
//  Created by Pau on 08/05/2016.
//  Copyright © 2016 Pablo Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONRequestsManager : NSObject

/**
 * Send HTTP request to an endpoint in a server and returns whether there was an error in the request or not
 * and the response of the server
 * @param server server to request
 * @param endPoint endpoint on the server to request
 * @param parameters GET params @{ name : value }
 * @param HTTPHeaderFields HTTP header fields @{ name : value }
 * @param string method HTTP method [ GET, PUT, POST, DELETE ]
 * @param referer URL referer
 * @param requestKey key for request
 * @param requestSecretKey secret key for request
 * @param userAgent request user agent
 * @param data data to append to the request
 * @param userToken user authentication token @"authentication_token", @"token authentication_token", @"Token authentication_token", ...
 */
- (void)getObjectFromServer:(NSURL *)server endPoint:(NSString *)endPoint parameters:(NSDictionary *)parameters httpHeaderFields:(NSDictionary *)httpHeaderFields method:(NSString *)method referer:(NSURL *)referer requestKey:(NSString *)requestKey requestSecretKey:(NSString *)requestSecretKey userAgent:(NSString *)userAgent data:(NSData *)data userToken:(NSString *)userToken done:(void (^)(NSObject *object, NSError *error))doneBlock;

/**
 * Send HTTP request to an absolute URL and returns whether there was an error in the request or not
 * and the response of the server
 * @param url absolute url to request
 * @param attributes GET params @{ name : value }
 * @param HTTPHeaderFields HTTP header fields @{ name : value }
 * @param string method HTTP method [ GET, PUT, POST, DELETE ]
 * @param referer URL referer
 * @param requestKey key for request
 * @param requestSecretKey secret key for request
 * @param userAgent request user agent
 * @param data data to append to the request
 * @param userToken user authentication token @"authentication_token", @"token authentication_token", @"Token authentication_token", ...
 */
- (void)getObjectFromUrl:(NSURL *)url parameters:(NSDictionary *)parameters httpHeaderFields:(NSDictionary *)httpHeaderFields method:(NSString *)method referer:(NSURL *)referer requestKey:(NSString *)requestKey requestSecretKey:(NSString *)requestSecretKey userAgent:(NSString *)userAgent data:(NSData *)data userToken:(NSString *)userToken done:(void (^)(NSObject *object, NSError *error))doneBlock;

/**
 * Timeout for requests
 */
@property (nonatomic) float timeout;

/**
 * Set to YES in order to print debug information
 */
@property (nonatomic) BOOL debug;

@end
