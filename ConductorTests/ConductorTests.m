//
//  ConductorTests.m
//  ConductorTests
//
//  Created by Andrew Smith on 10/21/11.
//  Copyright (c) 2011 Posterous. All rights reserved.
//

#import "ConductorTests.h"

#import "Conductor.h"
#import "CDOperationQueue.h"
#import "CDOperation.h"

#import "CDTestOperation.h"

@implementation ConductorTests

- (void)setUp {
    [super setUp];
    testOperationQueue = [[CDOperationQueue alloc] init];
    [testOperationQueue.queue setMaxConcurrentOperationCount:1];
}

- (void)tearDown {    
    [super tearDown];
    [testOperationQueue release], testOperationQueue = nil;
}

- (void)testRunTestOperation {

    __block BOOL hasFinished = NO;
    
    void (^completionBlock)(void) = ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            hasFinished = YES;        
        });
    };         
    
    CDTestOperation *op = [[CDTestOperation alloc] initWithIdentifier:@"1234"];
    op.completionBlock = completionBlock;
    
    NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
    [queue addOperation:op];
    [op release];

    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:5];
    while (hasFinished == NO) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }    
    
    STAssertTrue(hasFinished, @"Test operation should run");
}

- (void)testAddOperationToQueue {
    
    __block BOOL hasFinished = NO;
    
    void (^completionBlock)(void) = ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            hasFinished = YES;        
        });
    };         
    
    CDTestOperation *op = [[CDTestOperation alloc] initWithIdentifier:@"1234"];
    op.completionBlock = completionBlock;
    
    [testOperationQueue addOperation:op];
    [op release];

    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:5];
    while (hasFinished == NO) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }    
        
    STAssertTrue(hasFinished, @"Test operation queue should finish");
}

- (void)testChangeOperationPriority {
    
    __block BOOL hasFinished = NO;
    
    void (^completionBlock)(void) = ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            hasFinished = YES;        
        });
    };     
    
    CDTestOperation *op = [[CDTestOperation alloc] initWithIdentifier:@"1234"];
    op.completionBlock = completionBlock;
    
    [testOperationQueue addOperation:op];
    [op release];
    
    [testOperationQueue updatePriorityOfOperationWithIdentifier:@"1234" 
                                                  toNewPriority:NSOperationQueuePriorityVeryLow];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:5];
    while (hasFinished == NO) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    } 
    
    STAssertEquals(op.queuePriority, NSOperationQueuePriorityVeryLow, @"Operation should have correct priority");
}

- (void)testChangeOperationPriorityFinishOrder {
    
    __block BOOL hasFinished = NO;
    
    __block NSDate *last = nil;
    __block NSDate *first = nil;
    
    void (^finishLastBlock)(void) = ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            hasFinished = YES;
            last = [[NSDate date] retain];
        });
    };    
    
    void (^finishFirstBlock)(void) = ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            first = [[NSDate date] retain];
        });
    };    
    
    CDTestOperation *finishLast = [[CDTestOperation alloc] initWithIdentifier:@"1"];
    finishLast.completionBlock = finishLastBlock;
    
    CDTestOperation *op = [[CDTestOperation alloc] initWithIdentifier:@"2"];
    
    CDTestOperation *finishFirst = [[CDTestOperation alloc] initWithIdentifier:@"3"];
    finishFirst.completionBlock = finishFirstBlock;
    
    [testOperationQueue addOperation:finishLast], [finishLast release];
    [testOperationQueue addOperation:op], [op release];
    [testOperationQueue addOperation:finishFirst], [finishFirst release];
    
    [testOperationQueue updatePriorityOfOperationWithIdentifier:@"3" 
                                                  toNewPriority:NSOperationQueuePriorityVeryHigh];
    
    [testOperationQueue updatePriorityOfOperationWithIdentifier:@"1" 
                                                  toNewPriority:NSOperationQueuePriorityVeryLow];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:5];
    while (hasFinished == NO) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }    
        
    float firstInt = [first timeIntervalSinceNow];
    float lastInt  = [last timeIntervalSinceNow];
        
    STAssertTrue((firstInt < lastInt), @"Operation should finish first");
}

@end
