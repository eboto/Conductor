//
//  CDOperationQueue+Max.m
//  Conductor
//
//  Created by Andrew Smith on 9/22/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDOperationQueue+Max.h"

@implementation CDOperationQueue (Max)

- (BOOL)maxQueueOperationCountReached
{    
    if (self.maxQueuedOperationsCount == CDOperationQueueCountMax) {
        return NO;
    }    
    return (self.operationCount >= self.maxQueuedOperationsCount);
}

- (void)setMaxConcurrentOperationCount:(NSUInteger)count {
    [self.queue setMaxConcurrentOperationCount:count];
}

@end
