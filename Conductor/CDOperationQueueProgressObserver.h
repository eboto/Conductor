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

- (void)runProgressBlockWithCurrentOperationCount:(NSNumber *)operationCount;

- (void)runCompletionBlock;

- (void)addToStartingOperationCount:(NSNumber *)numberToAdd;

@end
