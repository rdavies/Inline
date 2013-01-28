//
//  INLTestCase.h
//  Inline
//
//  Created by Ryan Davies on 18/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
@protocol INLBuilder, INLCompiler;
@class INLInvocation;

/** Extends SenTestCase to allow developers to use objects which conform to INLTestBuilder to create tests, and use objects which conform to INLTestCompiler to create invocations for them. This class is abstract and is intended to be subclassed. Class methods performed on a subclass apply only to that subclass, and not to the superclass or siblings. */
@interface INLTestCase : SenTestCase

/** Returns the builder assigned to the current class. */
+ (id<INLBuilder>)builder;

/** Assigns a builder to the current class. 
 @param builder The builder to assign. Must conform to INLTestBuilder. */
+ (void)setBuilder:(id<INLBuilder>)builder;

/** Returns the compiler assigned to the current class. */
+ (id<INLCompiler>)compiler;

/** Assigns a compiler to the current class.
 @param compiler The compiler to assign. Must conform to INLTestCompiler. */
+ (void)setCompiler:(id<INLCompiler>)compiler;

/** @return Returns an immutable list of the invocations added, generated by handing the builder's tests to the compiler. */
+ (NSArray *)testInvocations;

/** @return The list of superclasses for any subclass of SenTestCase, with the items in blacklistedClasses removed. Blacklisted classes do not show up in test results. */
+ (NSArray *)senAllSuperclasses;

/** @return A list of classes which should not appear in the test results. */
+ (NSArray *)blacklistedClasses;

/** @return The name of the current test. */
- (NSString *)name;

@end
