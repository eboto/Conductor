//
//  CDCoreDataOperation.m
//  Conductor
//
//  Created by Andrew Smith on 6/17/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDCoreDataOperation.h"

@interface CDCoreDataOperation ()
- (NSManagedObjectContext *)newThreadSafeManagedObjectContext;
@end

@implementation CDCoreDataOperation

@synthesize mainContext = _mainContext,
            backgroundContext = _backgroundContext;

+ (CDCoreDataOperation *)operationWithMainContext:(NSManagedObjectContext *)mainContext 
{
    CDCoreDataOperation *operation = [self operation];
    operation.mainContext = mainContext;
    return operation;
}

- (void)start 
{
    [super start];
    self.backgroundContext = [self newThreadSafeManagedObjectContext];
}

- (void)saveBackgroundContext 
{
    // Save context
    if (self.backgroundContext.hasChanges) {
        NSError *error = nil;
        if (![self.backgroundContext save:&error]) {
            ConductorLogError(@"Save failed: %@", error);
        };
    }
}

- (NSManagedObjectContext *)newThreadSafeManagedObjectContext
{
    // Build private queue context as child of main context
    NSManagedObjectContext *newContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [newContext setParentContext:self.mainContext];
    
    // Optimization
    [newContext setUndoManager:nil];

    return newContext;
}

@end
