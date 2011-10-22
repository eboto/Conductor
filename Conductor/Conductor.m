//
//  Conductor.m
//  Conductor
//
//  Created by Andrew Smith on 10/21/11.
//  Copyright (c) 2011 Posterous. All rights reserved.
//

#import "Conductor.h"

@implementation Conductor

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)addOperation:(NSOperation *)operation {
    
}

- (void)addOperation:(NSOperation *)operation 
          atPriority:(NSOperationQueuePriority)priority {
    
}

- (void)addOperation:(NSOperation *)operation 
          atPriority:(NSOperationQueuePriority)priority 
        toQueueNamed:(NSString *)queueName {
    
}

- (void)cancelAllOperations {
    
}

- (void)cancelAllOperationsInQueueNamed:(NSString *)queueName {
    
}

#pragma mark - Accessors

- (NSMutableDictionary *)queues {
    if (queues) return [[queues retain] autorelease];
    queues = [[NSMutableDictionary alloc] init];
    return [[queues retain] autorelease];
}

- (CDOperationQueue *)getQueueNamed:(NSString *)queueNamed {
    return nil;
}

@end
