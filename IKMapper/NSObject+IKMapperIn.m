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
#import "IKMapper+Helpers.h"

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
        id convertedValue = [self convertedValue:value property:property];
        id incomingValue = [self incomingValue:convertedValue key:incomingKey];
        
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
        
    } else if ([value isKindOfClass:[NSDictionary class]] && property.isCustomObject) {
        Class class = property.inferredClass;
        Class incomingClass = [self incomingClass:class value:value key:key];
        
        if (incomingClass != nil) {
            result = [property.inferredClass instanceFromDictionary:value];
        }
    }
    
    [self setValue:result forKey:property.name];
}
-(id)convertedValue:(id)value property:(IKProperty *)property {
    /**
     *  Don't bother with a conversion if:
     *  -value is nil
     *  -incoming value is NSNumber and the target property is numeric (KVO will take care of the unboxing)
     *  -target property type is primitive or undetermined (i.e. 'id')
     */
    if ((value == nil) ||
        ([value normalizedClass] == [NSNumber class] && property.isNumeric) ||
        ([property.type normalizedClassFromString] == nil)) {
        return value;
    }
    
    id result = value;
    NSString *valueClass = NSStringFromClass([result normalizedClass]);
    NSString *propertyClass = NSStringFromClass([property.type normalizedClassFromString]);
    if (![valueClass isEqualToString:propertyClass]) {
        if ([propertyClass isEqualToString:NSStringFromClass([NSString class])]) {
            /* Anything -> NSString */
            result = [result toString];
            
        } else if ([propertyClass isEqualToString:NSStringFromClass([NSNumber class])] &&
                   [valueClass isEqualToString:NSStringFromClass([NSString class])]) {
            /* NSString -> NSNumber */
            result = [((NSString *)result) toNumber];
        }
    }
    
    return result;
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
