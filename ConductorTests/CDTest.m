//
//  CDTest.m
//  Conductor
//
//  Created by Andrew Smith on 5/3/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDTest.h"

@implementation CDTest

- (void)setUp
{
    [super setUp];
   
    conductor = [Conductor new];
    
    testOperationQueue = [CDOperationQueue queueWithName:CONDUCTOR_TEST_QUEUE];
    [testOperationQueue setMaxConcurrentOperationCount:1];
    
    [conductor addQueue:testOperationQueue];
}

- (void)tearDown
{
    [super tearDown];
    
    [testOperationQueue cancelAllOperations];
    [conductor cancelAllOperations];
}


@end
