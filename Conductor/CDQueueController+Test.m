//
//  CDQueueController+Test.m
//  Conductor
//
//  Created by Andrew Smith on 3/21/13.
//  Copyright (c) 2013 Andrew B. Smith. All rights reserved.
//

#import "CDQueueController+Test.h"

@implementation CDQueueController (Test)

- (void)waitForQueueNamed:(NSString *)queueName
{
    /**
     This is really only meant for testing async code.  This blocks the current thread and dissalows
     adding more opperations to the queue from this thread. Given that tests all run on the main loop,
     it is pretty easy to accidentally deadlock your test accidentally, so be careful.
     */
    
    CDOperationQueue *queue = [self getQueueNamed:queueName];
    
    if (!queue.isExecuting) return;
    
    //
    // Wait until Apple thinks all operations are finished
    //
    [queue.queue waitUntilAllOperationsAreFinished];
}

- (void)logAllOperations
{
    NSArray *queueNames = [self allQueueNames];    
    for (NSString *queueName in queueNames) {
        [self logAllOperationsInQueueNamed:queueName];
    }
}

- (void)logAllOperationsInQueueNamed:(NSString *)queueName
{
    CDOperationQueue *queue = [self getQueueNamed:queueName];
    NSLog(@"Operations in %@: %@", queueName, queue.operations);
}

@end
