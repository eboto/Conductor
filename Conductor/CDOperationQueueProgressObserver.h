//
//  CDOperationQueueProgressWatcher.h
//  Conductor
//
//  Created by Andrew Smith on 4/30/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CDOperationQueueProgressObserverProgressBlock)(float progress);
typedef void (^CDOperationQueueProgressObserverCompletionBlock)(void);

@interface CDOperationQueueProgressObserver : NSObject

@property (nonatomic, assign) NSInteger startingOperationCount;

@property (nonatomic, copy) CDOperationQueueProgressObserverProgressBlock progressBlock;

@property (nonatomic, copy) CDOperationQueueProgressObserverCompletionBlock completionBlock;

+ (CDOperationQueueProgressObserver *)progressObserverWithStartingOperationCount:(NSInteger)operationCount
                                                                   progressBlock:(CDOperationQueueProgressObserverProgressBlock)progressBlock 
                                                              andCompletionBlock:(CDOperationQueueProgressObserverCompletionBlock)completionBlock;

/**
 Runs the observers progress block
 */
- (void)runProgressBlockWithCurrentOperationCount:(NSNumber *)operationCount;

/**
 Runs the observers completion block
 */
- (void)runCompletionBlock;

/**
 Adds to the starting operation count.  Say you start with 10 operations,
 then add 5 more, use this to add to the count so that progress can be properly
 adjusted and calculated.
 */
- (void)addToStartingOperationCount:(NSNumber *)numberToAdd;

@end
