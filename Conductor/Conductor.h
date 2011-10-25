//
//  Conductor.h
//  Conductor
//
//  Created by Andrew Smith on 10/21/11.
//  Copyright (c) 2011 Andrew B. Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDOperationQueue.h"

@interface Conductor : NSObject {
@private
    NSMutableDictionary *queues;
}

@property (nonatomic, readonly) NSMutableDictionary *queues;

/**
 * Singleton Conductor instance
 */
+ (id)sharedInstance;

/**
 * Creates a queue based on the operations class name and adds the operation to
 * it.  Will not create a new operation queue if one by that name already exists.
 * Returns the operation identifier.
 * @see queueNameForOperation:
 */
- (void)addOperation:(CDOperation *)operation;

/**
 * Creates a queue based on the operations class name and adds the operation to
 * it at the given priority.  Will not create a new operation queue if the one
 * by that name already exists.  Returns the operation identifer.
 * @see queueNameForOperation:
 */
- (void)addOperation:(CDOperation *)operation 
          atPriority:(NSOperationQueuePriority)priority;


- (void)addOperation:(CDOperation *)operation 
        toQueueNamed:(NSString *)queueName;

/**
 * Adds the operation to the queue with the given name at the specified priority.
 * Optionally create the queue if it doesn't already exist. Returns the operation
 * identifier.
 */
- (void)addOperation:(CDOperation *)operation 
        toQueueNamed:(NSString *)queueName
          atPriority:(NSOperationQueuePriority)priority;

/**
 *
 */
- (BOOL)updatePriorityOfOperationWithIdentifier:(NSString *)identifier 
                                  toNewPriority:(NSOperationQueuePriority)priority;


/**
 * Cancels all operations in all queues.  Useful when you need to cleanup before
 * shutting the app down.
 */
- (void)cancelAllOperations;

/**
 * Cancels all the operations is a specific queue
 */
- (void)cancelAllOperationsInQueueNamed:(NSString *)queueName;

/**
 * List of all queue names
 */
- (NSArray *)allQueueNames;

#pragma mark Private

/**
 * Returns the queue name for the specific operation type
 */
- (NSString *)queueNameForOperation:(NSOperation *)operation;

/**
 * Returns the queue for the specific operation type, nil if no queue already
 * exists.  If create == YES, the queue will also be created.
 */
- (CDOperationQueue *)queueForOperation:(NSOperation *)operation 
                           shouldCreate:(BOOL)create;

/**
 * Returns the queue for the given name
 */
- (CDOperationQueue *)queueForQueueName:(NSString *)queueName 
                           shouldCreate:(BOOL)create;

- (CDOperationQueue *)createQueueWithName:(NSString *)queueName;

@end
