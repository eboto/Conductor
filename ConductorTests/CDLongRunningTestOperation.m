//
//  CDLongRunningTestOperation.m
//  Conductor
//
//  Created by Andrew Smith on 5/2/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDLongRunningTestOperation.h"

@implementation CDLongRunningTestOperation

@synthesize duration;

+ (CDLongRunningTestOperation *)longRunningOperationWithDuration:(float)duration {
    CDLongRunningTestOperation *operation = [CDLongRunningTestOperation operation];
    operation.duration = duration;
    return operation;
}

- (void)start {
    @autoreleasepool {    
        
        [super start];
        
        sleep(duration);

                
//        NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.01];
//        NSInteger counter = 0;
//        while (!self.isCancelled || counter < duration) {
//            counter += 1;
//            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
//                                     beforeDate:loopUntil];
//        }

        [self finish];
    }
}

@end
