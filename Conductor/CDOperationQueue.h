//
//  CDOperationQueue.h
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

#import "CDOperation.h"
#import "CDOperationQueueProgressWatcher.h"

@protocol CDOperationQueueDelegate;

@interface CDOperationQueue : NSObject {}

@property (nonatomic, weak) id <CDOperationQueueDelegate> delegate;

/**
 * Holds the operation queue
 */
@property (nonatomic, readonly, strong) NSOperationQueue *queue;

/**
 * Dictionary of all CDOperations in the queue, where the key is the operations 
 * identifier and the object is the operation
 */
@property (nonatomic, readonly, strong) NSMutableDictionary *operations;

/**
 The name of the internal NSOperationQueue
 */
@property (nonatomic, readonly) NSString *name;

/**
 The number of operations in the queue.  Wrapper around the operationsCount
 of the internal NSOperationQueue
 */
@property (nonatomic, readonly) NSInteger operationCount;

@property (nonatomic, readonly, strong) NSMutableSet *progressWatchers;

+ (id)queueWithName:(NSString *)queueName;

/**
 * Add an operation to the queue.
 */
- (void)addOperation:(CDOperation *)operation;

/**
 * Add an operation and specify the priority
 */
- (void)addOperation:(CDOperation *)operation 
          atPriority:(NSOperationQueuePriority)priority;

/**
 * Update the priority of a given operation, as long as it currently running or
 * already finished.
 */
- (BOOL)updatePriorityOfOperationWithIdentifier:(id)identifier 
                                  toNewPriority:(NSOperationQueuePriority)priority;

/**
 Pauses internal NSOperationQueue
 */
- (void)setSuspended:(BOOL)suspend;

/**
 Cancel all operations in internal NSOperatioQueue
 */
- (void)cancelAllOperations;

/**
 State queries
 */
- (BOOL)isExecuting;
- (BOOL)isFinished;
- (BOOL)isSuspended;

/**
 * Retrieve an operation with a given identifier.  Returns nil if operation has
 * already finished.
 */
- (CDOperation *)getOperationWithIdentifier:(id)identifier;

/**
 
 */
- (void)addProgressWatcherWithProgressBlock:(CDOperationQueueProgressWatcherProgressBlock)progressBlock
                         andCompletionBlock:(CDOperationQueueProgressWatcherCompletionBlock)completionBlock;


@end

@protocol CDOperationQueueDelegate <NSObject>
- (void)queueDidFinish:(CDOperationQueue *)queue;
@end
