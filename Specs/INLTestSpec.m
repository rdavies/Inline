//
//  INLTestSpec.m
//  Inline
//
//  Created by Ryan Davies on 28/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

SpecBegin(INLTest)

void(^itShouldBehaveLikeANode)(Class) = ^(Class klass) {
    // TODO: Use shared examples to use this across INLGroup, INLTest, and INLHook without repeating.
    
    when(@"initialized with a parent", ^{
        it(@"is marked as belonging to the given parent", ^{
            INLGroup *parent = [[INLGroup alloc] init];
            INLNode *child = [[klass alloc] initWithParent:parent];
            expect([child parent]).to.beIdenticalTo(parent);
        });
    });
    
    describe(@"path", ^{
        it(@"is built up of the groups leading to the test", ^{
            NSMutableArray *groups = [NSMutableArray array];
            for (NSUInteger i = 0; i < 5; i ++) groups[i] = [[INLGroup alloc] initWithParent:((i > 0) ? groups[i-1] : nil)];
            INLNode *node = [[klass alloc] initWithParent:[groups lastObject]];
            for (NSUInteger i = 0; i < 5; i ++) expect([node path][i]).to.beIdenticalTo(groups[i]);
        });
    });
};

__block NSMutableArray *hooks;
__block NSMutableArray *groups;
__block NSMutableArray *order;
__block INLTest        *test;

before(^{
    hooks  = [NSMutableArray array];
    groups = [NSMutableArray array];
    order  = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < 3; i ++) {
        groups[i] = [[INLGroup alloc] initWithParent:((i > 0) ? groups[i-1] : nil)];
        hooks[i] = [OCMockObject partialMockForObject:[[INLHook alloc] init]];
        [[[hooks[i] expect] andDo:^(NSInvocation *invocation) { [order addObject:hooks[i]]; }] execute];
        [groups[i] addHook:hooks[i]];
    }
    
    test = [[INLTest alloc] initWithParent:[groups lastObject]];
});

itShouldBehaveLikeANode([INLTest class]);

when(@"initialized", ^{
    it(@"is in 'pending' state", ^{
        expect([test state]).to.equal(INLTestStatePending);
    });
});

when(@"initialized with a parent", ^{
    it(@"is in 'pending' state", ^{
        expect([test state]).to.equal(INLTestStatePending);
    });
});

when(@"before hooks are executed", ^{
    before(^{
        [hooks enumerateObjectsUsingBlock:^(id hook, NSUInteger idx, BOOL *stop) {
            [hook setPlacement:INLHookPlacementBefore];
        }];
    });
    
    it(@"executes hooks in forward order", ^{
        [test executeBeforeHooks];
        expect(order[0]).to.beIdenticalTo(hooks[0]);
        expect(order[1]).to.beIdenticalTo(hooks[1]);
        expect(order[2]).to.beIdenticalTo(hooks[2]);
    });
    
    // This would be much easier if the return value of a stub could be modified.
    it(@"doesn't execute hooks with a placement of 'after'", ^{
        id hook = [OCMockObject partialMockForObject:[INLHook new]];
        [hook setPlacement:INLHookPlacementAfter];
        [[hook reject] execute];
        [groups[2] setHooks:@[hook]];
        [test executeBeforeHooks];
        [hook verify];
    });
    
    it(@"ignores hooks in sibling groups", ^{
        id sibling = [OCMockObject niceMockForClass:[INLGroup class]];
        [[[sibling stub] andReturn:groups[1]] parent];
        id hook = [OCMockObject niceMockForClass:[INLHook class]];
        [[[hook stub] andReturn:sibling] parent];
        [[hook reject] execute];
        [test executeBeforeHooks];
        [hook verify];
    });
    
    it(@"ignores hooks in more deeply nested groups", ^{
        id descendant = [OCMockObject niceMockForClass:[INLGroup class]];
        [[[descendant stub] andReturn:groups[2]] parent];
        id hook = [OCMockObject niceMockForClass:[INLHook class]];
        [[[hook stub] andReturn:descendant] parent];
        [[hook reject] execute];
        [test executeBeforeHooks];
        [hook verify];
    });
});

when(@"after hooks are executed", ^{
    before(^{
        [hooks enumerateObjectsUsingBlock:^(id hook, NSUInteger idx, BOOL *stop) {
            [hook setPlacement:INLHookPlacementAfter];
        }];
    });
    
    it(@"executes hooks in outward order", ^{
        [test executeAfterHooks];
        expect(order[0]).to.beIdenticalTo(hooks[2]);
        expect(order[1]).to.beIdenticalTo(hooks[1]);
        expect(order[2]).to.beIdenticalTo(hooks[0]);
    });
    
    it(@"doesn't execute hooks with a placement of 'before'", ^{
        id hook = [OCMockObject partialMockForObject:[INLHook new]];
        [hook setPlacement:INLHookPlacementBefore];
        [[hook reject] execute];
        [groups[2] setHooks:@[hook]];
        [test executeAfterHooks];
        [hook verify];
    });
    
    it(@"ignores hooks in sibling groups", ^{
        id sibling = [OCMockObject niceMockForClass:[INLGroup class]];
        [[[sibling stub] andReturn:groups[1]] parent];
        
        id hook = [OCMockObject niceMockForClass:[INLHook class]];
        [[[hook stub] andReturn:sibling] parent];
        [[hook reject] execute];
        
        [test executeAfterHooks];
        [hook verify];
    });
    
    it(@"ignores hooks in more deeply nested groups", ^{
        id descendant = [OCMockObject niceMockForClass:[INLGroup class]];
        [[[descendant stub] andReturn:groups[2]] parent];
        
        id hook = [OCMockObject niceMockForClass:[INLHook class]];
        [[[hook stub] andReturn:descendant] parent];
        [[hook reject] execute];
        
        [test executeAfterHooks];
        [hook verify];
    });
});

SpecEnd
