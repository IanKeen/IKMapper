//
//  NSObject+IKIntrospection.m
//  IKMapper
//
//  Created by Ian Keen on 1/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import "NSObject+IKIntrospection.h"
#import "NSString+InflectorKit.h"
#import <IKCore/NSArray+First.h>

@interface IKProperty ()
@property (nonatomic, strong) NSDictionary *propertyAttributes;
@end

@implementation IKProperty
-(instancetype)initWithProperty:(objc_property_t)property {
    if (!(self = [super init])) { return nil; }
    NSArray *pairs = [@(property_getAttributes(property)) componentsSeparatedByString:@","];
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithCapacity:[pairs count]];
    for(NSString *pair in pairs) {
        attributes[[pair substringToIndex:1]] = [pair substringFromIndex:1];
    }
    self.propertyAttributes = [NSDictionary dictionaryWithDictionary:attributes];
    
    _name = @(property_getName(property));
    
    return self;
}
-(NSString *)type {
    NSString *type = [[self.propertyAttributes[@"T"]
                       stringByReplacingOccurrencesOfString:@"\"" withString:@""]
                       stringByReplacingOccurrencesOfString:@"@" withString:@""];
    type = ([type isEqualToString:@""] ? @"id" : type);
    return type;
}
-(BOOL)hasiVar {
    return [self.propertyAttributes.allKeys containsObject:@"V"];
}
-(BOOL)isReadOnly {
    return [self.propertyAttributes.allKeys containsObject:@"R"];
}
-(BOOL)isCustomObject {
    Class class = NSClassFromString(self.type);
    if (class == nil) { return NO; }
    
    BOOL customClass = ([NSBundle bundleForClass:class] == [NSBundle mainBundle]);
    return (customClass && [self.propertyAttributes[@"T"] hasPrefix:@"@"]);
}
-(BOOL)isNumeric {
    NSArray *numericType = @[@"i", @"s", @"l", @"q", @"C", @"I", @"S", @"L", @"Q", @"f", @"d", @"@\"NSNumber\""];
    return [numericType containsObject:self.propertyAttributes[@"T"]];
}
-(Class)inferredClass {
    Class class = NSClassFromString(self.type);
    if (class == nil) { return nil; }
    
    BOOL customClass = ([NSBundle bundleForClass:class] == [NSBundle mainBundle]);
    return (customClass ? class : nil);
}
@end

@implementation NSObject (IKMapperIntrospection)
+(NSArray *)objectIKProperties {
    NSMutableArray *properties = [NSMutableArray array];
    
    Class superClass = class_getSuperclass(self);
    if (superClass != [NSObject class]) {
        [properties addObjectsFromArray:[superClass objectIKProperties]];
    }
    
    unsigned int propertyCount;
    objc_property_t *propertyList = class_copyPropertyList(self, &propertyCount);
    
    for (unsigned int index = 0; index < propertyCount; index++) {
        objc_property_t property = propertyList[index];
        [properties addObject:[[IKProperty alloc] initWithProperty:property]];
    }
    
    free(propertyList);
    return [NSArray arrayWithArray:properties];
}
-(Class)normalizedClass {
    Class class = [[[self class] normalizedClassList] first:^BOOL(Class item) {
        return [self isKindOfClass:item];
    }];
    
    return (class ?: [self class]);
}

+(NSArray *)normalizedClassList {
    static dispatch_once_t onceToken;
    static NSArray *classes = nil;
    dispatch_once(&onceToken, ^{
        classes = @[[NSString class], [NSNumber class], [NSDate class], [NSArray class], [NSDictionary class]];
    });
    return classes;
}
@end

@implementation NSString (IKMapperIntrospection)
-(Class)inferredClass {
    Class propertyNameClass = NSClassFromString(self);
    if (propertyNameClass) { return propertyNameClass; }
    
    NSString *singularPropertyName = [self singularizedString];
    singularPropertyName = [NSString stringWithFormat:@"%@%@",
                            [[singularPropertyName substringToIndex:1] uppercaseString],
                            [singularPropertyName substringFromIndex:1]];
    Class singularPropertyNameClass = NSClassFromString(singularPropertyName);
    if (singularPropertyNameClass) { return singularPropertyNameClass; }
    
    return nil;
}
-(Class)normalizedClassFromString {
    Class selfClass = NSClassFromString(self);
    if (selfClass == nil) { return nil; }
    
    Class class = [[[self class] normalizedClassList] first:^BOOL(Class item) {
        return [selfClass isSubclassOfClass:item];
    }];
    return class;
}
@end
