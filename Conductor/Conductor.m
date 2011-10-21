//
//  Conductor.m
//  Conductor
//
//  Created by Andrew Smith on 10/21/11.
//  Copyright (c) 2011 Posterous. All rights reserved.
//

#import "Conductor.h"

@implementation Conductor

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

#pragma mark - Accessors

- (NSMutableDictionary *)queues {
    if (queues) return [[queues retain] autorelease];
    queues = [[NSMutableDictionary alloc] init];
    return [[queues retain] autorelease];
}

@end
