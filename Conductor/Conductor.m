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
#import <mach/mach_time.h>

@interface Conductor ()
@property (nonatomic, readwrite, strong) NSMutableDictionary *queues;
@end

@implementation Conductor

@synthesize queues;

- (void)dealloc {
    [self cancelAllOperations];
}

- (id)init {
    self = [super init];
    if (self) {
        self.queues = [[NSMutableDictionary alloc] init];
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

- (void)removeQueue:(CDOperationQueue *)queue {
    if (queue.isExecuting) return;
    if (![self.queues objectForKey:queue.name]) return;
    ConductorLogTrace(@"Removing queue: %@", queue.name);
    [self.queues removeObjectForKey:queue.name];
}

#pragma mark - Operations

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
    
    ConductorLogTrace(@"Adding operation to queue: %@", queue.name);
    
    // Add and start operation
    [queue addOperation:operation atPriority:priority];
}

- (BOOL)updatePriorityOfOperationWithIdentifier:(NSString *)identifier 
                                  toNewPriority:(NSOperationQueuePriority)priority {
    
    __block BOOL didUpdate = NO;
    
    [self.queues enumerateKeysAndObjectsUsingBlock:^(id queueName, CDOperationQueue *queue, BOOL *stop) {
        if ([queue updatePriorityOfOperationWithIdentifier:queue toNewPriority:priority]) {
            didUpdate = YES;
            *stop = YES;
        }
    }];

    return didUpdate;
}

#pragma mark - Queue States

- (void)cancelAllOperations {
    ConductorLogTrace(@"Cancel all operations");
    for (NSString *queueName in self.queues) {
        [self cancelAllOperationsInQueueNamed:queueName];
    }
}

- (void)cancelAllOperationsInQueueNamed:(NSString *)queueName {
    if (!queueName) return;
    ConductorLogTrace(@"Cancel all operations in queue: %@", queueName);
    CDOperationQueue *queue = [self getQueueNamed:queueName];
    [queue cancelAllOperations];
    [self removeQueue:queue];
}

- (void)suspendAllQueues {
    ConductorLogTrace(@"Suspend all queues");
    for (NSString *queueName in self.queues) {
        [self suspendQueueNamed:queueName];
    }
}

- (void)suspendQueueNamed:(NSString *)queueName {
    if (!queueName) return;
    ConductorLogTrace(@"Suspend queue: %@", queueName);
    CDOperationQueue *queue = [self getQueueNamed:queueName];;
    [queue setSuspended:YES];
}

- (void)resumeAllQueues {
    ConductorLogTrace(@"Resume all queues");
    for (NSString *queueName in self.queues) {
        [self resumeQueueNamed:queueName];
    }    
}

- (void)resumeQueueNamed:(NSString *)queueName {
    if (!queueName) return;
    ConductorLogTrace(@"Resume queue: %@", queueName);
    CDOperationQueue *queue = [self getQueueNamed:queueName];;
    [queue setSuspended:NO];    
}

#pragma mark - CDOperationQueueDelegate

- (void)queueDidFinish:(CDOperationQueue *)queue {
    [self removeQueue:queue];
}

#pragma mark - Queue Progress

- (void)addProgressWatcherToQueueNamed:(NSString *)queueName 
                     withProgressBlock:(CDOperationQueueProgressWatcherProgressBlock)progressBlock 
                    andCompletionBlock:(CDOperationQueueProgressWatcherCompletionBlock)completionBlock {
        
    CDOperationQueue *queue = [self queueForQueueName:queueName shouldCreate:YES];
    
    [queue addProgressWatcherWithProgressBlock:progressBlock 
                            andCompletionBlock:completionBlock];
}

- (void)removeProgressWatcherForQueueNamed:(NSString *)queueName {
    CDOperationQueue *queue = [self getQueueNamed:queueName];;
    if (!queue) return;

    ConductorLogTrace(@"Removing progress watcher from queue %@", queueName);
    
    [queue removeProgressWatcher];
}

#pragma mark - Queue

- (NSArray *)allQueueNames {
    return [self.queues allKeys];
}

- (BOOL)hasQueues {
    return (self.queues.count > 0);
}

#pragma mark - KVO

//- (void)observeValueForKeyPath:(NSString *)keyPath 
//                      ofObject:(id)object 
//                        change:(NSDictionary *)change 
//                       context:(void *)context {
//    
//    // isFinished
//    if ([keyPath isEqualToString:@"isFinished"] && [object isKindOfClass:[CDOperationQueue class]]) {
//        CDOperationQueue *queue = (CDOperationQueue *)object;
//        [self queueDidFinish:queue];
//    }
//    
//}

#pragma mark - Accessors

- (BOOL)isExecuting {

    __block BOOL isExecuting = NO;

    [self.queues enumerateKeysAndObjectsUsingBlock:^(id queueName, CDOperationQueue *queue, BOOL *stop) {
        if (queue.isExecuting) {
            isExecuting = YES;
            *stop = YES;
        }
    }];

    return isExecuting;
}

#pragma mark - Private

- (NSString *)queueNameForOperation:(NSOperation *)operation {
    if (!operation) return nil;
    NSString *className = NSStringFromClass([operation class]);
    
//    uint64_t absolute_time = mach_absolute_time();
//    mach_timebase_info_data_t timebase;
//    mach_timebase_info(&timebase);
//    uint64_t nanoseconds = (double)absolute_time * (double)timebase.numer / (double)timebase.denom;

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
    
    id queue = [self.queues objectForKey:queueName];
    
    if (!queue && create) {
        queue = [self createQueueWithName:queueName];
    }
    
    return (CDOperationQueue *)queue;
}

- (CDOperationQueue *)createQueueWithName:(NSString *)queueName {
    if (!queueName) return nil;
    
    ConductorLogTrace(@"Creating queue: %@", queueName);
    
    CDOperationQueue *queue = [CDOperationQueue queueWithName:queueName];
    queue.delegate = self;
    
//    [queue addObserver:self
//            forKeyPath:@"isFinished" 
//               options:NSKeyValueObservingOptionNew 
//               context:nil];

    [self.queues setObject:queue forKey:queueName];
    
    return queue;
}

@end
