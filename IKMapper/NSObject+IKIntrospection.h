//
//  NSObject+IKIntrospection.h
//  IKMapper
//
//  Created by Ian Keen on 1/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface IKProperty : NSObject
-(instancetype)initWithProperty:(objc_property_t)property;
@property (readonly) NSString *name;
@property (readonly) NSString *type;
@property (readonly) BOOL hasiVar;
@property (readonly) BOOL isReadOnly;
@property (readonly) BOOL isNumeric;
@property (readonly) BOOL isCustomObject;
@property (readonly) Class inferredClass;
@end

@interface NSObject (IKMapperIntrospection)
+(NSArray *)objectIKProperties;
-(Class)normalizedClass;
@end

@interface NSString (IKMapperIntrospection)
-(Class)inferredClass;
-(Class)normalizedClassFromString;
@end