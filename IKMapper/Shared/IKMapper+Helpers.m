//
//  IKMapper+Helpers.m
//  IKMapper
//
//  Created by Ian Keen on 2/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import "IKMapper+Helpers.h"

@implementation NSObject (IKMapper)
-(NSString *)toString {
    return [NSString stringWithFormat:@"%@", self];
}
@end

@implementation NSString (IKMapper)
-(NSNumber *)toNumber {
    static dispatch_once_t onceToken;
    static NSNumberFormatter *formatter = nil;
    dispatch_once(&onceToken, ^{
        formatter = [NSNumberFormatter new];
    });
    return [formatter numberFromString:self];
}
@end