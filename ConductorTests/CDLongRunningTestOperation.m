//
//  CDLongRunningTestOperation.m
//  Conductor
//
//  Created by Andrew Smith on 5/2/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDLongRunningTestOperation.h"

@implementation CDLongRunningTestOperation

- (void)start {
    @autoreleasepool {    
        
        [super start];
                
        NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:1.0];
        NSInteger counter = 0;
        while (!self.isCancelled || counter < 20) {
            counter += 1;
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                     beforeDate:loopUntil];
        }

        [self finish];
    }
}

@end
