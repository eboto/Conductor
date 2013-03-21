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
    CDLongRunningTestOperation *operation = [CDLongRunningTestOperation new];
    operation.duration = duration;
    return operation;
}

- (void)work
{
    sleep(self.duration);
}

@end
