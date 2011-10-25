//
//  Conductor+Private.h
//  Conductor
//
//  Created by Andrew Smith on 10/24/11.
//  Copyright (c) 2011 Andrew B. Smith. All rights reserved.
//

#import "Conductor.h"
#import "CDOperationQueue.h"

@interface Conductor (Private)

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
