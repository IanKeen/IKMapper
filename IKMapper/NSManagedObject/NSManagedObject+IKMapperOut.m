//
//  NSManagedObject+IKMapperOut.m
//  IKMapper
//
//  Created by Ian Keen on 10/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import "NSManagedObject+IKMapperOut.h"
#import "IKMapper+Shared.h"
#import "NSObject+IKIntrospection.h"
#import <IKCore/NSObject+Null.h>
#import <IKCore/NSArray+Map.h>
#import <ISO8601/ISO8601.h>

@implementation NSManagedObject (IKMapperOut)
-(NSDictionary *)toDictionary {
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result addEntriesFromDictionary:[self dictionaryAttributes]];
    [result addEntriesFromDictionary:[self dictionaryRelationships]];
    return [NSDictionary dictionaryWithDictionary:result];
}

#pragma mark - Private
-(NSDictionary *)dictionaryAttributes {
    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [[[self entity] attributesByName] enumerateKeysAndObjectsUsingBlock:^(NSString *modelKey, NSAttributeDescription *attribute, BOOL *stop) {
        NSString *outgoingKey = [self outgoingKey:modelKey];
        if (![NSObject isNil:outgoingKey]) {
            id value = [self valueFromProperty:attribute key:outgoingKey];
            if (![NSObject isNil:value]) {
                result[outgoingKey] = value;
            }
        }
    }];
    return [NSDictionary dictionaryWithDictionary:result];
}
-(NSDictionary *)dictionaryRelationships {
    NSMutableDictionary *result = [NSMutableDictionary new];
    [[[self entity] relationshipsByName] enumerateKeysAndObjectsUsingBlock:^(NSString *relationshipKey, NSRelationshipDescription *relationship, BOOL *stop) {
        if (relationship.toMany) {
            NSSet *set = [self mutableSetValueForKey:relationshipKey];
            NSArray *objects = [set.allObjects map:^NSDictionary *(NSManagedObject *object) {
                return [object toDictionary];
            }];
            result[relationshipKey] = objects;
            
        } else {
            NSManagedObject *object = [self valueForKey:relationshipKey];
            if (![NSObject isNil:object] && [object isKindOfClass:[NSManagedObject class]]) {
                result[relationshipKey] = [object toDictionary];
            }
        }
    }];
    return result;
}
-(id)valueFromProperty:(NSAttributeDescription *)property key:(NSString *)key {
    id value = [self valueForKey:property.name];
    id outgoingValue = [self outgoingValue:value key:key];
    
    if ([outgoingValue isKindOfClass:[NSDate class]]) {
        outgoingValue = [((NSDate *)outgoingValue) ISO8601String];
    }
    
    return outgoingValue;
}
@end
