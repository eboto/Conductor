//
//  CDOperationQueue+State.m
//  Conductor
//
//  Created by Andrew Smith on 9/22/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDOperationQueue+State.h"

@implementation CDOperationQueue (State)

- (BOOL)isExecuting
{
    return (self.operationCount > 0);
}

- (BOOL)isFinished
{
    return (self.operationCount == 0);
}

- (BOOL)isSuspended
{
    return self.queue ? self.queue.isSuspended : NO;
}

- (void)setSuspended:(BOOL)suspend
{
    [self.queue setSuspended:suspend];
}

@end
