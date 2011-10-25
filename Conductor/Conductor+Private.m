//
//  Conductor+Private.m
//  Conductor
//
//  Created by Andrew Smith on 10/24/11.
//  Copyright (c) 2011 Andrew B. Smith. All rights reserved.
//

#import "Conductor+Private.h"

@implementation Conductor (Private)


- (NSString *)queueNameForOperation:(NSOperation *)operation {
    if (!operation) return nil;
    NSString *className = NSStringFromClass([operation class]);
    return [NSString stringWithFormat:@"%@_operation_queue", className];
}

- (CDOperationQueue *)queueForOperation:(NSOperation *)operation
                           shouldCreate:(BOOL)create {
    
    NSString *queueName = [self queueNameForOperation:operation];
    return [self queueForQueueName:queueName shouldCreate:create];
}

- (CDOperationQueue *)getQueueNamed:(NSString *)queueNamed {
    if (!queueNamed) return nil;
    return [self.queues objectForKey:queueNamed];
}

- (CDOperationQueue *)queueForQueueName:(NSString *)queueName 
                           shouldCreate:(BOOL)create {
    if (!queueName) return nil;
    
    id queue = [self.queues objectForKey:queueName];
    
    if (!queue && create) {
        queue = [self createQueueWithName:queueName];
    }
    
    return (CDOperationQueue *)queue;
}


- (CDOperationQueue *)createQueueWithName:(NSString *)queueName {
    if (!queueName) return nil;
    CDOperationQueue *queue = [CDOperationQueue queueWithName:queueName];
    [self.queues setObject:queue forKey:queueName];
    return queue;
}

@end
