//
//  CDOperation.h
//  Conductor
//
//  Created by Andrew Smith on 10/21/11.
//  Copyright (c) 2011 Andrew B. Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDOperation : NSOperation {
@private
    id identifier_;
}

/**
 * Key used to track operation in CDOperationQueue.  If no identifier is provided,
 * the operations description will be used instead.  
 */
@property (nonatomic, retain) id identifier;

/**
 * Convenience init for adding an identifier to your operation.
 * @see identifier
 */
- (id)initWithIdentifier:(id)identifier;

/**
 * Factory for adding an identifier to your operation.
 * @see initWithIdentifier:
 */
+ (id)operationWithIdentifier:(id)identifier;

/**
 * Factory for creating a new operation
 */
+ (id)operation;

/**
 * Call this when the main operation is finished running.  Subclasses can use
 * this to run any necessary cleanup when finished.
 */
- (void)finish;

@end
