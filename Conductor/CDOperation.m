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

+ (id)operationWithIdentifier:(id)identifier{
    return [[[self alloc] initWithIdentifier:identifier] autorelease];
}

+ (id)operation {
    return [[[self alloc] init] autorelease];
}

#pragma mark - 

- (void)start {
    
    // Don't forget to wrap your operation in an autorelease pool
    
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
    if (identifier_) return [[identifier_ retain] autorelease];
    
    NSInteger time = CFAbsoluteTimeGetCurrent();
    identifier_ = [[NSString stringWithFormat:@"%@_%d", NSStringFromClass([self class]), time] retain];
    
    return [[identifier_ retain] autorelease];
}


@end
