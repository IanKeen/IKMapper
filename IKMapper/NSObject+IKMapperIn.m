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

@implementation NSObject (IKMapperIn)
+(instancetype)instanceFromDictionary:(NSDictionary *)dictionary {
    id instance = [self new];
    [instance populateFromDictionary:dictionary];
    return instance;
}
-(void)populateFromDictionary:(NSDictionary *)dictionary {
    NSDictionary *incomingDictionary = [self incomingDictionary:dictionary];
    
    NSArray *properties = [[[self class] objectIKProperties] filter:^BOOL(IKProperty *property) {
        return !property.readOnly && property.iVar;
    }];
    
    [properties enumerateObjectsUsingBlock:^(IKProperty *property, NSUInteger idx, BOOL *stop) {
        NSString *key = property.name;
        NSString *incomingKey = [self incomingKey:key];
        
        id value = incomingDictionary[incomingKey];
        id incomingValue = [self incomingValue:value key:incomingKey];
        if (![NSObject nilOrEmpty:incomingValue]) {
            [self mapValue:incomingValue key:incomingKey to:property];
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
        
    } else if ([value isKindOfClass:[NSDictionary class]] && property.object) {
        Class class = property.inferredClass;
        Class incomingClass = [self incomingClass:class value:value key:key];
        
        if (incomingClass != nil) {
            result = [property.inferredClass instanceFromDictionary:value];
        }
    }
    
    [self setValue:result forKey:property.name];
}

#pragma mark - Protocol Handlers
-(NSDictionary *)incomingDictionary:(NSDictionary *)dictionary {
    if ([self conformsToProtocol:@protocol(IKMapperIncomingProtocol)] &&
        [self respondsToSelector:@selector(transformIncomingDictionary:)]) {
        return [NSDictionary dictionaryWithDictionary:[((id<IKMapperIncomingProtocol>)self) transformIncomingDictionary:dictionary]];
    }
    return dictionary;
}
-(NSString *)incomingKey:(NSString *)key {
    if ([self conformsToProtocol:@protocol(IKMapperIncomingProtocol)] &&
        [self respondsToSelector:@selector(transformIncomingKey:)]) {
        return [((id<IKMapperIncomingProtocol>)self) transformIncomingKey:key];
    }
    return key;
}
-(id)incomingValue:(id)value key:(NSString *)key {
    if ([self conformsToProtocol:@protocol(IKMapperIncomingProtocol)] &&
        [self respondsToSelector:@selector(transformIncomingValue:key:)]) {
        return [((id<IKMapperIncomingProtocol>)self) transformIncomingValue:value key:key];
    }
    return value;
}
-(Class)incomingClass:(Class)class value:(id)value key:(NSString *)key {
    if ([self conformsToProtocol:@protocol(IKMapperIncomingProtocol)] &&
        [self respondsToSelector:@selector(transformIncomingClass:value:key:)]) {
        return [((id<IKMapperIncomingProtocol>)self) transformIncomingClass:class value:value key:key];
    }
    return class;
}
@end
