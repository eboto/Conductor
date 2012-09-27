//
//  CDBackgroundTaskOperation.m
//  Conductor
//
//  Created by Andrew Smith on 7/16/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDBackgroundTaskOperation.h"

@implementation CDBackgroundTaskOperation

- (void)start
{    
    UIApplication *application = [UIApplication sharedApplication];

    /**
     This handler will be called before the allowed background task time runs
     out.
     */
    backgroundTaskID = [application beginBackgroundTaskWithExpirationHandler:^{
        [self backgroundTaskExpirationCleanup];
        
        [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskID];
        backgroundTaskID = UIBackgroundTaskInvalid;
    }];
    
    [super start];
}

- (void)backgroundTaskExpirationCleanup
{
    // Don't do anything long running here
}

@end
