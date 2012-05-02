//
//  ConductorTests.m
//  ConductorTests
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

#import "ConductorTests.h"

#import "CDOperation.h"
#import "CDTestOperation.h"
#import "CDLongRunningTestOperation.h"

@implementation ConductorTests

- (void)setUp {
    [super setUp];
    
    testOperationQueue = [[CDOperationQueue alloc] init];
    [testOperationQueue.queue setMaxConcurrentOperationCount:1];

    conductor = [[Conductor alloc] init];
}

- (void)tearDown {    
    [super tearDown];

    [testOperationQueue release], testOperationQueue = nil;
    [conductor release], conductor = nil;
}

#pragma mark - CDOperation

- (void)testCreateOperationWithIdentifier {
    CDOperation *op = [CDOperation operationWithIdentifier:@"1234"];
    STAssertEqualObjects(op.identifier, @"1234", @"Operation should have correct identifier");
}

- (void)testCreateOperationWithoutIdentifier {
    CDOperation *op = [CDOperation operation];
    STAssertNotNil(op.identifier, @"Operation should have an identifier");
}

- (void)testRunTestOperation {

    __block BOOL hasFinished = NO;
    
    void (^completionBlock)(void) = ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            hasFinished = YES;        
        });
    };         
    
    CDTestOperation *op = [CDTestOperation operation];
    op.completionBlock = completionBlock;
    
    NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
    [queue addOperation:op];

    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:1];
    while (hasFinished == NO) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }    
    
    STAssertTrue(hasFinished, @"Test operation should run");
}

#pragma mark - CDOperationQueue

- (void)testAddOperationToQueue {
    
    __block BOOL hasFinished = NO;
    
    void (^completionBlock)(void) = ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            hasFinished = YES;        
        });
    };         
    
    CDTestOperation *op = [CDTestOperation operation];
    op.completionBlock = completionBlock;
    
    [testOperationQueue addOperation:op];

    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:1];
    while (hasFinished == NO) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }    
        
    STAssertTrue(hasFinished, @"Test operation queue should finish");
}

- (void)testAddOperationToQueueAtPriority {
    
    __block BOOL hasFinished = NO;
    
    void (^completionBlock)(void) = ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            hasFinished = YES;        
        });
    };         
    
    CDTestOperation *op = [CDTestOperation operation];
    op.completionBlock = completionBlock;
    
    [testOperationQueue addOperation:op atPriority:NSOperationQueuePriorityVeryLow];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:1];
    while (hasFinished == NO) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }    
    
    STAssertEquals(op.queuePriority, NSOperationQueuePriorityVeryLow, @"Operation should have correct priority");
}

- (void)testChangeOperationPriority {
    
    __block BOOL hasFinished = NO;
    
    void (^completionBlock)(void) = ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            hasFinished = YES;        
        });
    };     
    
    CDTestOperation *op = [CDTestOperation operation];
    op.completionBlock = completionBlock;
    
    [testOperationQueue addOperation:op];
    
    [testOperationQueue updatePriorityOfOperationWithIdentifier:op.identifier 
                                                  toNewPriority:NSOperationQueuePriorityVeryLow];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:1];
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
    
    CDTestOperation *finishLast = [CDTestOperation operationWithIdentifier:@"1"];
    finishLast.completionBlock = finishLastBlock;
    
    CDTestOperation *op = [CDTestOperation operationWithIdentifier:@"2"];
    
    CDTestOperation *finishFirst = [CDTestOperation operationWithIdentifier:@"3"];
    finishFirst.completionBlock = finishFirstBlock;
    
    [testOperationQueue addOperation:finishLast];
    [testOperationQueue addOperation:op];
    [testOperationQueue addOperation:finishFirst];
    
    [testOperationQueue updatePriorityOfOperationWithIdentifier:@"3" 
                                                  toNewPriority:NSOperationQueuePriorityVeryHigh];
    
    [testOperationQueue updatePriorityOfOperationWithIdentifier:@"1" 
                                                  toNewPriority:NSOperationQueuePriorityVeryLow];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:1];
    while (hasFinished == NO) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }    
        
    float firstInt = [first timeIntervalSinceNow];
    float lastInt  = [last timeIntervalSinceNow];
        
    STAssertTrue((firstInt < lastInt), @"Operation should finish first");
}

- (void)testEmptyQueueShouldHaveEmptyOperationsDict {
    
    __block BOOL hasFinished = NO;
    
    void (^completionBlock)(void) = ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            hasFinished = YES;        
        });
    };         
    
    CDTestOperation *op = [CDTestOperation operation];
    op.completionBlock = completionBlock;
    
    [testOperationQueue addOperation:op];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:1];
    while (hasFinished == NO) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }    
    
    NSInteger count = testOperationQueue.operations.count;
    STAssertEquals(count, 0, @"Operation queue should be empty");
}

