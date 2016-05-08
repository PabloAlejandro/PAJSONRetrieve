//
//  PAJSONRetrieve.h
//  PAJSONRetrieve
//
//  Created by Pau on 08/05/2016.
//  Copyright © 2016 Pablo Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This interface is used to abstract network operations in a way that asynchronous operations can be called
 * from a testing environment.
 * Production code should never set the 'testing' flag to true, while unit tests always should!
 */

@interface NetworkFactoryRequests : NSObject

- (void)sendAsynchronousRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler NS_DEPRECATED(10_7, 10_11, 5_0, 10_0, "Use [NetworkFactoryRequests sendAsynchronousRequest:completionHandler:]");

@end