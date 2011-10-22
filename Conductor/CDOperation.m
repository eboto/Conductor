//
//  CDOperation.m
//  Conductor
//
//  Created by Andrew Smith on 10/21/11.
//  Copyright (c) 2011 Posterous. All rights reserved.
//

#import "CDOperation.h"

#pragma mark - State

typedef enum {
    CDOperationStateReady,
    CDOperationStateExecuting,
    CDOperationStateFinished,
    CDOperationStateCancelled,
} CDOperationState;

static inline NSString * StringForCDOperationState(CDOperationState state) {
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
        case CDOperationStateCancelled:
            return @"isCancelled";
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark -

@interface CDOperation ()
@property (nonatomic, assign) CDOperationState state;
@end

@implementation CDOperation

@synthesize identifier = identifier_,
            state = _state;

- (void)dealloc {
    [identifier_ release], identifier_ = nil;
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.state = CDOperationStateReady;
    }
    return self;
}

- (id)initWithIdentifier:(id)identifier {
    self = [self init];
    if (self) {
        self.identifier = identifier;
    }
    return self;
}

#pragma mark - 

- (void)start {
    self.state = CDOperationStateExecuting;
}

- (void)finish {
    self.state = CDOperationStateFinished;
}

- (BOOL)isReady {
    return (self.state == CDOperationStateReady);
}

- (BOOL)isExecuting {
    return (self.state == CDOperationStateExecuting);
}

- (BOOL)isFinished {
    return (self.state == CDOperationStateFinished);
}

- (BOOL)isConcurrent {
    return YES;
}

#pragma mark - Accessors

- (void)setState:(CDOperationState)state {
    // Ensures KVO complience for changes in NSOperation object state
    
    if (self.state == state) {
        return;
    }
    
    NSString *oldStateString = StringForCDOperationState(self.state);
    NSString *newStateString = StringForCDOperationState(state);
    
    [self willChangeValueForKey:newStateString];
    [self willChangeValueForKey:oldStateString];
    _state = state;
    [self didChangeValueForKey:oldStateString];
    [self didChangeValueForKey:newStateString];
}

- (id)identifier {
    if (!identifier_) return self.description;
    return identifier_;
}


@end