- (void)testOperationQueueShouldReportRunning {
    
    __block BOOL hasFinished = NO;
    
    void (^completionBlock)(void) = ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            hasFinished = YES;        
        });
    };         
    
    CDTestOperation *op = [CDTestOperation operation];
    op.completionBlock = completionBlock;
    
    [testOperationQueue addOperation:op];
    
    STAssertTrue(testOperationQueue.isExecuting, @"Operation queue should be running");
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:1];
    while (testOperationQueue.isExecuting) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }    
    
    STAssertFalse(testOperationQueue.isExecuting, @"Operation queue should not be running");
}

- (void)testOperationShouldRemoveItselfWhenComplete {
    
}

#pragma mark - Conductor

- (void)testConductorAddOperation {
    
    __block BOOL hasFinished = NO;
    
    void (^completionBlock)(void) = ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            hasFinished = YES;        
        });
    };         
    
    CDTestOperation *op = [CDTestOperation operation];
    op.completionBlock = completionBlock;
    
    [conductor addOperation:op];
    
    STAssertNotNil([conductor getQueueForOperation:op], @"Conductor should have queue for operation");
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:1];
    while (conductor.hasQueues) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }    
            
    STAssertTrue(hasFinished, @"Conductor should add and complete test operation");
}

- (void)testConductorAddOperationToQueueNamed {
    
    __block BOOL hasFinished = NO;
    
    void (^completionBlock)(void) = ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            hasFinished = YES;        
        });
    };         
    
    CDTestOperation *op = [CDTestOperation operation];
    op.completionBlock = completionBlock;
    
    [conductor addOperation:op toQueueNamed:@"CustomQueueName"];
            
    STAssertNotNil([conductor getQueueNamed:@"CustomQueueName"], @"Conductor should have queue for operation");
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:1];
    while (conductor.hasQueues) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }    
    
    STAssertTrue(hasFinished, @"Conductor should add and complete test operation");
}

- (void)testConductorUpdateQueuePriority {
    
}

- (void)testConductorIsRunning {
    
    CDTestOperation *op = [CDTestOperation operation];
    
    [conductor addOperation:op];
    
    STAssertTrue([conductor isExecuting], @"Conductor should be running");
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:1];
    while ([conductor isExecuting]) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }    
    
    STAssertFalse([conductor isExecuting], @"Conductor should not be executing");

}

- (void)testConductorCancelAllOperations {
        
    CDTestOperation *op = [CDTestOperation operation];
    
    [conductor addOperation:op toQueueNamed:@"CustomQueueName"];
    
    [conductor cancelAllOperations];

    STAssertTrue(op.isCancelled, @"Operation should be cancelled");
}

- (void)testConductureCancelAllOperationsInQueueNamed {
    CDLongRunningTestOperation *op = [CDLongRunningTestOperation operation];
    
    [conductor addOperation:op toQueueNamed:@"CustomQueueName"];
    
    [conductor cancelAllOperationsInQueueNamed:@"CustomQueueName"];
    
    STAssertTrue(op.isCancelled, @"Operation should be cancelled");
}

- (void)testConductorSuspendAllQueues {
    CDLongRunningTestOperation *op = [CDLongRunningTestOperation operation];
    
    [conductor addOperation:op toQueueNamed:@"CustomQueueName"];
    
    [conductor suspendAllQueues];
    
    CDOperationQueue *queue = [conductor getQueueNamed:@"CustomQueueName"];
    
    STAssertTrue(queue.isSuspended, @"Operation queue should be suspended");
}

- (void)testConductorSuspendQueueNamed {
    CDLongRunningTestOperation *op = [CDLongRunningTestOperation operation];
    
    [conductor addOperation:op toQueueNamed:@"CustomQueueName"];
    
    [conductor suspendQueueNamed:@"CustomQueueName"];
    
    CDOperationQueue *queue = [conductor getQueueNamed:@"CustomQueueName"];
    
    STAssertTrue(queue.isSuspended, @"Operation queue should be suspended");    
}

- (void)testConductorResumeAllQueues {
    __block BOOL hasFinished = NO;
    
    void (^completionBlock)(void) = ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            hasFinished = YES;        
        });
    };         
    
    CDTestOperation *op = [CDTestOperation operation];
    op.completionBlock = completionBlock;
    
    [conductor addOperation:op toQueueNamed:@"CustomQueueName"];
    
    [conductor suspendAllQueues];
    [conductor resumeAllQueues];
        
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:1];
    while (conductor.hasQueues) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }    
    
    STAssertTrue(hasFinished, @"Conductor should add and complete test operation");
}

- (void)testConductorResumeQueueNamed {
    __block BOOL hasFinished = NO;
    
    void (^completionBlock)(void) = ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            hasFinished = YES;        
        });
    };         
    
    CDTestOperation *op = [CDTestOperation operation];
    op.completionBlock = completionBlock;
    
    [conductor addOperation:op toQueueNamed:@"CustomQueueName"];
    
    [conductor suspendQueueNamed:@"CustomQueueName"];
    [conductor resumeQueueNamed:@"CustomQueueName"];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:1];
    while (hasFinished == NO) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }    
    
    STAssertTrue(hasFinished, @"Conductor should add and complete test operation");
}

@end
