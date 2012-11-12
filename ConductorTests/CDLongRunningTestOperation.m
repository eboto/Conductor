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
        
        sleep(self.duration);

        [self finish];
    }
}

@end
