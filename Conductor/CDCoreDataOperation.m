//
//  CDCoreDataOperation.m
//  Conductor
//
//  Created by Andrew Smith on 6/17/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDCoreDataOperation.h"

@interface CDCoreDataOperation ()
- (NSManagedObjectContext *)newMainStoreManagedObjectContext;
@end

@implementation CDCoreDataOperation

@synthesize mainContext = _mainContext,
            backgroundContext = _backgroundContext;

- (void)start {
    [super start];
    self.backgroundContext = [self newMainStoreManagedObjectContext];
}

- (void)saveBackgroundContext {
    // Save context
    if (self.backgroundContext.hasChanges) {
        NSError *error = nil;
        if (![self.backgroundContext save:&error]) {
            ConductorLogError(@"Save failed: %@", error);
        };
    }
}

- (NSManagedObjectContext *)newMainStoreManagedObjectContext {
    
    // Grab the main coordinator
    NSPersistentStoreCoordinator *coord = [self.mainContext persistentStoreCoordinator];
    
    // Create new context with default concurrency type
    NSManagedObjectContext *newContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
    [newContext setPersistentStoreCoordinator:coord];
    
    // Optimization
    [newContext setUndoManager:nil];
    
    // Observer saves from this context
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(contextDidSave:) 
                                                 name:NSManagedObjectContextDidSaveNotification 
                                               object:newContext];
    
    return newContext;
}

- (void)contextDidSave:(NSNotification *)notification {
    SEL selector = @selector(mergeChangesFromContextDidSaveNotification:);
    
    NSManagedObjectContext *threadContext = (NSManagedObjectContext *)notification.object;
    
    [self.mainContext performSelectorOnMainThread:selector 
                                       withObject:notification 
                                    waitUntilDone:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NSManagedObjectContextDidSaveNotification 
                                                  object:threadContext];
}

@end
