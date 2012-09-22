//
//  CDOperationQueue+Max.h
//  Conductor
//
//  Created by Andrew Smith on 9/22/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import <Conductor/Conductor.h>

typedef enum {
    CDOperationQueueCountMax    = 0,
    CDOperationQueueCountLow    = 2,
    CDOperationQueueCountMedium = 4,
    CDOperationQueueCountHigh   = 6,
} CDOperationQueueCount;

@interface CDOperationQueue (Max)

@property (readonly) BOOL maxQueueOperationCountReached;

/**
 Updated the queues max concurency count.  Set it to 1 for serial execution of
 operations.
 */
- (void)setMaxConcurrentOperationCount:(NSUInteger)count;

@end
