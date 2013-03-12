//
//  AppDelegate.h
//  ConductorApp
//
//  Created by Andrew Smith on 12/12/12.
//  Copyright (c) 2012 Andrew B. Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CONDUCTOR_APP_QUEUE @"com.conductorapp.concurrentQueue"
#define CONDUCTOR_NONCON_APP_QUEUE @"com.conductorapp.nonConcurrentQueue"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
