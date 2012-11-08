//
//  CDOperationQueue.m
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

#import "CDOperationQueue.h"
#import "CDOperationQueue+Max.h"

@interface CDOperationQueue ()


- (void)operationDidFinish:(CDOperation *)operation;

@end

@implementation CDOperationQueue

- (void)dealloc
{
    _delegate = nil;
    _operationsObserver = nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        _queue                    = [[NSOperationQueue alloc] init];
        _operations               = [[NSMutableDictionary alloc] init];
        _progressWatchers         = [[NSMutableSet alloc] init];
        self.maxQueuedOperationsCount = CDOperationQueueCountMax;
    }
    return self;
}

+ (id)queueWithName:(NSString *)queueName
{
    CDOperationQueue *q = [[self alloc] init];
    q.queue.name = queueName;
    return q;
}

- (void)queueDidFinish
{
    [self.progressWatchers makeObjectsPerformSelector:@selector(runCompletionBlock)];
    [self.delegate queueDidFinish:self];
}

#pragma mark - Operations API

- (void)addOperation:(CDOperation *)operation
{
    [self addOperation:operation atPriority:operation.queuePriority];
}

- (void)addOperation:(CDOperation *)operation 
          atPriority:(NSOperationQueuePriority)priority
{    
    if (![operation isKindOfClass:[CDOperation class]]) {
        NSAssert(nil, @"You must use a CDOperation sublcass with Conductor!");
        return;
    }
    
    // Add operation to operations dict
    @synchronized (self.operations) {
        
        // Check to see if operation already exists
        if ([self getOperationWithIdentifier:operation.identifier] != nil) {
            ConductorLogTrace(@"Already has operation with identifier %@. Uniquifiying this one.", operation.identifier);
            operation.identifier = [[NSProcessInfo processInfo] globallyUniqueString];
        }
        
        // Add operation to dict
        [self.operations setObject:operation 
                            forKey:operation.identifier];
        
        // set priority
        [operation setQueuePriority:priority];
        
        // Update progress watcher count
        [self.progressWatchers makeObjectsPerformSelector:@selector(addToStartingOperationCount:)
                                               withObject:@1];
        
        operation.delegate = self;
        
        // Add operation to queue and start
        [self.queue addOperation:operation];
        
        if (self.maxQueueOperationCountReached) {
            if ([self.operationsObserver respondsToSelector:@selector(maxQueuedOperationsReachedForQueue:)]) {
                [self.operationsObserver maxQueuedOperationsReachedForQueue:self];
            }
            return;
        }
    }
}

- (void)removeOperation:(CDOperation *)operation
{
    if (![self.operations objectForKey:operation.identifier]) return;
    
    @synchronized (self.operations) {

        ConductorLogTrace(@"Removing operation %@ from queue %@", operation.identifier, self.name);
        
        [self.operations removeObjectForKey:operation.identifier];

        [self.progressWatchers makeObjectsPerformSelector:@selector(runProgressBlockWithCurrentOperationCount:)
                                               withObject:@(self.operationCount)];
    }
}

- (void)cancelAllOperations
{
    /** 
     This method sends a cancel message to all operations currently in the queue. 
     Queued operations are cancelled before they begin executing. If an operation 
     is already executing, it is up to that operation to recognize the cancellation 
     and stop what it is doing.  Cancelled operations still call start, then should
     immediately respond to the cancel request.
    */
    [self.queue cancelAllOperations];
        
    /**
     Allow NSOperation queue to start operations and clear themselves out.
     They will all be marked as canceled, and if you build your sublcass
     correctly, they will exit properly.
     */
    [self setSuspended:NO];

}

- (void)operationDidFinish:(CDOperation *)operation
{
    [self removeOperation:operation];
    
    if (!self.maxQueueOperationCountReached) {
        if ([self.operationsObserver respondsToSelector:@selector(canBeginSubmittingOperationsForQueue:)]) {
            [self.operationsObserver canBeginSubmittingOperationsForQueue:self];
        }
    }
    
    if (self.operationCount == 0) {
        [self queueDidFinish];
    }
}

#pragma mark - State

- (BOOL)isExecuting
{
    return (self.operationCount > 0);
}

- (BOOL)isFinished
{
    return (self.operationCount == 0);
}

- (BOOL)isSuspended
{
    return self.queue ? self.queue.isSuspended : NO;
}

- (void)setSuspended:(BOOL)suspend
{
    [self.queue setSuspended:suspend];
}


#pragma mark - Priority

- (BOOL)updatePriorityOfOperationWithIdentifier:(id)identifier 
                                  toNewPriority:(NSOperationQueuePriority)priority
{
    CDOperation *op = [self getOperationWithIdentifier:identifier];
    
    // These tests are probably not necessry, just thrown in for extra safety
    if (op && ![op isExecuting] && ![op isCancelled] && ![op isFinished]) {
        [op setQueuePriority:priority];
        return YES;
    }
    
    return NO;
}

#pragma mark - Progress

- (void)addProgressObserverWithProgressBlock:(CDOperationQueueProgressObserverProgressBlock)progressBlock
                         andCompletionBlock:(CDOperationQueueProgressObserverCompletionBlock)completionBlock
{       
    ConductorLogTrace(@"Adding progress watcher to queue %@", self.name);
    
    CDOperationQueueProgressObserver *watcher = [CDOperationQueueProgressObserver progressObserverWithStartingOperationCount:self.operationCount
                                                                                                            progressBlock:progressBlock
                                                                                                       andCompletionBlock:completionBlock];
    [self.progressWatchers addObject:watcher];
}

#pragma mark - Accessors

- (NSString *)name
{
    return self.queue ? self.queue.name : nil;
}

- (NSUInteger)operationCount
{
    return self.operations.count;
}

- (CDOperation *)getOperationWithIdentifier:(id)identifier
{
    CDOperation *op = [self.operations objectForKey:identifier];
    return op;
}

@end
