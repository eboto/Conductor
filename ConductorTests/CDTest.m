//
//  CDTest.m
//  Conductor
//
//  Created by Andrew Smith on 5/3/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDTest.h"

@implementation CDTest

- (void)setUp {
    [super setUp];
    
    testOperationQueue = [[CDOperationQueue alloc] init];
    [testOperationQueue.queue setMaxConcurrentOperationCount:1];
    
    conductor = [[Conductor alloc] init];
}

- (void)tearDown {    
    [super tearDown];
    
    [conductor cancelAllOperations];
    [testOperationQueue cancelAllOperations];
    
    [testOperationQueue release], testOperationQueue = nil;
    [conductor release], conductor = nil;
}


@end
