//
//  CDTestOperation.m
//  Conductor
//
//  Created by Andrew Smith on 10/21/11.
//  Copyright (c) 2011 Posterous. All rights reserved.
//

#import "CDTestOperation.h"

@implementation CDTestOperation

- (void)start {    
    [super start];
    
    sleep(1); //sleep for 2 seconds
    
    [self finish];
}

@end
