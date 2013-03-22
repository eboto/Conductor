#Conductor

***

##Introduction

Conductor is a useful way to keep track of asynchronous `NSOperation` jobs in an `NSOperationQueue`.

* Change operation priority
* Manage multiple queues
* Track queue progress
* Pause/Resume queues
* Use thread safe `NSManagedObjectContext` objects
* Easily background tasks that run when your app isn't active

Often times in iOS apps there is a need to manage long running tasks. Whether it is downloading images from a server, parsing JSON from an API, or fetching Core Data objects, it's vital to move these tasks off of the main thread for a good user experience.

The iOS SDK offers several ways to run tasks in the background.  CGD is fantastic for one off asynchronous operations.  The `NSOperationQueue` class is a great way to treat tasks as objects using the `NSOperation` class. However, it's immediately obvious how to subclass `NSOperation`, or how to track queue progress. Conductor was written because I frequently found myself solving the same problems over and over. With Conductor, you can:

* Keep track of multiple `NSOperationQueue` objects.  Use one for image downloading and one for JSON operations.  Easily suspend all image downloads, or cancel them outright when the user switches screens.
* Observe the progress of a given queue.  Add a `UIProgressView` and show the user your image download progress and execute a completion block when the queue is finished.
* Change the `NSOperationQueuePriority` for a specific operation in a queue.  For example, change the priority of thumbnail image downloads as the user scrolls a `UITableView`.

##Installation

Conductor is built as a static library, based on some of the excellent conventions detailed by Jonah Williams on [Using Open Source Static Libraries in Xcode 4](http://blog.carbonfive.com/2011/04/04/using-open-source-static-libraries-in-xcode-4/). I highly recommend reading this to understand how the installation process works.

1. Add Conductor as a git submodule to your repository. `git submodule add git@github.com:ChazInc/Conductor.git`
2. Add `Conductor.xcodeproj` to your project. `File > Add Files to "MyProject"…`
3. Add Conductor as a target dependency to your app target under the `Build Phases` menu.
4. Link the binary to the Conductor library.
5. Add `$(OBJROOT)/UninstalledProducts/include` to your **User Header Search Paths**, and set **Always Search User Paths** to Yes.
6. Import Conductor with `#import <Conductor/Conductor.h>`
7. Build the project to check and make sure you setup everything correctly.

##Using Conductor

### The CDQueueController

You can create and keep track of as many CDQueueControllers as you want, but I usually end up using one and storing it on the App Delegate.

```objective-c
#import <UIKit/UIKit.h>
#import <Conductor/Conductor.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) CDQueueController *mainQueueController;

@end
```

### Building A Queue

The first step is to build a queue.

### Adding Operations

To use Conductor, first you have to subclass `CDOperation`, which is itself an `NSOperation` subclass.  Lets build a really simple operation to play around with, which is the same as the `CDTestOperation` in ConductorTests.

```objective-c
#import "Conductor/CDOperation.h"

@interface TestOperation : CDOperation

@end

@implementation TestOperation

- (void)start {
    @autoreleasepool {
        [super start];
    
        sleep(1.0);
    
        [self finish];
    }
}

@end
```

As you can see, this operation just waits for one second before finishing.  Now lets add a bunch of operations to our Conductor singleton.  To slow things down, let's set the max concurrency operation count to 1 for our queue.  This will result in serial operation of our `TestOperation` so we can see what is happening in the log.

```objective-c
Conductor *conductor = [Conductor sharedInstance];
NSString *myQueueName = @"MyQueueName";

[conductor addProgressObserverToQueueNamed:myQueueName 
                         withProgressBlock:^(float progress) {
                             NSLog(@"progress: %f", progress);
                         }
                        andCompletionBlock:^ {
                            NSLog(@"Finished!");
                        }];

[conductor setMaxConcurrentOperationCount:1 
                            forQueueNamed:myQueueName];
    
for (NSInteger i = 0; i < 100; i++) {
    TestOperation *operation = [TestOperation operation];
    [conductor addOperation:operation toQueueNamed:myQueueName]; 
}
```

##Subclassing CDOperation

Safe methods available to override in CDOperation subclasses included `start` and `finish.` Conductor uses KVO to keep track of when operations finish by observing the `isFinished` property on CDOperation.  It's probably a good idea to read Apple's guide on [subclassing NSOperation](https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/NSOperation_class/Reference/Reference.html#//apple_ref/doc/uid/TP40004591-RH2-SW18) to understand how the design works.  Subclasses have to properly [respond to the cancel command](https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/NSOperation_class/Reference/Reference.html#//apple_ref/doc/uid/TP40004591-RH2-SW18).  The `start` method of CDOperation does some of that work for you.

```objective-c
- (void)start {
    ConductorLogTrace(@"Started operation: %@", self.identifier);
    
    if (self.isCancelled) {
        [self finish];
        return;
    }

    // Don't forget to wrap your operation in an autorelease pool
    
    self.state = CDOperationStateExecuting;
}
```

Remember to call `[super start]` in your subclass.  If you have a particularly long running operation, it is up to you to decide when you might need to respond to a cancel command.  Sometimes it's best to let operations finish, sometimes it's best to respond mid execution;  your design depends on your needs.

Besides the implementing the`start` method, you also need to call `[self finish]` when your operation is done to trigger KVO.  You don't have to implement it, but it might be useful for some custom cleanup.

##Updating Priority

Conductor allows you to keep track of specific operations by using the operations identifier.  You can either assign your own identifier to an operations, or get a unique string on query.  Store these identifiers to update priority.

```objective-c
Conductor *conductor = [Conductor sharedInstance];
NSString *myQueueName = @"MyQueueName";

TestOperation *operation = [TestOperation operation];
[conductor addOperation:operation];

[conductor updatePriorityOfOperationWithIdentifier:operation.identifier 
                                             					 toNewPriority:NSOperationQueuePriorityVeryHigh];
```

##Contributing

Forks, patches and other feedback are always welcome. 

### Conductor is brought to you by Egraphs###

Contributors:

* [Andrew B. Smith](http://github.com/drewsmits).
