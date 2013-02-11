//
//  INLTestSpec.m
//  Inline
//
//  Created by Ryan Davies on 28/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

SpecBegin(INLTest)

__block NSMutableArray *hooks;
__block NSMutableArray *groups;
__block NSMutableArray *order;
__block INLTest        *test;

before(^{
    hooks  = [NSMutableArray array];
    groups = [NSMutableArray array];
    order  = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < 3; i ++) {
        groups[i] = [[INLGroup alloc] init];
        if (i > 0) [groups[i-1] addNode:groups[i]];
        hooks[i] = [OCMockObject partialMockForObject:[[INLHook alloc] init]];
        [[[hooks[i] expect] andDo:^(NSInvocation *invocation) { [order addObject:hooks[i]]; }] execute];
        [groups[i] addNode:hooks[i]];
    }
    
    test = [[INLTest alloc] init];
    [[groups lastObject] addNode:test];
});

when(@"initialized", ^{
    it(@"is in 'pending' state", ^{
        expect([test state]).to.equal(INLTestStatePending);
    });
});

when(@"executing hooks", ^{
    void(^itIgnoresSiblingAndDeeperNestedHooks)(INLHookPlacement) = ^(INLHookPlacement placement) {
        it(@"ignores hooks in sibling groups", ^{
            id sibling = [OCMockObject niceMockForClass:[INLGroup class]];
            [[[sibling stub] andReturn:groups[1]] parent];
            id hook = [OCMockObject niceMockForClass:[INLHook class]];
            [[[hook stub] andReturn:sibling] parent];
            [[hook reject] execute];
            [test executeHooksInNodePath:[INLNodePath nodePathForDestinationNode:test] placement:placement];
            [hook verify];
        });
        
        it(@"ignores hooks in more deeply nested groups", ^{
            id descendant = [OCMockObject niceMockForClass:[INLGroup class]];
            [[[descendant stub] andReturn:groups[2]] parent];
            id hook = [OCMockObject niceMockForClass:[INLHook class]];
            [[[hook stub] andReturn:descendant] parent];
            [[hook reject] execute];
            [test executeHooksInNodePath:[INLNodePath nodePathForDestinationNode:test] placement:placement];
            [hook verify];
        });
    };
    
    context(@"with a placement of 'before'", ^{
        before(^{
            [hooks enumerateObjectsUsingBlock:^(id hook, NSUInteger idx, BOOL *stop) {
                [hook setPlacement:INLHookPlacementBefore];
            }];
        });
        
        void(^execute)(void) = ^(void) {
            [test executeHooksInNodePath:[INLNodePath nodePathForDestinationNode:test] placement:INLHookPlacementBefore];
        };
        
        it(@"executes hooks in forward order", ^{
            execute();
            expect(order[0]).to.beIdenticalTo(hooks[0]);
            expect(order[1]).to.beIdenticalTo(hooks[1]);
            expect(order[2]).to.beIdenticalTo(hooks[2]);
        });
        
        // This would be much easier if the return value of a stub could be modified.
        it(@"doesn't execute hooks with a placement of 'after'", ^{
            [groups[2] removeNode:hooks[2]];
            hooks[2] = [OCMockObject partialMockForObject:[INLHook new]];
            [hooks[2] setPlacement:INLHookPlacementAfter];
            [[hooks[2] reject] execute];
            [groups[2] addNode:hooks[2]];
            execute();
            [hooks[2] verify];
        });
        
        itIgnoresSiblingAndDeeperNestedHooks(INLHookPlacementBefore);
    });

    when(@"with a placement of 'after'", ^{
        before(^{
            [hooks enumerateObjectsUsingBlock:^(id hook, NSUInteger idx, BOOL *stop) {
                [hook setPlacement:INLHookPlacementAfter];
            }];
        });
        
        void(^execute)(void) = ^(void) {
            [test executeHooksInNodePath:[INLNodePath nodePathForDestinationNode:test] placement:INLHookPlacementAfter];
        };
        
        it(@"executes hooks in outward order", ^{
            execute();
            expect(order[0]).to.beIdenticalTo(hooks[2]);
            expect(order[1]).to.beIdenticalTo(hooks[1]);
            expect(order[2]).to.beIdenticalTo(hooks[0]);
        });
        
        it(@"doesn't execute hooks with a placement of 'before'", ^{
            [groups[2] removeNode:hooks[2]];
            hooks[2] = [OCMockObject partialMockForObject:[INLHook new]];
            [hooks[2] setPlacement:INLHookPlacementBefore];
            [[hooks[2] reject] execute];
            [groups[2] addNode:hooks[2]];
            execute();
            [hooks[2] verify];
        });
        
        itIgnoresSiblingAndDeeperNestedHooks(INLHookPlacementAfter);
    });
});

SpecEnd
