//
//  Conductor.h
//  Conductor
//
//  Created by Andrew Smith on 10/21/11.
//  Copyright (c) 2011 Andrew B. Smith ( http://github.com/drewsmits ). All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal 
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
// of the Software, and to permit persons to whom the Software is furnished to do so, 
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included 
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>

#import "CDOperationQueue.h"
#import "CDOperationQueueProgressWatcher.h"

@interface Conductor : NSObject <CDOperationQueueDelegate> {}

@property (nonatomic, readonly, strong) NSMutableDictionary *queues;

/**
 Singleton Conductor instance
 */
+ (id)sharedInstance;

/**
 Creates a queue based on the operations class name and adds the operation to
 it.  Will not create a new operation queue if one by that name already exists.
 Returns the operation identifier.
 
 @see queueNameForOperation:
 */
- (void)addOperation:(CDOperation *)operation;

/**
 Creates a queue based on the operations class name and adds the operation to
 it at the given priority.  Will not create a new operation queue if the one
 by that name already exists.  Returns the operation identifer.
 
 @see queueNameForOperation:
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
 Adds progress watcher to queue
 */
- (void)addProgressWatcherToQueueNamed:(NSString *)queueName
                     withProgressBlock:(CDOperationQueueProgressWatcherProgressBlock)progressBlock
                    andCompletionBlock:(CDOperationQueueProgressWatcherCompletionBlock)completionBlock;


/**
 Remove progress watcher for queue
 */
- (void)removeProgressWatcherForQueueNamed:(NSString *)queueName;

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
 Suspends all the operation queues.
 */
- (void)suspendAllQueues;

/**
 Suspends a specific queue
 */
- (void)suspendQueueNamed:(NSString *)queueName;

/**
 Resumes any suspended queues
 */
- (void)resumeAllQueues;

/**
 Resumes a specific queue
 */
- (void)resumeQueueNamed:(NSString *)queueName;

/**
 * List of all queue names
 */
- (NSArray *)allQueueNames;

/**
 Queries all queues to see if any are running.
 */
- (BOOL)isExecuting;

/**
 Queries whether the conductor instance has queues.  Mostly useful for async
 tests.
 */
- (BOOL)hasQueues;

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
 Returns the queue for the operation.
 */
- (CDOperationQueue *)getQueueForOperation:(NSOperation *)operation;


/**
 * Returns the queue for the given name
 */
- (CDOperationQueue *)queueForQueueName:(NSString *)queueName 
                           shouldCreate:(BOOL)create;

- (CDOperationQueue *)getQueueNamed:(NSString *)queueNamed;

- (CDOperationQueue *)createQueueWithName:(NSString *)queueName;

@end
