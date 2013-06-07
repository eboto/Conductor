//
//  CDThreadOperation.h
//  Conductor
//
//  Created by Andrew Smith on 3/29/13.
//  Copyright (c) 2013 Andrew B. Smith. All rights reserved.
//

#import <Conductor/Conductor.h>

typedef enum {
    CDOperationStateReady,
    CDOperationStateExecuting,
    CDOperationStateFinished,
} CDOperationState;

@interface CDThreadOperation : CDOperation

@end
