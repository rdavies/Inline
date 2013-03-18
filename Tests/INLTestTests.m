//
//  INLTestTests.m
//  Inline
//
//  Created by Ryan Davies on 28/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

@interface INLTestTests : SenTestCase
@end

@implementation INLTestTests

- (void)testTellsVisitorToVisitTest
{
    // given
    INLTest *test = [[INLTest alloc] initWithLabel:nil block:nil];
    id visitor = [OCMockObject mockForProtocol:@protocol(INLVisitor)];
    [[visitor expect] visitTest:test];
    
    // when
    [test acceptVisitor:visitor];
    
    // then
    [visitor verify];
}

- (void)testUsesLabelAsDescription
{
    // given
    INLTest *test = [[INLTest alloc] initWithLabel:@"Test" block:nil];
    
    // then
    [[[test description] should] beEqualTo:@"Test"];
}

- (void)testExecutesBlock
{
    // given
    __block BOOL executed = NO;
    INLTestBlock block = ^{ executed = YES; };
    INLTest *test = [[INLTest alloc] initWithLabel:nil block:block];
    
    // when
    [test run];
    
    // then
    [[@(executed) should] beTrue];
}

@end
