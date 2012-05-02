//
//  CDOperationQueueProgressWatcher.m
//  Conductor
//
//  Created by Andrew Smith on 4/30/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDOperationQueueProgressWatcher.h"

@implementation CDOperationQueueProgressWatcher

@synthesize startingOperationCount,
            progressBlock,
            completionBlock;

+ (CDOperationQueueProgressWatcher *)progressWatcherWithStartingOperationCount:(NSInteger)operationCount
                                                                 progressBlock:(CDOperationQueueProgressWatcherProgressBlock)progressBlock 
                                                            andCompletionBlock:(CDOperationQueueProgressWatcherCompletionBlock)completionBlock {
    
    CDOperationQueueProgressWatcher *watcher = [[self alloc] init];
    watcher.startingOperationCount = operationCount;
    watcher.progressBlock = progressBlock;
    watcher.completionBlock = completionBlock;
    
    return watcher;
}

- (void)runProgressBlockWithCurrentOperationCount:(NSInteger)operationCount {
    if (!self.progressBlock) return;
    
    NSAssert(self.startingOperationCount <= 0, @"Starting operation count was 0 or less than 0!  Initialize the watcher with a operation count of larger than 0.");
    if (self.startingOperationCount <= 0) return;

    // Calculate percentage progress
    float progress = (float)startingOperationCount - (float)operationCount / (float)startingOperationCount;
    
    // If operation count is larger than starting operation count, mark progress
    // as 0.  This shouldn't happen, the starting operation count should be updated
    // as operations are added.
    if (progress < 0) progress = 0.0;
    
    self.progressBlock(progress);
}

- (void)runCompletionBlock {
    if (self.completionBlock) return;
    self.completionBlock();
}

- (void)addToStartingOperationCount:(NSInteger)numberToAdd {
    self.startingOperationCount += numberToAdd;
}

@end
