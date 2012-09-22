//
//  CDBackgroundTaskOperation.h
//  Conductor
//
//  Created by Andrew Smith on 7/16/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDCoreDataOperation.h"
#import <UIKit/UIApplication.h>

@interface CDBackgroundTaskOperation : CDCoreDataOperation {
    UIBackgroundTaskIdentifier backgroundTaskID;
}

- (void)backgroundTaskExpirationCleanup;

@end
