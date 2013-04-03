//
//  INLPassedState.h
//  Inline
//
//  Created by Ryan Davies on 02/04/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INLTestState.h"

/** The passed state of a test. */
@interface INLPassedState : NSObject <INLTestState>

/**
 Initialize a passed state.
 @param label The label for the passed state.
 @return An initialized passed state.
 */
- (id)initWithLabel:(NSString *)label;

@end