//
//  Conductor.m
//  Conductor
//
//  Created by Andrew Smith on 10/21/11.
//  Copyright (c) 2011 Andrew B. Smith. All rights reserved.
//

#import "Conductor.h"
#import "Conductor+Private.h"


@implementation Conductor

+ (id)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedInstance = nil;
    dispatch_once(&pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Queue Control

- (void)addOperation:(CDOperation *)operation {
    [self addOperation:operation atPriority:operation.queuePriority];
}

- (void)addOperation:(CDOperation *)operation 
          atPriority:(NSOperationQueuePriority)priority {
    
    NSString *queueName = [self queueNameForOperation:operation];
    
    [self addOperation:operation
          toQueueNamed:queueName
            atPriority:priority];
    
}

- (void)addOperation:(CDOperation *)operation 
        toQueueNamed:(NSString *)queueName {
    
    [self addOperation:operation 
          toQueueNamed:queueName 
            atPriority:operation.queuePriority];
    
}

- (void)addOperation:(CDOperation *)operation 
        toQueueNamed:(NSString *)queueName 
          atPriority:(NSOperationQueuePriority)priority {
    
    CDOperationQueue *queue = nil;
    
    if (queueName) {
        queue = [self queueForQueueName:queueName shouldCreate:YES];
    } else {
        queue = [self queueForOperation:operation shouldCreate:YES];
    }
        
    [queue addOperation:operation atPriority:priority];
}

- (BOOL)updatePriorityOfOperationWithIdentifier:(NSString *)identifier 
                                  toNewPriority:(NSOperationQueuePriority)priority {
    
    __block BOOL didUpdate = NO;
    
    [self.queues enumerateKeysAndObjectsUsingBlock:^(id queueName, CDOperationQueue *queue, BOOL *stop) {
        if ([queue updatePriorityOfOperationWithIdentifier:queue toNewPriority:priority]) {
            didUpdate = YES;
            *stop = YES;
        }
    }];

    return didUpdate;
}

- (void)cancelAllOperations {
    for (NSString *queueName in self.queues) {
        CDOperationQueue *queue = [self queueForQueueName:queueName shouldCreate:NO];
        [queue cancelAllOperations];
    }
}

- (void)cancelAllOperationsInQueueNamed:(NSString *)queueName {
    if (!queueName) return;
    CDOperationQueue *queue = [self queueForQueueName:queueName shouldCreate:NO];;
    [queue cancelAllOperations];
}

#pragma mark - Queue

- (NSArray *)allQueueNames {
    return [self.queues allKeys];
}

#pragma mark - Accessors

- (NSMutableDictionary *)queues {
    if (queues) return [[queues retain] autorelease];
    queues = [[NSMutableDictionary alloc] init];
    return [[queues retain] autorelease];
}

@end
