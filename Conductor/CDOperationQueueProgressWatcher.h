//
//  CDOperationQueueProgressWatcher.h
//  Conductor
//
//  Created by Andrew Smith on 4/30/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CDOperationQueueProgressWatcherProgressBlock)(float progress);
typedef void (^CDOperationQueueProgressWatcherCompletionBlock)(void);

@interface CDOperationQueueProgressWatcher : NSObject

@property (nonatomic, assign) NSInteger startingOperationCount;

@property (nonatomic, copy) CDOperationQueueProgressWatcherProgressBlock progressBlock;

@property (nonatomic, copy) CDOperationQueueProgressWatcherCompletionBlock completionBlock;

+ (CDOperationQueueProgressWatcher *)progressWatcherWithStartingOperationCount:(NSInteger)operationCount
                                                                 progressBlock:(CDOperationQueueProgressWatcherProgressBlock)progressBlock 
                                                            andCompletionBlock:(CDOperationQueueProgressWatcherCompletionBlock)completionBlock;

- (void)runProgressBlockWithCurrentOperationCount:(NSNumber *)operationCount;

- (void)runCompletionBlock;

- (void)addToStartingOperationCount:(NSNumber *)numberToAdd;

@end
