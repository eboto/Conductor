//
//  CDTestOperation.m
//  Conductor
//
//  Created by Andrew Smith on 10/21/11.
//  Copyright (c) 2011 Andrew B. Smith. All rights reserved.
//

#import "CDTestOperation.h"

@implementation CDTestOperation

- (void)start {
    @autoreleasepool {    
    
        [super start];
    
        sleep(0.2); //sleep for 2 seconds
    
        [self finish];
    }
}

@end
