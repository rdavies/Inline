//
//  INLHookTests.m
//  Inline
//
//  Created by Ryan Davies on 29/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

@interface INLHookTests : SenTestCase

@end

@implementation INLHookTests

- (void)testTellsVisitorToVisitTest
{
    // given
    INLHook *hook = [[INLHook alloc] initWithBlock:nil weight:nil];
    id visitor = [OCMockObject mockForProtocol:@protocol(INLVisitor)];
    [[visitor expect] visitHook:hook];
    
    // when
    [hook acceptVisitor:visitor];
    
    // then
    [visitor verify];
}

- (void)testExecutesBlock
{
    // given
    __block BOOL executed = NO;
    INLHookBlock block = ^{ executed = YES; };
    INLHook *hook = [[INLHook alloc] initWithBlock:block weight:nil];
    
    // when
    [hook run];
    
    // then
    [[@(executed) should] beTrue];
}

@end