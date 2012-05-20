#Conductor

***

##Introduction

Conductor is a useful way to keep track of, update, and query, asynchronous `NSOperation` objects. 

Often times in iOS apps there is a need to manage asynchronous background tasks.  Frequently, these tasks can be grouped into specific types of operations, like downloading images from a web service, or parsing a JSON response from an API.  Moving as much processing as you can off the main thread is vital for a good user experience so we don't lock up the user interface, for instance.

The iOS SDK offers several ways to execute background tasks.  CGD is fantastic for one off asynchronous operations.  The `NSOperationQueue` class is a great way to collect `NSOperation` objects, but it isn't immediately obvious how to observer the state of your queue.  Conductor was written to pick up the slack where these API's fall short. With Conductor, you can:

* Keep track of multiple `NSOperationQueue` objects.  Use one for image downloading and one for JSON operations.  Easily suspend all image downloads, or cancel them outright when the user switches screens.
* Easily observer the progress of a given queue.  Add a `UIProgressView` and show the user your image download progress and execute a completion block when the queue is finished.
* Change the `NSOperationQueuePriority` for a specific operation in a queue.  For example, change the priority of thumbnail image downloads as the user scrolls a `UITableView`.

##Setup

##Contributing

Forks, patches and other feedback are always welcome. 

### Conductor is brought to you by Egraphs###

Contributors:

* [Andrew B. Smith](http://github.com/drewsmits).
