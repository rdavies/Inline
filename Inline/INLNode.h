//
//  INLNode.h
//  Inline
//
//  Created by Ryan Davies on 08/02/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
@class INLGroup;

/** The superclass to elements that can appear in a group. */
@interface INLNode : NSObject

/** The parent group of the node. */
@property (weak, nonatomic) INLGroup *parent;

/** The label by which to identify the node; not applicable to all. */
@property (copy, nonatomic) NSString *label;

@end