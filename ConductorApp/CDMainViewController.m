//
//  ViewController.m
//  ConductorApp
//
//  Created by Andrew Smith on 12/12/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import "CDMainViewController.h"
#import "CDSuperLongTaskOperation.h"

@implementation CDMainViewController

- (IBAction)runLongTask:(id)sender
{
    CDSuperLongTaskOperation *operation1 = [CDSuperLongTaskOperation new];
    CDSuperLongTaskOperation *operation2 = [CDSuperLongTaskOperation new];

    [[Conductor sharedInstance] addOperation:operation1
                                toQueueNamed:@"com.conductorapp.queue"];
    
    [[Conductor sharedInstance] addOperation:operation2
                                toQueueNamed:@"com.conductorapp.queue"];
}

@end
