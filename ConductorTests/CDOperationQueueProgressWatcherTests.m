//
//  CDOperationQueueProgressWatcherTests.m
//  Conductor
//
//  Created by Andrew Smith on 5/2/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDOperationQueueProgressWatcherTests.h"

#import "CDOperationQueueProgressWatcher.h"
#import "CDTestOperation.h"
#import "CDLongRunningTestOperation.h"

@implementation CDOperationQueueProgressWatcherTests

- (void)testCreateWatcher {
    CDOperationQueueProgressWatcher *watcher = [CDOperationQueueProgressWatcher progressWatcherWithStartingOperationCount:10
                                                                                                            progressBlock:nil
                                                                                                       andCompletionBlock:nil];
    
    STAssertNotNil(watcher, @"Should create watcher");
    STAssertEquals(watcher.startingOperationCount, 10, @"Should have correct number of operations");
}

- (void)testRunWatcherProgressBlock {
    
    __block float progressIndicator = 0.0f;
    
    CDOperationQueueProgressWatcherProgressBlock progressBlock = ^(float progress) {
        progressIndicator = progress;
    };
    
    CDOperationQueueProgressWatcher *watcher = [CDOperationQueueProgressWatcher progressWatcherWithStartingOperationCount:10
                                                                                                            progressBlock:progressBlock
                                                                                                       andCompletionBlock:nil];
    
    [watcher runProgressBlockWithCurrentOperationCount:1];
        
    STAssertEqualsWithAccuracy(progressIndicator, 0.9f, 0.000001f, @"Progress block should run correctly");
}

- (void)testRunWatcherCompletionBlock {
    
    __block BOOL completionBlockDidRun = NO;
    
    CDOperationQueueProgressWatcherCompletionBlock completionBlock = ^(void) {
        completionBlockDidRun = YES;
    };
    
    CDOperationQueueProgressWatcher *watcher = [CDOperationQueueProgressWatcher progressWatcherWithStartingOperationCount:10
                                                                                                            progressBlock:nil
                                                                                                       andCompletionBlock:completionBlock];
    
    [watcher runCompletionBlock];
    
    STAssertTrue(completionBlockDidRun, @"Completion block should run correctly");
}

- (void)testStartingOperationCount {
    CDLongRunningTestOperation *op1 = [CDLongRunningTestOperation operation];
    CDLongRunningTestOperation *op2 = [CDLongRunningTestOperation operation];    
    CDLongRunningTestOperation *op3 = [CDLongRunningTestOperation operation];    
    
    [testOperationQueue addOperation:op1];
    [testOperationQueue addOperation:op2];
    [testOperationQueue addOperation:op3];
    
    [testOperationQueue addProgressWatcherWithProgressBlock:nil andCompletionBlock:nil];
    
    STAssertEquals(testOperationQueue.progressWatcher.startingOperationCount, 3, @"Progress watcher should have correct starting operation count");    
}

- (void)testAddToStartingOperationCount {
    CDLongRunningTestOperation *op1 = [CDLongRunningTestOperation operation];
    CDLongRunningTestOperation *op2 = [CDLongRunningTestOperation operation];    
    CDLongRunningTestOperation *op3 = [CDLongRunningTestOperation operation];    
    CDLongRunningTestOperation *op4 = [CDLongRunningTestOperation operation];    

    [testOperationQueue addOperation:op1];
    [testOperationQueue addOperation:op2];
    [testOperationQueue addOperation:op3];
    
    [testOperationQueue addProgressWatcherWithProgressBlock:nil andCompletionBlock:nil];
    
    [testOperationQueue addOperation:op4];
    
    STAssertEquals(testOperationQueue.progressWatcher.startingOperationCount, 4, @"Progress watcher should have correct starting operation count");    
}

- (void)testRunWatcherProgressAndCompletionBlocks {
    CDTestOperation *op1 = [CDTestOperation operation];
    CDTestOperation *op2 = [CDTestOperation operation];
    CDTestOperation *op3 = [CDTestOperation operation];
    
    [testOperationQueue addOperation:op1];
    [testOperationQueue addOperation:op2];
    [testOperationQueue addOperation:op3];
    
    __block float progressIndicator = 0.0f;
    
    CDOperationQueueProgressWatcherProgressBlock progressBlock = ^(float progress) {
        progressIndicator = progress;
    };
    
    __block BOOL completionBlockDidRun = NO;
    
    CDOperationQueueProgressWatcherCompletionBlock completionBlock = ^(void) {
        completionBlockDidRun = YES;
    };
    
    [testOperationQueue addProgressWatcherWithProgressBlock:progressBlock 
                                         andCompletionBlock:completionBlock];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.2];
    while (testOperationQueue.isExecuting) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    } 
    
    STAssertTrue(completionBlockDidRun, @"Completion block should run");
    STAssertEquals(progressIndicator, 1.0f, @"Progress block should run correctly");
}

@end
