#Conductor

***

##Introduction

Conductor is a useful way to keep track of, update, and query, asynchronous `NSOperation` objects. 

Often times in iOS apps there is a need to manage asynchronous background tasks.  Frequently, these tasks can be grouped into specific types of operations, like downloading images from a web service, or parsing a JSON response from an API.  Moving as much processing as you can off the main thread is vital for a good user experience so we don't lock up the user interface, for instance.

The iOS SDK offers several ways to execute background tasks.  CGD is fantastic for one off asynchronous operations.  The `NSOperationQueue` class is a great way to collect `NSOperation` objects, but it isn't immediately obvious how to observer the state of your queue.  Conductor was written to pick up the slack where these API's fall short. With Conductor, you can:

* Keep track of multiple `NSOperationQueue` objects.  Use one for image downloading and one for JSON operations.  Easily suspend all image downloads, or cancel them outright when the user switches screens.
* Easily observer the progress of a given queue.  Add a `UIProgressView` and show the user your image download progress and execute a completion block when the queue is finished.
* Change the `NSOperationQueuePriority` for a specific operation in a queue.  For example, change the priority of thumbnail image downloads as the user scrolls a `UITableView`.

##Installation

Conductor is built as a modern static library, based on some of the excellent conventions detailed by Jonah Williams on [Using Open Source Static Libraries in Xcode 4](http://blog.carbonfive.com/2011/04/04/using-open-source-static-libraries-in-xcode-4/).  I highly recommend reading this to understand how the installation process works.

1. Add Conductor as a git submodule to your repository. `git submodule add git@github.com:ChazInc/Conductor.git`
2. Add `Conductor.xcodeproj` to your project. `File > Add Files to "MyProject"…`
3. Add Conductor as a target dependency to your app target under the `Build Phases` menu.
4. Link the binary to the Conductor library.
5. Add `$(OBJROOT)/UninstalledProducts/include` to your **User Header Search Paths**, and set **Always Search User Paths** to Yes.
6. Import the Conductor with `#import <Conductor/Conductor.h>`
7. Build the project to check and make sure you setup everything correctly.

##Setup

To use Conductor, first you have to subclass `CDOperation`, which is itself an NSOperation subclass.  Lets build a really simple operation to play around with, which is the same as the `CDTestOperation` in ConductorTests.

```objective-c
#import "CDOperation.h"

@interface CDTestOperation : CDOperation

@end

@implementation CDTestOperation

- (void)start {
    @autoreleasepool {
        [super start];
    
        sleep(0.4);
    
        [self finish];
    }
}
```
@end


##Contributing

Forks, patches and other feedback are always welcome. 

### Conductor is brought to you by Egraphs###

Contributors:

* [Andrew B. Smith](http://github.com/drewsmits).
