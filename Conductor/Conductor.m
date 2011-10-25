//
//  Conductor.m
//  Conductor
//
//  Created by Andrew Smith on 10/21/11.
//  Copyright (c) 2011 Andrew B. Smith. All rights reserved.
//

#import "Conductor.h"


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

#pragma mark - Private

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
