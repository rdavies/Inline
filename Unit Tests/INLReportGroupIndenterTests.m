//
//  INLReportGroupIndenterTests.m
//  Inline
//
//  Created by Ryan Davies on 07/04/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

@interface INLReportGroupIndenterTests : SenTestCase

@end

@implementation INLReportGroupIndenterTests

- (void)testWhenNotNestedDoesNotIndentGroup
{
    // given
    NSMutableString *output = [[NSMutableString alloc] init];
    INLReportGroupIndenter *indenter = [[INLReportGroupIndenter alloc] initWithOutput:output];
    id group = [OCMockObject niceMockForClass:[INLGroup class]];
    [[[group stub] andReturn:@"group"] label];
    
    // when
    [indenter didEnterGroup:group];
    [indenter didLeaveGroup:group];
    
    // then
    [[output should] beEqualTo:@""];
}

- (void)testWhenNestedOnceIndentsGroupOnce
{
    // given
    NSMutableString *output = [[NSMutableString alloc] init];
    INLReportGroupIndenter *indenter = [[INLReportGroupIndenter alloc] initWithOutput:output];
    id group = [OCMockObject niceMockForClass:[INLGroup class]];
    [[[group stub] andReturn:@"group"] label];
    
    // when
    [indenter didEnterGroup:group];
    [indenter didEnterGroup:group];
    [indenter didLeaveGroup:group];
    [indenter didLeaveGroup:group];
    
    // then
    [[output should] beEqualTo:@"\t"];
}

- (void)testWhenNestedTwiceIndentsTestTwice
{
    // given
    NSMutableString *output = [[NSMutableString alloc] init];
    INLReportGroupIndenter *indenter = [[INLReportGroupIndenter alloc] initWithOutput:output];
    id group = [OCMockObject niceMockForClass:[INLGroup class]];
    [[[group stub] andReturn:@"group"] label];
    
    // when
    [indenter didEnterGroup:group];
    [indenter didEnterGroup:group];
    [indenter didEnterGroup:group];
    [indenter didLeaveGroup:group];
    [indenter didLeaveGroup:group];
    [indenter didLeaveGroup:group];
    
    // then
    [[output should] beEqualTo:@"\t\t\t"];
}

- (void)testWhenSiblingGroupsNestedOnceIndentsEachOnce
{
    // given
    NSMutableString *output = [[NSMutableString alloc] init];
    INLReportGroupIndenter *indenter = [[INLReportGroupIndenter alloc] initWithOutput:output];
    id group = [OCMockObject niceMockForClass:[INLGroup class]];
    [[[group stub] andReturn:@"group"] label];
    
    // when
    [indenter didEnterGroup:group];
    [indenter didEnterGroup:group];
    [indenter didLeaveGroup:group];
    [indenter didEnterGroup:group];
    [indenter didLeaveGroup:group];
    [indenter didLeaveGroup:group];
    
    // then
    [[output should] beEqualTo:@"\t\t"];
}

@end
