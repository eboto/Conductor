//
//  CDLongRunningTestOperation.h
//  Conductor
//
//  Created by Andrew Smith on 5/2/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDOperation.h"

@interface CDLongRunningTestOperation : CDOperation

@property (nonatomic, assign) float duration;

+ (CDLongRunningTestOperation *)longRunningOperationWithDuration:(float)duration;

@end
