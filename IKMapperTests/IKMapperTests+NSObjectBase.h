//
//  IKMapperTests+NSObjectBase.m.h
//  IKMapper
//
//  Created by Ian Keen on 10/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TestObjects.h"
#import "NSObject+IKMapper.h"

@interface IKMapperTests_NSObjectBase : XCTestCase
-(NSDictionary *)parentDictionary;
-(NSDictionary *)childDictionary;
-(NSDate *)date;

-(Parent *)parentObject;
-(Child *)child:(NSDate *)date;
-(NSDictionary *)expectedDictionary;
@end