//
//  TestObjects.h
//  IKMapper
//
//  Created by Ian Keen on 10/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TestEnum) {
    TestEnumZero = 0,
    TestEnumOne,
    TestEnumTwo,
};

@class Child;
@interface Parent : NSObject
@property (nonatomic, copy) NSString *string_Value;
@property (nonatomic, copy) NSNumber *number_Value;
@property (nonatomic, copy) NSDate *stringDate_Value;
@property (nonatomic, copy) NSDate *numberDate_Value;
@property (nonatomic, assign) NSInteger integer_Value;
@property (nonatomic, assign) BOOL bool_Value;
@property (nonatomic, assign) CGFloat float_Value;
@property (nonatomic, assign) double double_Value;
@property (nonatomic, assign) TestEnum enum_Value;
@property (nonatomic, strong) Child *child_Value;
@property (nonatomic, copy) NSArray *children;
@end

@interface Child : NSObject
@property (nonatomic, copy) NSString *string_Value;
@property (nonatomic, copy) NSNumber *number_Value;
@property (nonatomic, copy) NSDate *stringDate_Value;
@property (nonatomic, copy) NSDate *numberDate_Value;
@property (nonatomic, assign) NSInteger integer_Value;
@property (nonatomic, assign) BOOL bool_Value;
@property (nonatomic, assign) CGFloat float_Value;
@property (nonatomic, assign) double double_Value;
@property (nonatomic, assign) TestEnum enum_Value;
@property (nonatomic, strong) Child *child_Value;
@end
