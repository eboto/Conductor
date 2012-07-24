//
//  CDTestCoreDataOperation.m
//  Conductor
//
//  Created by Andrew Smith on 6/25/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDTestCoreDataOperation.h"

@implementation CDTestCoreDataOperation

- (void)start {
    @autoreleasepool {
        [super start];
        
        
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" 
                                                                inManagedObjectContext:self.backgroundContext];
        
        [object setValue:[NSNumber numberWithInt:1] forKey:@"employeeID"];
        [object setValue:@"Created" forKey:@"firstname"];
        [object setValue:@"InBackground" forKey:@"lastname"];
        
        [self saveBackgroundContext];
        
        [self finish];
    }
}


@end
