//
//  INLGroup.h
//  Inline
//
//  Created by Ryan Davies on 28/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "INLNode.h"

/** Represents a group of tests and their hooks. */
@interface INLGroup : NSObject <INLNode>

/**
 Adds a node to the group.
 @param node The node to add. */
- (void)addNode:(id <INLNode>)node;

/**
 Remove a node.
 @param node The node to remove. */
- (void)removeNode:(id <INLNode>)node;

/** A list of the child groups that have been added to the group. */
@property (nonatomic, readonly) NSArray *groups;

/** A list of the tests that have been added to the group. */
@property (nonatomic, readonly) NSArray *tests;

/** A list of the hooks that have been added to the group. */
@property (nonatomic, readonly) NSArray *hooks;

@end
