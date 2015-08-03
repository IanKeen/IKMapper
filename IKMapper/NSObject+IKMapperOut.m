//
//  NSObject+IKMapperOut.m
//  IKMapper
//
//  Created by Ian Keen on 1/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import "NSObject+IKMapperOut.h"
#import "NSObject+IKIntrospection.h"
#import <IKCore/NSArray+Map.h>
#import <IKCore/NSArray+Filter.h>
#import <IKCore/NSObject+Null.h>
#import "IKMapperProtocols.h"

@implementation NSObject (IKMapperOut)
-(NSDictionary *)toDictionary {
    NSArray *properties = [[[self class] objectIKProperties] filter:^BOOL(IKProperty *property) {
        return property.hasiVar;
    }];
    
    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [properties enumerateObjectsUsingBlock:^(IKProperty *property, NSUInteger idx, BOOL *stop) {
        NSString *key = property.name;
        NSString *outgoingKey = [self outgoingKey:key];
        if ([NSObject nilOrEmpty:outgoingKey]) {
            id value = [self valueFromProperty:property key:outgoingKey];
            if (![NSObject nilOrEmpty:value]) {
                result[outgoingKey] = value;
            }
        }
    }];
    
    return [NSDictionary dictionaryWithDictionary:result];
}

#pragma mark - Private
-(id)valueFromProperty:(IKProperty *)property key:(NSString *)key {
    id value = [self valueForKey:property.name];
    id outgoingValue = [self outgoingValue:value key:key];
    
    if ([outgoingValue isKindOfClass:[NSArray class]]) {
        Class class = [property.name inferredClass];
        if (class) {
            outgoingValue = [((NSArray *)value) map:^id(id item) {
                return [item toDictionary];
            }];
        }
        
    } else if (property.isCustomObject && property.inferredClass != nil) {
        outgoingValue = [outgoingValue toDictionary];
    }
    
    return outgoingValue;
}

#pragma mark - Protocol Handlers
-(NSString *)outgoingKey:(NSString *)key {
    if ([self conformsToProtocol:@protocol(IKMapperOutgoingProtocol)] &&
        [self respondsToSelector:@selector(transformOutgoingKey:)]) {
        return [((id<IKMapperOutgoingProtocol>)self) transformOutgoingKey:key];
    }
    return key;
}
-(id)outgoingValue:(id)value key:(NSString *)key {
    if ([self conformsToProtocol:@protocol(IKMapperOutgoingProtocol)] &&
        [self respondsToSelector:@selector(transformOutgoingValue:key:)]) {
        return [((id<IKMapperOutgoingProtocol>)self) transformOutgoingValue:value key:key];
    }
    return value;
}
@end
