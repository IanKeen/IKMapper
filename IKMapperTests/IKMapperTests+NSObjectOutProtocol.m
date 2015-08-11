//
//  IKMapperTests+NSObjectOutProtocol.m
//  IKMapper
//
//  Created by Ian Keen on 10/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import "IKMapperTests+NSObjectBase.h"
#import "IKMapperProtocols.h"

@interface ProtocolParentOut: Parent <IKMapperOutgoingProtocol>
@end
@implementation ProtocolParentOut
-(NSString *)transformOutgoingKey:(NSString *)key {
    if ([key isEqualToString:@"children"]) {
        return @"my_children";
    }
    return key;
}
-(id)transformOutgoingValue:(id)value key:(NSString *)key {
    if ([key isEqualToString:@"my_children"]) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:value];
        [array removeLastObject];
        return array;
    }
    return value;
}
-(BOOL)ignoreOutgoingKey:(NSString *)key {
    return [key isEqualToString:@"numberDate_Value"];
}
@end

@interface IKMapperTests_NSObjectOutProtocol : IKMapperTests_NSObjectBase
@end

@implementation IKMapperTests_NSObjectOutProtocol
-(ProtocolParentOut *)protocolParentOutObject {
    NSDate *date = [self date];
    ProtocolParentOut *object = [ProtocolParentOut new];
    
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

- (void)testNSObjectOutgoingProtocol {
    ProtocolParentOut *object = [self protocolParentOutObject];
    NSDictionary *dictionary = [object toDictionary];
    
    NSMutableDictionary *expectedDictionary = [NSMutableDictionary dictionaryWithDictionary:[self expectedDictionary]];
    NSMutableArray *my_children = [NSMutableArray arrayWithArray:expectedDictionary[@"children"]];
    [my_children removeLastObject];
    expectedDictionary[@"my_children"] = my_children;
    
    [expectedDictionary removeObjectForKey:@"children"];
    [expectedDictionary removeObjectForKey:@"numberDate_Value"];
    
    XCTAssertEqualObjects(dictionary, expectedDictionary);
}
@end
