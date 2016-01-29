//
//  IKMapperTests+NSObjectBase.m
//  IKMapper
//
//  Created by Ian Keen on 10/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import "IKMapperTests+NSObjectBase.h"

@implementation IKMapperTests_NSObjectBase
-(NSDictionary *)parentDictionary {
    return @{
             @"string_Value": @"parent",
             @"number_Value": @10,
             @"stringDate_Value": @"2015-08-28T12:30:10+00:00", //August 28, 2015 @ 12:30pm (UTC) - IOS8601
             @"numberDate_Value": @1440765010, //August 28, 2015 @ 12:30pm (UTC) - Unix timestamp
             @"integer_Value": @"50",
             @"bool_Value": @YES,
             @"float_Value": @(0.5),
             @"double_Value": @(1.5),
             @"enum_Value": @(TestEnumTwo),
             @"child_Value": [self childDictionary],
             @"children": @[[self childDictionary], [self childDictionary]],
             };
}
-(NSDictionary *)childDictionary {
    return @{
             @"string_Value": @"child",
             @"number_Value": @20,
             @"stringDate_Value": @"2015-08-28T12:30:10+00:00", //August 28, 2015 @ 12:30pm (UTC) - IOS8601
             @"numberDate_Value": @1440765010, //August 28, 2015 @ 12:30pm (UTC) - Unix timestamp
             @"integer_Value": @"100",
             @"bool_Value": @NO,
             @"float_Value": @(5.5),
             @"double_Value": @(15.5),
             @"enum_Value": @(TestEnumOne),
             @"child_Value": @{
                     @"string_Value": @"child_child",
                     @"number_Value": @80,
                     @"stringDate_Value": @"2015-08-28T12:30:10+00:00", //August 28, 2015 @ 12:30pm (UTC) - IOS8601
                     @"numberDate_Value": @1440765010, //August 28, 2015 @ 12:30pm (UTC) - Unix timestamp
                     @"integer_Value": @"500",
                     @"bool_Value": @NO,
                     @"float_Value": @(55.5),
                     @"double_Value": @"105.5",
                     @"enum_Value": @(TestEnumZero),
                     },
             };
}
-(NSDate *)date {
    NSDateComponents *components = [NSDateComponents new];
    components.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    components.year = 2015;
    components.month = 8;
    components.day = 28;
    components.hour = 12;
    components.minute = 30;
    components.second = 10;
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
    return date;
}

-(Parent *)parentObject {
    NSDate *date = [self date];
    Parent *object = [Parent new];
    
    object.string_Value = @"string";
    object.number_Value = @40;
    object.stringDate_Value = date;
    object.numberDate_Value = date;
    object.integer_Value = 60;
    object.bool_Value = YES;
    object.float_Value = 0.5;
    object.double_Value = 1.5;
    object.enum_Value = TestEnumOne;
    object.child_Value = [self child:date];
    object.children = @[[self child:date], [self child:date]];
    
    return object;
}
-(Child *)child:(NSDate *)date {
    Child *object = [Child new];
    
    object.string_Value = @"child";
    object.number_Value = @60;
    object.stringDate_Value = date;
    object.numberDate_Value = date;
    object.integer_Value = 80;
    object.bool_Value = NO;
    object.float_Value = 10.5;
    object.double_Value = 15.5;
    object.enum_Value = TestEnumTwo;
    
    Child *child = [Child new];
    child.string_Value = @"child_child";
    child.number_Value = @120;
    child.stringDate_Value = date;
    child.numberDate_Value = date;
    child.integer_Value = 160;
    child.bool_Value = YES;
    child.float_Value = 105.5;
    child.double_Value = 155.5;
    child.enum_Value = TestEnumZero;
    
    object.child_Value = child;
    
    return object;
}
-(NSDictionary *)expectedDictionary {
    NSString *dateString = @"2015-08-28T05:30:10-08:00";
    
    return @{
             @"string_Value": @"string",
             @"number_Value": @40,
             @"stringDate_Value": dateString,
             @"numberDate_Value": dateString,
             @"integer_Value": @(60),
             @"bool_Value": @(YES),
             @"float_Value": @(0.5),
             @"double_Value": @(1.5),
             @"enum_Value": @(TestEnumOne),
             @"child_Value": @{
                     @"string_Value": @"child",
                     @"number_Value": @60,
                     @"stringDate_Value": dateString,
                     @"numberDate_Value": dateString,
                     @"integer_Value": @(80),
                     @"bool_Value": @(NO),
                     @"float_Value": @(10.5),
                     @"double_Value": @(15.5),
                     @"enum_Value": @(TestEnumTwo),
                     @"child_Value": @{
                             @"string_Value": @"child_child",
                             @"number_Value": @120,
                             @"stringDate_Value": dateString,
                             @"numberDate_Value": dateString,
                             @"integer_Value": @(160),
                             @"bool_Value": @(YES),
                             @"float_Value": @(105.5),
                             @"double_Value": @(155.5),
                             @"enum_Value": @(TestEnumZero),
                             },
                     },
             @"children": @[
                     @{
                         @"string_Value": @"child",
                         @"number_Value": @60,
                         @"stringDate_Value": dateString,
                         @"numberDate_Value": dateString,
                         @"integer_Value": @(80),
                         @"bool_Value": @(NO),
                         @"float_Value": @(10.5),
                         @"double_Value": @(15.5),
                         @"enum_Value": @(TestEnumTwo),
                         @"child_Value": @{
                                 @"string_Value": @"child_child",
                                 @"number_Value": @120,
                                 @"stringDate_Value": dateString,
                                 @"numberDate_Value": dateString,
                                 @"integer_Value": @(160),
                                 @"bool_Value": @(YES),
                                 @"float_Value": @(105.5),
                                 @"double_Value": @(155.5),
                                 @"enum_Value": @(TestEnumZero),
                                 },
                         },
                     @{
                         @"string_Value": @"child",
                         @"number_Value": @60,
                         @"stringDate_Value": dateString,
                         @"numberDate_Value": dateString,
                         @"integer_Value": @(80),
                         @"bool_Value": @(NO),
                         @"float_Value": @(10.5),
                         @"double_Value": @(15.5),
                         @"enum_Value": @(TestEnumTwo),
                         @"child_Value": @{
                                 @"string_Value": @"child_child",
                                 @"number_Value": @120,
                                 @"stringDate_Value": dateString,
                                 @"numberDate_Value": dateString,
                                 @"integer_Value": @(160),
                                 @"bool_Value": @(YES),
                                 @"float_Value": @(105.5),
                                 @"double_Value": @(155.5),
                                 @"enum_Value": @(TestEnumZero),
                                 },
                         },
                     ],
             };
}
@end
