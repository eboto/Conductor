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

@property (nonatomic, strong) NSManagedObjectContext *backgroundContext;

- (void)saveBackgroundContext;

@end
