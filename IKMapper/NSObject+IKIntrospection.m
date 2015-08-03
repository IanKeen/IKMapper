//
//  NSObject+IKIntrospection.m
//  IKMapper
//
//  Created by Ian Keen on 1/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import "NSObject+IKIntrospection.h"
#import "NSString+InflectorKit.h"

@interface IKProperty ()
@property (nonatomic, strong) NSDictionary *propertyAttributes;
@end

@implementation IKProperty
-(instancetype)initWithProperty:(objc_property_t)property {
    if (!(self = [super init])) { return nil; }
    _name = @(property_getName(property));
    NSArray *pairs = [@(property_getAttributes(property)) componentsSeparatedByString:@","];
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithCapacity:[pairs count]];
    for(NSString *pair in pairs) {
        attributes[[pair substringToIndex:1]] = [pair substringFromIndex:1];
    }
    self.propertyAttributes = [NSDictionary dictionaryWithDictionary:attributes];
    return self;
}
-(BOOL)iVar {
    return [self.propertyAttributes.allKeys containsObject:@"V"];
}
-(BOOL)readOnly {
    return [self.propertyAttributes.allKeys containsObject:@"R"];
}
-(BOOL)object {
    NSString *className = [[self.propertyAttributes[@"T"]
                            stringByReplacingOccurrencesOfString:@"\"" withString:@""]
                           stringByReplacingOccurrencesOfString:@"@" withString:@""];
    Class class = NSClassFromString(className);
    BOOL customClass = ([NSBundle bundleForClass:class] == [NSBundle mainBundle]);
    return (customClass && [self.propertyAttributes[@"T"] hasPrefix:@"@"]);
}
-(Class)inferredClass {
    NSString *className = [[self.propertyAttributes[@"T"]
                            stringByReplacingOccurrencesOfString:@"\"" withString:@""]
                           stringByReplacingOccurrencesOfString:@"@" withString:@""];
    Class class = NSClassFromString(className);
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
@end
