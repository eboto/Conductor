//
//  Conductor.h
//  Conductor
//
//  Created by Andrew Smith on 10/21/11.
//  Copyright (c) 2011 Posterous. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Conductor : NSObject {
@private
    NSMutableDictionary *queues;
}

@property (nonatomic, readonly) NSMutableDictionary *queues;

- (void)addOperation:(NSOperation *)operation;

- (void)addOperation:(NSOperation *)operation toQueue


@end
