//
//  NSArray+First.m
//  IKCore
//
//  Created by Ian Keen on 29/06/2015.
//  Copyright (c) 2015 IanKeen. All rights reserved.
//

#import "NSArray+First.h"

@implementation NSArray (First)
-(id)first:(firstFunction)function {
    __block id result = nil;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (function(obj)) {
            result = obj;
            *stop = YES;
        }
    }];
    return result;
}
@end
