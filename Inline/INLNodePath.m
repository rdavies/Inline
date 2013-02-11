//
//  INLNodePath.m
//  Inline
//
//  Created by Ryan Davies on 10/02/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "INLNodePath.h"
#import "INLNode.h"
#import "INLGroup.h"

@interface INLNodePath ()
@property (strong, nonatomic) NSArray *nodes;
@property (strong, nonatomic) INLNode *destinationNode;
@end

@implementation INLNodePath

+ (instancetype)nodePathForDestinationNode:(INLNode *)destinationNode
{
    NSAssert(destinationNode, @"Must be passed a destination node.");
    return [[self alloc] initWithDestinationNode:destinationNode];
}

- (id)initWithDestinationNode:(INLNode *)destinationNode
{
    NSAssert(destinationNode, @"Must be passed a destination node.");
    
    if (self = [super init]) {
        self.nodes           = [self parentsOfNode:destinationNode];
        self.destinationNode = destinationNode;
    }
    
    return self;
}

- (NSArray *)parentsOfNode:(INLNode *)node
{
    NSAssert(node, @"Must be passed a node.");
    
    if ([node parent] == nil) return @[];
    NSArray *path = [NSArray array];
    path = [path arrayByAddingObjectsFromArray:[self parentsOfNode:[node parent]]];
    path = [path arrayByAddingObject:[node parent]];
    
    return path;
}

@end
