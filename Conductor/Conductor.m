//
//  Conductor.m
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

#import "Conductor.h"

@interface Conductor ()
@property (nonatomic, readwrite, strong) NSMutableDictionary *queuesDict;
@end

@implementation Conductor

@synthesize queuesDict;

- (id)init {
    self = [super init];
    if (self) {
        self.queuesDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (id)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedInstance = nil;
    dispatch_once(&pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Queue Control

- (void)addOperation:(CDOperation *)operation {
    [self addOperation:operation atPriority:operation.queuePriority];
}

- (void)addOperation:(CDOperation *)operation 
          atPriority:(NSOperationQueuePriority)priority {
    
    NSString *queueName = [self queueNameForOperation:operation];
    
    [self addOperation:operation
          toQueueNamed:queueName
            atPriority:priority];
    
}

- (void)addOperation:(CDOperation *)operation 
        toQueueNamed:(NSString *)queueName {
        
    [self addOperation:operation 
          toQueueNamed:queueName 
            atPriority:operation.queuePriority];
    
}

- (void)addOperation:(CDOperation *)operation 
        toQueueNamed:(NSString *)queueName 
          atPriority:(NSOperationQueuePriority)priority {
    
    CDOperationQueue *queue = nil;
    
    if (queueName) {
        queue = [self queueForQueueName:queueName shouldCreate:YES];
    } else {
        queue = [self queueForOperation:operation shouldCreate:YES];
    }
        
    [queue addOperation:operation atPriority:priority];
}

- (BOOL)updatePriorityOfOperationWithIdentifier:(NSString *)identifier 
                                  toNewPriority:(NSOperationQueuePriority)priority {
    
    __block BOOL didUpdate = NO;
    
    [self.queuesDict enumerateKeysAndObjectsUsingBlock:^(id queueName, CDOperationQueue *queue, BOOL *stop) {
        if ([queue updatePriorityOfOperationWithIdentifier:queue toNewPriority:priority]) {
            didUpdate = YES;
            *stop = YES;
        }
    }];

    return didUpdate;
}

#pragma mark - Queue States

- (void)cancelAllOperations {
    for (NSString *queueName in self.queuesDict) {
        [self cancelAllOperationsInQueueNamed:queueName];
    }
}

- (void)cancelAllOperationsInQueueNamed:(NSString *)queueName {
    if (!queueName) return;
    CDOperationQueue *queue = [self getQueueNamed:queueName];;
    [queue cancelAllOperations];
}

- (void)suspendAllQueues {
    for (NSString *queueName in self.queuesDict) {
        [self suspendQueueNamed:queueName];
    }
}

- (void)suspendQueueNamed:(NSString *)queueName {
    if (!queueName) return;
    CDOperationQueue *queue = [self getQueueNamed:queueName];;
    [queue setSuspended:YES];
}

- (void)resumeAllQueues {
    for (NSString *queueName in self.queuesDict) {
        [self resumeQueueNamed:queueName];
    }    
}

- (void)resumeQueueNamed:(NSString *)queueName {
    if (!queueName) return;
    CDOperationQueue *queue = [self getQueueNamed:queueName];;
    [queue setSuspended:NO];    
}

#pragma mark - Queue Progress

- (void)addProgressWatcherToQueueNamed:(NSString *)queueName 
                     withProgressBlock:(CDOperationQueueProgressWatcherProgressBlock)progressBlock 
                    andCompletionBlock:(CDOperationQueueProgressWatcherCompletionBlock)completionBlock {
    
    CDOperationQueue *queue = [self getQueueNamed:queueName];;
    if (!queue) return;

    [queue addProgressWatcherWithProgressBlock:progressBlock 
                            andCompletionBlock:completionBlock];
}

- (void)removeProgressWatcherForQueueNamed:(NSString *)queueName {
    CDOperationQueue *queue = [self getQueueNamed:queueName];;
    if (!queue) return;

    [queue removeProgressWatcher];
}

#pragma mark - Queue

- (NSArray *)allQueueNames {
    return [self.queuesDict allKeys];
}

#pragma mark - Accessors

- (BOOL)isRunning {

    __block BOOL isRunning = NO;

    [self.queuesDict enumerateKeysAndObjectsUsingBlock:^(id queueName, CDOperationQueue *queue, BOOL *stop) {
        if (queue.isRunning) {
            isRunning = YES;
            *stop = YES;
        }
    }];

    return isRunning;
}

#pragma mark - Private

- (NSString *)queueNameForOperation:(NSOperation *)operation {
    if (!operation) return nil;
    NSString *className = NSStringFromClass([operation class]);
    return [NSString stringWithFormat:@"%@_operation_queue", className];
}

- (CDOperationQueue *)queueForOperation:(NSOperation *)operation
                           shouldCreate:(BOOL)create {
    
    NSString *queueName = [self queueNameForOperation:operation];
    return [self queueForQueueName:queueName shouldCreate:create];
}

- (CDOperationQueue *)getQueueForOperation:(NSOperation *)operation {
    NSString *queueName = [self queueNameForOperation:operation];
    return [self getQueueNamed:queueName];    
}

- (CDOperationQueue *)getQueueNamed:(NSString *)queueNamed {
    return [self queueForQueueName:queueNamed shouldCreate:NO];
}

- (CDOperationQueue *)queueForQueueName:(NSString *)queueName 
                           shouldCreate:(BOOL)create {
    if (!queueName) return nil;
    
    id queue = [self.queuesDict objectForKey:queueName];
    
    if (!queue && create) {
        queue = [self createQueueWithName:queueName];
    }
    
    return (CDOperationQueue *)queue;
}

- (CDOperationQueue *)createQueueWithName:(NSString *)queueName {
    if (!queueName) return nil;
    CDOperationQueue *queue = [CDOperationQueue queueWithName:queueName];
    [self.queuesDict setObject:queue forKey:queueName];
    return queue;
}

@end
