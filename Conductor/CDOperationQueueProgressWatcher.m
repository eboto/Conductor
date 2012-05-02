//
//  CDOperationQueueProgressWatcher.m
//  Conductor
//
//  Created by Andrew Smith on 4/30/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDOperationQueueProgressWatcher.h"

@implementation CDOperationQueueProgressWatcher

@synthesize progressBlock,
            completionBlock;

//+ (CDOperationQueueProgressWatcher *)addWatcherToQueue:(CDOperationQueue *)queue
//                                     withProgressBlock:(CDOperationQueueProgressWatcherProgressBlock)progressBlock 
//                                    andCompletionBlock:(CDOperationQueueProgressWatcherCompletionBlock)completionBlock {
//    
//    CDOperationQueueProgressWatcher *watcher = [[self alloc] init];
//    watcher.progressBlock = progressBlock;
//    watcher.completionBlock = completionBlock;
//    
//    return watcher;
//}

- (void)runProgressBlock {
    if (!self.progressBlock) return;
    
    float remainingOperations = 0.5;// self.watchedQueue ? self.watchedQueue.operationsCount : 0.0;
    
    
    
    self.progressBlock(remainingOperations);
}

- (void)runCompletionBlock {
    if (self.completionBlock) return;
    self.completionBlock();
}

@end
