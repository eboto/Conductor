//
//  CDTest.h
//  Conductor
//
//  Created by Andrew Smith on 5/3/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "Conductor.h"
#import "CDOperationQueue.h"

@interface CDTest : SenTestCase {
    CDOperationQueue *testOperationQueue;
    Conductor *conductor;
}

@end
