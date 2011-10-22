//
//  CDOperationQueue.h
//  Conductor
//
//  Created by Andrew Smith on 10/21/11.
//  Copyright (c) 2011 Posterous. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CDOperation.h"

@interface CDOperationQueue : NSObject {
@private
    NSOperationQueue *queue;
    NSString *name;
    NSMutableDictionary *operations;
}

@property (nonatomic, readonly) NSOperationQueue *queue;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, readonly) NSMutableDictionary *operations;

- (void)addOperation:(NSOperation *)operation;

- (void)addOperation:(NSOperation *)operation 
          atPriority:(NSOperationQueuePriority)priority;

- (CDOperation *)getOperationWithIdentifier:(id)identifier;

- (void)updatePriorityOfOperationWithIdentifier:(id)identifier 
                                  toNewPriority:(NSOperationQueuePriority)priority;

- (BOOL)isRunning;

@end
