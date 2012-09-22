//
//  CDOperationQueue+State.h
//  Conductor
//
//  Created by Andrew Smith on 9/22/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import <Conductor/Conductor.h>

@interface CDOperationQueue (State)

- (BOOL)isExecuting;
- (BOOL)isFinished;
- (BOOL)isSuspended;

/**
 Pauses internal NSOperationQueue
 */
- (void)setSuspended:(BOOL)suspend;

@end
