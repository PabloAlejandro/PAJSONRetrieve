//
//  PAJSONRetrieve.h
//  PAJSONRetrieve
//
//  Created by Pau on 08/05/2016.
//  Copyright © 2016 Pablo Alejandro. All rights reserved.
//

#import "NetworkFactoryRequests.h"
#import <Foundation/Foundation.h>

@interface NetworkFactoryRequests () 

@end

@implementation NetworkFactoryRequests

- (void)sendAsynchronousRequest:(NSURLRequest *)request
    completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))completionHandler {

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      completionHandler(response, data, error);
                                  }];
    [task resume];
}

@end
