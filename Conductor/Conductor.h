//
//  Conductor.h
//  Conductor
//
//  Created by Andrew Smith on 10/21/11.
//  Copyright (c) 2011 Posterous. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDOperationQueue.h"

@interface Conductor : NSObject {
@private
    NSMutableDictionary *queues;
}

@property (nonatomic, readonly) NSMutableDictionary *queues;

- (void)addOperation:(NSOperation *)operation;

- (void)addOperation:(NSOperation *)operation 
          atPriority:(NSOperationQueuePriority)priority;

- (void)addOperation:(NSOperation *)operation 
          atPriority:(NSOperationQueuePriority)priority 
        toQueueNamed:(NSString *)queueName;

- (void)cancelAllOperations;
- (void)cancelAllOperationsInQueueNamed:(NSString *)queueName;

- (CDOperationQueue *)getQueueNamed:(NSString *)queueNamed;

@end
