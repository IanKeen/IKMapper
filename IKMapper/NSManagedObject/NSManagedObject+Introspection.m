//
//  NSManagedObject+Introspection.m
//  IKMapper
//
//  Created by Ian Keen on 10/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import "NSManagedObject+Introspection.h"
#import "NSObject+IKIntrospection.h"
#import <IKCore/NSArray+First.h>

@interface NSObject (IKMapperIntrospection_Private)
+(NSArray *)normalizedClassList;
@end

@implementation NSAttributeDescription (IKMapperIntrospection)
-(BOOL)isNumeric {
    NSAttributeType type = self.attributeType;
    return ((type == NSInteger16AttributeType) ||
            (type == NSInteger32AttributeType) ||
            (type == NSInteger64AttributeType) ||
            (type == NSBooleanAttributeType) ||
            (type == NSFloatAttributeType) ||
            (type == NSDoubleAttributeType) ||
            (type == NSDecimalAttributeType));
}
-(Class)normalizedAttributeClass {
    Class class = [[[self class] normalizedClassList] first:^BOOL(Class item) {
        return [self isKindOfClass:item];
    }];
    
    return (class ?: [self class]);
}
@end
