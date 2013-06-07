//
//  CDThreadOperation.m
//  Conductor
//
//  Created by Andrew Smith on 3/29/13.
//  Copyright (c) 2013 Andrew B. Smith. All rights reserved.
//

#import "CDThreadOperation.h"

static inline NSString *StringForCDOperationState(CDOperationState state) {
    switch (state) {
        case CDOperationStateReady:
            return @"isReady";
            break;
        case CDOperationStateExecuting:
            return @"isExecuting";
            break;
        case CDOperationStateFinished:
            return @"isFinished";
            break;
        default:
            return nil;
            break;
    }
}

@interface CDThreadOperation ()
@property (nonatomic, assign) CDOperationState state;
@end

@implementation CDThreadOperation

- (void)start
{
    @autoreleasepool {
        //
        // Flip state, per Apple Docs
        //
        self.state = CDOperationStateExecuting;

        //
        // Respect the cancel
        //
        if (self.isCancelled) {
            [self finish];
            return;
        }
    
        //
        // Do work. Notice that you will have to manually call 'finish' when your work is done. This
        // allows async jobs to continue on the thread without finishing the operation before the
        // callbacks happen.
        //
        [self work];
    }
}

- (void)finish
{
    [super finish];
    
    //
    // Flip state, per Apple Docs
    //
    self.state = CDOperationStateFinished;
}

- (BOOL)isReady
{
    return (self.state == CDOperationStateReady);
}

- (BOOL)isExecuting
{
    return (self.state == CDOperationStateExecuting);
}

- (BOOL)isFinished
{
    return (self.state == CDOperationStateFinished);
}

- (void)setState:(CDOperationState)state
{
    //
    // Ensures KVO complience for changes in NSOperation object state
    //
    
    if (self.state == state) return;
    
    NSString *oldStateString = StringForCDOperationState(self.state);
    NSString *newStateString = StringForCDOperationState(state);
    
    [self willChangeValueForKey:newStateString];
    [self willChangeValueForKey:oldStateString];
    _state = state;
    [self didChangeValueForKey:oldStateString];
    [self didChangeValueForKey:newStateString];
}

@end
