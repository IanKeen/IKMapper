//
//  IKMapper+Shared.m
//  IKMapper
//
//  Created by Ian Keen on 10/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import "IKMapper+Shared.h"
#import "IKMapperProtocols.h"
#import <IKCore/NSObject+Null.h>
#import "IKMapper+Helpers.h"
#import <ISO8601/ISO8601.h>

@implementation NSObject (IKMapperInShared)
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
@end

@implementation NSObject (IKMapperOutShared)
-(NSString *)outgoingKey:(NSString *)key {
    if ([self conformsToProtocol:@protocol(IKMapperOutgoingProtocol)] &&
        [self respondsToSelector:@selector(ignoreOutgoingKey:)]) {
        if ([((id<IKMapperOutgoingProtocol>)self) ignoreOutgoingKey:key]) {
            return nil;
        }
    }
    
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

@implementation NSObject (IKMapperValueConversion)
+(id)convertValue:(id)value from:(Class)fromClass to:(Class)toClass numeric:(BOOL)numeric {
    /**
     *  Don't bother with a conversion if:
     *  -value is nil
     *  -incoming value is NSNumber and the target property is numeric (KVO will take care of the unboxing)
     *  -target property type is primitive or undetermined (i.e. 'id')
     */
    if (([NSObject nilOrEmpty:value]) ||
        (fromClass == [NSNumber class] && numeric) ||
        (toClass == nil)) {
        return value;
    }
    
    id result = value;
    NSString *valueClass = NSStringFromClass(fromClass);
    NSString *propertyClass = NSStringFromClass(toClass);
    if (![valueClass isEqualToString:propertyClass]) {
        if ([propertyClass isEqualToString:NSStringFromClass([NSString class])]) {
            /* Anything -> NSString */
            result = [result toString];
            
        } else if ([propertyClass isEqualToString:NSStringFromClass([NSNumber class])] &&
                   [valueClass isEqualToString:NSStringFromClass([NSString class])]) {
            /* NSString -> NSNumber */
            result = [((NSString *)result) toNumber];
            
        } else if ([propertyClass isEqualToString:NSStringFromClass([NSDate class])]) {
            if ([valueClass isEqualToString:NSStringFromClass([NSString class])]) {
                /* NSString -> NSDate */
                return [NSDate dateWithISO8601String:value];
                
            } else if ([valueClass isEqualToString:NSStringFromClass([NSNumber class])]) {
                /* NSNumber -> NSDate */
                return [NSDate dateWithTimeIntervalSince1970:[value integerValue]];
            }
        }
    }
    
    return result;
}
@end