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
@property (readonly) BOOL iVar;
@property (readonly) BOOL readOnly;
@property (readonly) NSString *name;
@property (readonly) BOOL object;
@property (readonly) Class inferredClass;
@end

@interface NSObject (IKMapperIntrospection)
+(NSArray *)objectIKProperties;
@end

@interface NSString (IKMapperIntrospection)
-(Class)inferredClass;
@end