//
//  CDQueueController+State.m
//  Conductor
//
//  Created by Andrew Smith on 3/21/13.
//  Copyright (c) 2013 Andrew B. Smith. All rights reserved.
//

#import "CDQueueController+State.h"

@implementation CDQueueController (State)

#pragma mark - Executing

- (BOOL)isExecuting
{
    __block BOOL isExecuting = NO;
    @synchronized (self.queues)
    {
        [self.queues enumerateKeysAndObjectsUsingBlock:^(id queueName, CDOperationQueue *queue, BOOL *stop) {
            if (queue.isExecuting) {
                isExecuting = YES;
                *stop = YES;
            }
        }];
    };
    return isExecuting;
}

- (BOOL)isQueueExecutingNamed:(NSString *)queueName
{
    CDOperationQueue *queue = [self getQueueNamed:queueName];
    if (!queue) return NO;
    return queue.isExecuting;
}

#pragma mark - Suspend

- (void)suspendAllQueues
{
    ConductorLogTrace(@"Suspend all queues");
    
    NSArray *queuesNamesToSuspend = [self allQueueNames];
    
    for (NSString *queueName in queuesNamesToSuspend) {
        [self suspendQueueNamed:queueName];
    }
}

- (void)suspendQueueNamed:(NSString *)queueName
{
    ConductorLogTrace(@"Suspend queue: %@", queueName);
    CDOperationQueue *queue = [self getQueueNamed:queueName];;
    [queue setSuspended:YES];
}

#pragma mark - Resume

- (void)resumeAllQueues
{
    ConductorLogTrace(@"Resume all queues");
    for (NSString *queueName in self.queues) {
        [self resumeQueueNamed:queueName];
    }
}

- (void)resumeQueueNamed:(NSString *)queueName
{
    ConductorLogTrace(@"Resume queue: %@", queueName);
    CDOperationQueue *queue = [self getQueueNamed:queueName];;
    [queue setSuspended:NO];
}

#pragma mark - Cancel

- (void)cancelAllOperations
{
    ConductorLogTrace(@"Cancel all operations");
    
    // Grabbing queue names prevents mutation while enumeration of queues dict
    NSArray *queuesNamesToCancel = [self allQueueNames];
    
    for (NSString *queueName in queuesNamesToCancel) {
        [self cancelAllOperationsInQueueNamed:queueName];
    }
}

- (void)cancelAllOperationsInQueueNamed:(NSString *)queueName
{
    ConductorLogTrace(@"Cancel all operations in queue: %@", queueName);
    CDOperationQueue *queue = [self getQueueNamed:queueName];
    [queue cancelAllOperations];
}

@end
