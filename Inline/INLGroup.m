// The MIT License
// 
// Copyright (c) 2013 Ryan Davies
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "INLGroup.h"
#import "INLCompiler.h"

@interface INLGroup ()
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) CBDSortedArray *components;
@property (copy, nonatomic) NSNumber *weight;
@end

@implementation INLGroup

- (id)initWithName:(NSString *)name components:(CBDSortedArray *)components weight:(NSNumber *)weight
{
    if (self = [super init]) {
        [self setName:name];
        [self setComponents:components];
        [self setWeight:weight];
    }
    return self;
}

- (void)compileWithCompiler:(id<INLCompiler>)compiler
{
    [compiler willCompileComponentsOfGroup:self];
    [[self components] enumerateObjectsUsingBlock:^(id<INLComponent> component, NSUInteger idx, BOOL *stop) {
        [component compileWithCompiler:compiler];
    }];
    [compiler didCompileComponentsOfGroup:self];
}

@end
