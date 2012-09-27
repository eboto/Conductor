//
//  CDOperationQueueProgressWatcher.m
//  Conductor
//
//  Created by Andrew Smith on 4/30/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDOperationQueueProgressObserver.h"

@implementation CDOperationQueueProgressObserver

+ (CDOperationQueueProgressObserver *)progressObserverWithStartingOperationCount:(NSInteger)operationCount
                                                                 progressBlock:(CDOperationQueueProgressObserverProgressBlock)progressBlock 
                                                            andCompletionBlock:(CDOperationQueueProgressObserverCompletionBlock)completionBlock
{    
    CDOperationQueueProgressObserver *watcher = [[self alloc] init];
    watcher.startingOperationCount = operationCount;
    watcher.progressBlock = progressBlock;
    watcher.completionBlock = completionBlock;
    
    return watcher;
}

- (void)runProgressBlockWithCurrentOperationCount:(NSNumber *)operationCount
{
    if (!self.progressBlock) return;
    
    NSAssert(!(self.startingOperationCount <= 0), @"Starting operation count was 0 or less than 0!  Initialize the watcher with a operation count of larger than 0.");
    if (self.startingOperationCount <= 0) return;
        
    // Calculate percentage progress
    float progress = (float)(self.startingOperationCount - [operationCount intValue]) / (float)self.startingOperationCount;
    
    // If operation count is larger than starting operation count, mark progress
    // as 0.  This shouldn't happen, the starting operation count should be updated
    // as operations are added.
    if (progress < 0) progress = 0.0;
    
    self.progressBlock(progress);
}

- (void)runCompletionBlock
{
    if (!self.completionBlock) return;
    self.completionBlock();
}

- (void)addToStartingOperationCount:(NSNumber *)numberToAdd
{
    self.startingOperationCount += [numberToAdd intValue];
}

@end
