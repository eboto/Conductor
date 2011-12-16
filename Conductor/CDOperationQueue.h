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

@interface CDOperationQueue : NSObject {
@private
    NSOperationQueue *queue;
    NSString *name;
    NSMutableDictionary *operations;
}

/**
 * Holds the operation queue
 */
@property (weak, nonatomic, readonly) NSOperationQueue *queue;

/**
 * User set name of the queue
 */
@property (nonatomic, copy) NSString *name;

/**
 * Dictionary of all CDOperations in the queue, where the key is the operations 
 * identifier and the object is the operation
 */
@property (weak, nonatomic, readonly) NSMutableDictionary *operations;

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
