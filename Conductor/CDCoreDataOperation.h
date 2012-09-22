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

@property (strong) NSManagedObjectContext *mainContext;

@property (strong) NSManagedObjectContext *backgroundContext;

+ (CDCoreDataOperation *)operationWithMainContext:(NSManagedObjectContext *)mainContext;

/**
 Queue and wait on a save on the background context
 */
- (void)saveBackgroundContext;

/**
 Queue up a save on the main context
 */
- (void)saveMainContext;

@end
