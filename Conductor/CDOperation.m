//
//  CDOperation.m
//  Conductor
//
//  Created by Andrew Smith on 10/21/11.
//  Copyright (c) 2011 Andrew B. Smith ( http://github.com/drewsmits ). All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal 
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
// of the Software, and to permit persons to whom the Software is furnished to do so, 
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included 
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "CDOperation.h"
#import <mach/mach_time.h>

#pragma mark - State

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

#pragma mark -

@interface CDOperation ()
@property (nonatomic, assign) CDOperationState state;
@end

@implementation CDOperation

@synthesize identifier = identifier_,
            state = _state;

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

+ (id)operationWithIdentifier:(id)identifier{
    return [[self alloc] initWithIdentifier:identifier];
}

+ (id)operation {
    return [[self alloc] init];
}

#pragma mark - 

- (void)start {
    ConductorLogTrace(@"Started operation: %@", self.identifier);
    
    if (self.isCancelled) {
        [self finish];
        return;
    }

    // Don't forget to wrap your operation in an autorelease pool
    
    self.state = CDOperationStateExecuting;
}

- (void)finish {
    ConductorLogTrace(@"Finished operation: %@", self.identifier);
    self.state = CDOperationStateFinished;
}

- (void)cancel {
    [super cancel];
    ConductorLogTrace(@"Canceled operation: %@", self.identifier);
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
    if (identifier_) return identifier_;
    
    uint64_t absolute_time = mach_absolute_time();
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    uint64_t nanoseconds = (double)absolute_time * (double)timebase.numer / (double)timebase.denom;
    
    identifier_ = [NSString stringWithFormat:@"%@_%llu", NSStringFromClass([self class]), nanoseconds];
    
    return identifier_;
}


@end
