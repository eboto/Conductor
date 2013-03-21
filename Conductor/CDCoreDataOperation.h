//
//  CDCoreDataOperation.h
//  Conductor
//
//  Created by Andrew Smith on 6/17/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDOperation.h"
#import <CoreData/CoreData.h>

@interface CDCoreDataOperation : CDOperation

@property (nonatomic, strong) NSManagedObjectContext *mainContext;

/**
 This will get created in the main method, which supports thread confinment
 */
@property (nonatomic, strong, readonly) NSManagedObjectContext *backgroundContext;

+ (CDCoreDataOperation *)operationWithMainContext:(NSManagedObjectContext *)mainContext;

/**
 Queue and wait on a save on the background context. Waiting prevents bailing on the NSOperation before
 the save happens. The parent context is the main context, which means that when the background context
 is saved, the results are pushed to the main context.
 */
- (BOOL)saveBackgroundContext;

/**
 Optionally, you can queue up a save on the main context when you are done. This isn't necessary for
 changes to show up on the main queue, but it is necessary for objects to be persisted to the persistent
 store.
 */
- (void)queueMainContextSave;

@end
