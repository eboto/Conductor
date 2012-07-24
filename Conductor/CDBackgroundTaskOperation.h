//
//  CDBackgroundTaskOperation.h
//  Conductor
//
//  Created by Andrew Smith on 7/16/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDOperation.h"
#import <UIKit/UIApplication.h>

@interface CDBackgroundTaskOperation : CDOperation {
    UIBackgroundTaskIdentifier backgroundTaskID;
}

- (void)backgroundTaskExpirationCleanup;

@end
