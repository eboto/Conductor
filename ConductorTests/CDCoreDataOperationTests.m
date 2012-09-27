//
//  CDCoreDataOperation.m
//  Conductor
//
//  Created by Andrew Smith on 6/25/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDCoreDataOperationTests.h"
#import "CDCoreDataOperation.h"
#import "CDTestCoreDataOperation.h"
#import "ConductorTestMacros.h"

@implementation CDCoreDataOperationTests

- (void)setUp {
    [super setUp];
    
    // Build Model
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:DataModelURL()];
    
    STAssertNotNil(model, @"Managed Object Model should exist");
    
    // Build persistent store coordinator
    coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // Build Store
    NSError *error = nil;
    store = [coord addPersistentStoreWithType:NSSQLiteStoreType
                                configuration:nil
                                          URL:DataStoreURL()
                                      options:nil 
                                        error:&error];
    
    // Build context
    context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [context setPersistentStoreCoordinator:coord];
}

- (void)tearDown {
    [context release], context = nil;
    
    NSError *error = nil;
    STAssertTrue([coord removePersistentStore:store error:&error], 
                 @"couldn't remove persistent store: %@", error);
    
    store = nil;
    [coord release], coord = nil;
    [model release], model = nil;  
        
    DeleteDataStore();

    [super tearDown];
}

- (void)testStart {
    CDCoreDataOperation *operation = [CDCoreDataOperation operationWithMainContext:context];
    
    [operation start];
    
    STAssertNotNil(operation.backgroundContext, @"Operation background context should not be nil!");
}

- (void)testBackgroundContextDidSave {
    
    __block BOOL hasFinished = NO;
    
    void (^completionBlock)(void) = ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            hasFinished = YES;        
        });
    };         
    
    CDTestCoreDataOperation *operation = (CDTestCoreDataOperation *)[CDTestCoreDataOperation operationWithMainContext:context];
    operation.completionBlock = completionBlock;
    
    [conductor addOperation:operation]; 
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.2];
    while (hasFinished == NO) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }    

    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:context];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"1 = 1"]];

    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    NSManagedObject *employee = [results lastObject];

    STAssertEquals([results count], 1U, @"Should only have one employee");
    STAssertEqualObjects([employee valueForKey:@"employeeID"], @1, @"Employee should have correct ID");
}

@end
