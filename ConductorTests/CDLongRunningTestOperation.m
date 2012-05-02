//
//  CDLongRunningTestOperation.m
//  Conductor
//
//  Created by Andrew Smith on 5/2/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDLongRunningTestOperation.h"

@implementation CDLongRunningTestOperation

- (void)start {
    @autoreleasepool {    
        
        [super start];
        
        sleep(20); //sleep for 20 seconds
        
        [self finish];
    }
}

@end
