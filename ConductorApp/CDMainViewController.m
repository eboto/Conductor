//
//  ViewController.m
//  ConductorApp
//
//  Created by Andrew Smith on 12/12/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDMainViewController.h"
#import "CDSuperLongTaskOperation.h"
#import "CDIsExecutingQueryOperation.h"

#import "AppDelegate.h"

@implementation CDMainViewController

- (IBAction)runLongTask:(id)sender
{
    CDSuperLongTaskOperation *operation1 = [CDSuperLongTaskOperation new];
    CDSuperLongTaskOperation *operation2 = [CDSuperLongTaskOperation new];

    [[Conductor sharedInstance] addOperation:operation1
                                toQueueNamed:CONDUCTOR_APP_QUEUE];
    
    [[Conductor sharedInstance] addOperation:operation2
                                toQueueNamed:CONDUCTOR_APP_QUEUE];
}

- (IBAction)runIsExecutingTasks:(id)sender
{
    for (int i = 0; i < 100; i++) {
        CDIsExecutingQueryOperation *op = [CDIsExecutingQueryOperation operationWithRandomNumCycles];
        [[Conductor sharedInstance] addOperation:op
                                    toQueueNamed:CONDUCTOR_NONCON_APP_QUEUE];
    }
}

@end
