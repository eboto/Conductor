//
//  CDOperationQueue.m
//  Conductor
//
//  Created by Andrew Smith on 10/21/11.
//  Copyright (c) 2011 Andrew B. Smith. All rights reserved.
//

#import "CDOperationQueue.h"

@interface CDOperationQueue (Private)
- (void)operationDidFinish:(CDOperation *)operation;
@end

@implementation CDOperationQueue

@synthesize name;

- (void)dealloc {
    [queue release], queue = nil;
    [name release], name = nil;
    [operations release], operations = nil;
    
    [super dealloc];
}

+ (id)queueWithName:(NSString *)queueName {
    CDOperationQueue *q = [[[self alloc] init] autorelease];
    q.name = queueName;
    return q;
}

#pragma mark -

- (void)addOperation:(NSOperation *)operation {
    [self addOperation:operation atPriority:operation.queuePriority];
}

- (void)addOperation:(NSOperation *)operation 
          atPriority:(NSOperationQueuePriority)priority {
    
    // Observe
    if ([operation isKindOfClass:[CDOperation class]]) {
        
        // Add operation to operations dict
        CDOperation *op = (CDOperation *)operation;
        [self.operations setObject:op forKey:op.identifier];
        
        // KVO operation is finished
        [op addObserver:self
             forKeyPath:@"isFinished" 
                options:NSKeyValueObservingOptionNew 
                context:NULL];
    }
    
    // set priority
    [operation setQueuePriority:priority];
    
    // Add operation to queue and start
    [self.queue addOperation:operation];
}

- (void)cancelAllOperations {
    [self.queue cancelAllOperations];
}

- (void)operationDidFinish:(CDOperation *)operation {
    // Cleanup after operation is finished
    [operation removeObserver:self forKeyPath:@"isFinished"];  
    [self.operations removeObjectForKey:operation.identifier];
}

- (CDOperation *)getOperationWithIdentifier:(id)identifier {
    CDOperation *op = [self.operations objectForKey:identifier];
    return op;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary *)change 
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"isFinished"] && [object isKindOfClass:[CDOperation class]]) {
        CDOperation *op = (CDOperation *)object;
        [self operationDidFinish:op];
    }
}

#pragma mark - Priority

- (BOOL)updatePriorityOfOperationWithIdentifier:(id)identifier 
                                  toNewPriority:(NSOperationQueuePriority)priority {
    CDOperation *op = [self getOperationWithIdentifier:identifier];
    
    // These tests are probably not necessry, just thrown in for extra safety
    if (op && ![op isExecuting] && ![op isCancelled] && ![op isFinished]) {
        [op setQueuePriority:priority];
        return YES;
    }
    
    return NO;
}

#pragma mark - Accessors

- (NSOperationQueue *)queue {
    if (queue) return [[queue retain] autorelease];
    queue = [[NSOperationQueue alloc] init];
    return [[queue retain] autorelease];
}

- (NSMutableDictionary *)operations {
    if (operations) return [[operations retain] autorelease];
    operations = [[NSMutableDictionary alloc] init];
    return [[operations retain] autorelease];
}

- (BOOL)isRunning {
    return (self.queue.operationCount > 0);
}

@end
