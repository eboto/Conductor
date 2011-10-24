//
//  CDOperationQueue.h
//  Conductor
//
//  Created by Andrew Smith on 10/21/11.
//  Copyright (c) 2011 Andrew B. Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CDOperation.h"

@interface CDOperationQueue : NSObject {
@private
    NSOperationQueue *queue;
    NSString *name;
    NSMutableDictionary *operations;
}

/**
 * Holds the operation queue
 */
@property (nonatomic, readonly) NSOperationQueue *queue;

/**
 * User set name of the queue
 */
@property (nonatomic, copy) NSString *name;

/**
 * Dictionary of all CDOperations in the queue, where the key is the operations 
 * identifier and the object is the operation
 */
@property (nonatomic, readonly) NSMutableDictionary *operations;

+ (id)queueWithName:(NSString *)queueName;

/**
 * Add an operation to the queue.
 */
- (void)addOperation:(NSOperation *)operation;

/**
 * Add an operation and specify the priority
 */
- (void)addOperation:(NSOperation *)operation 
          atPriority:(NSOperationQueuePriority)priority;

- (void)cancelAllOperations;

/**
 * Retrieve an operation with a given identifier.  Returns nil if operation has
 * already finished.
 */
- (CDOperation *)getOperationWithIdentifier:(id)identifier;

/**
 * Update the priority of a given operation, as long as it currently running or
 * already finished.
 */
- (BOOL)updatePriorityOfOperationWithIdentifier:(id)identifier 
                                  toNewPriority:(NSOperationQueuePriority)priority;

/**
 * Returns YES if there are operations in the queue
 */
- (BOOL)isRunning;

@end
