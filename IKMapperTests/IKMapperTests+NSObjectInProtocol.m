//
//  IKMapperTests+NSObjectInProtocol.m
//  IKMapper
//
//  Created by Ian Keen on 10/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IKMapperTests+NSObjectBase.h"
#import "IKMapperProtocols.h"

@interface ProtocolChildIn : Child
@property (nonatomic, copy) NSString *extra_value;
@end
@implementation ProtocolChildIn
@end

@interface ProtocolParentIn : Parent <IKMapperIncomingProtocol>
@end
@implementation ProtocolParentIn
-(NSDictionary *)transformIncomingDictionary:(NSDictionary *)dictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    result[@"some_random_key"] = result[@"children"];
    [result removeObjectForKey:@"children"];
    return result;
}
-(NSString *)transformIncomingKey:(NSString *)key {
    if ([key isEqualToString:@"children"]) {
        return @"some_random_key";
    }
    return key;
}
-(id)transformIncomingValue:(id)value key:(NSString *)key {
    if ([key isEqualToString:@"child_Value"]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:value];
        dict[@"extra_value"] = @"!!!";
        return dict;
    }
    return value;
}
-(Class)transformIncomingClass:(Class)class value:(id)value key:(NSString *)key {
    if ([key isEqualToString:@"child_Value"]) {
        return [ProtocolChildIn class];
    }
    return class;
}
@end

@interface IKMapperTests_NSObjectInProtocol : IKMapperTests_NSObjectBase
@end

@implementation IKMapperTests_NSObjectInProtocol
-(void)testNSObjectIncomingProtocol {
    ProtocolParentIn *object = [ProtocolParentIn instanceFromDictionary:[self parentDictionary]];
    
    NSDate *date = [self date];
    
    XCTAssertEqualObjects(object.string_Value, @"parent");
    XCTAssertEqualObjects(object.number_Value, @10);
    XCTAssertEqualObjects(object.stringDate_Value, date);
    XCTAssertEqualObjects(object.numberDate_Value, date);
    XCTAssertEqual(object.integer_Value, 50);
    XCTAssertEqual(object.bool_Value, YES);
    XCTAssertEqual(object.float_Value, 0.5);
    XCTAssertEqual(object.double_Value, 1.5);
    XCTAssertEqual(object.enum_Value, TestEnumTwo);
    
    Child *child = object.child_Value;
    [self assertChildValues:child date:date protocol:YES];
    
    XCTAssertEqual(object.children.count, 2);
    [self assertChildValues:object.children.firstObject date:date protocol:NO];
    [self assertChildValues:object.children.lastObject date:date protocol:NO];
}
-(void)assertChildValues:(Child *)child date:(NSDate *)date protocol:(BOOL)protocol {
    if (protocol) {
        XCTAssertTrue([child isKindOfClass:[ProtocolChildIn class]]);
        XCTAssertEqualObjects(((ProtocolChildIn *)child).extra_value, @"!!!");
    }
    
    XCTAssertEqualObjects(child.string_Value, @"child");
    XCTAssertEqualObjects(child.number_Value, @20);
    XCTAssertEqualObjects(child.stringDate_Value, date);
    XCTAssertEqualObjects(child.numberDate_Value, date);
    XCTAssertEqual(child.integer_Value, 100);
    XCTAssertEqual(child.bool_Value, NO);
    XCTAssertEqual(child.float_Value, 5.5);
    XCTAssertEqual(child.double_Value, 15.5);
    XCTAssertEqual(child.enum_Value, TestEnumOne);
    
    Child *subChild = child.child_Value;
    XCTAssertEqualObjects(subChild.string_Value, @"child_child");
    XCTAssertEqualObjects(subChild.number_Value, @80);
    XCTAssertEqualObjects(subChild.stringDate_Value, date);
    XCTAssertEqualObjects(subChild.numberDate_Value, date);
    XCTAssertEqual(subChild.integer_Value, 500);
    XCTAssertEqual(subChild.bool_Value, NO);
    XCTAssertEqual(subChild.float_Value, 55.5);
    XCTAssertEqual(subChild.double_Value, 105.5);
    XCTAssertEqual(subChild.enum_Value, TestEnumZero);
}
@end
