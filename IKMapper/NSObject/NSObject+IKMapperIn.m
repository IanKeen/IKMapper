//
//  NSObject+IKMapper.m
//  IKMapper
//
//  Created by Ian Keen on 1/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import "NSObject+IKMapperIn.h"
#import "NSObject+IKIntrospection.h"
#import <IKCore/NSArray+Filter.h>
#import <IKCore/NSArray+Map.h>
#import <IKCore/NSObject+Null.h>
#import "IKMapperProtocols.h"
#import "IKMapper+Shared.h"

@implementation NSObject (IKMapperIn)
+(instancetype)instanceFromDictionary:(NSDictionary *)dictionary {
    id instance = [self new];
    [instance populateFromDictionary:dictionary];
    return instance;
}
-(void)populateFromDictionary:(NSDictionary *)dictionary {
    NSDictionary *incomingDictionary = [self incomingDictionary:dictionary];
    
    NSArray *properties = [[[self class] objectIKProperties] filter:^BOOL(IKProperty *property) {
        return !property.isReadOnly && property.hasiVar;
    }];
    
    [properties enumerateObjectsUsingBlock:^(IKProperty *property, NSUInteger idx, BOOL *stop) {
        NSString *key = property.name;
        NSString *incomingKey = [self incomingKey:key];
        
        id value = incomingDictionary[incomingKey];
        id incomingValue = [self incomingValue:value key:incomingKey];
        
        id convertedValue = [NSObject convertValue:incomingValue
                                              from:[incomingValue normalizedClass]
                                                to:[property.type normalizedClassFromString]
                                           numeric:property.isNumeric];
        
        if (![NSObject nilOrEmpty:convertedValue]) {
            [self mapValue:convertedValue key:incomingKey to:property];
        }
    }];
}

#pragma mark - Private
-(void)mapValue:(id)value key:(NSString *)key to:(IKProperty *)property {
    id result = value;
    
    if ([value isKindOfClass:[NSArray class]]) {
        Class class = [property.name inferredClass];
        Class incomingClass = [self incomingClass:class value:value key:key];
        
        if (incomingClass != nil) {
            result = [((NSArray *)value) map:^id(NSDictionary *item) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    return [incomingClass instanceFromDictionary:item];
                }
                return nil;
            }];
        }
        
    } else if ([value isKindOfClass:[NSDictionary class]] && (property.isCustomObject || [property.type isEqualToString:@"id"])) {
        Class class = property.inferredClass;
        Class incomingClass = [self incomingClass:class value:value key:key];
        
        if (incomingClass != nil) {
            result = [incomingClass instanceFromDictionary:value];
        }
    }
    
    [self setValue:result forKey:property.name];
}

#pragma mark - Protocol Handlers
-(Class)incomingClass:(Class)class value:(id)value key:(NSString *)key {
    if ([self conformsToProtocol:@protocol(IKMapperIncomingProtocol)] &&
        [self respondsToSelector:@selector(transformIncomingClass:value:key:)]) {
        return [((id<IKMapperIncomingProtocol>)self) transformIncomingClass:class value:value key:key];
    }
    return class;
}
@end
