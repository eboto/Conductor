//
//  ConductorTests.h
//  ConductorTests
//
//  Created by Andrew Smith on 10/21/11.
//  Copyright (c) 2011 Andrew B. Smith. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "Conductor.h"

#import "CDOperationQueue.h"

@interface ConductorTests : SenTestCase {
    CDOperationQueue *testOperationQueue;
    Conductor *conductor;
}

@end
