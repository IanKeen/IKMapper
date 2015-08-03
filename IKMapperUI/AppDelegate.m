//
//  AppDelegate.m
//  IKMapper
//
//  Created by Ian Keen on 1/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import "AppDelegate.h"
#import "NSObject+IKMapperIn.h"
#import "NSObject+IKMapperOut.h"

@interface AppDelegate ()
@end

typedef NS_ENUM(NSInteger, MyEnum) {
    MyEnumNA = -1,
    MyEnumYES,
    MyEnumNO,
};

@interface Child : NSObject
@property (nonatomic, strong) NSString *myString;
@property (nonatomic, strong) id someObject;
@property (nonatomic, assign) BOOL boolean;
@end
@implementation Child
@end

@interface Parent : NSObject
@property (nonatomic, strong) NSNumber *myNumber;
@property (nonatomic, assign) CGFloat myFloat;
@property (nonatomic, strong) NSArray *children;
@property (nonatomic, readonly) NSInteger blah;
@property (nonatomic, assign) MyEnum myEnum;
@property (nonatomic, strong) NSString *rootString;
@end
@implementation Parent
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    Parent *obj = [Parent new];
    [obj populateFromDictionary:@{@"myNumber": @"54645", @"rootString": @4567, @"myFloat": @"6.5", @"blah": @"blhablha", @"myEnum": @(-1),
                                  @"children":
                                      @[
  @{@"myString": @"stringy string!", @"someObject": @42, @"boolean": @YES},
  @{@"myString": @"something else!", @"someObject": @{@"test": @"keykey"}, @"boolean": @NO}
                                        ]}
     ];
    
    NSDictionary *dict = [obj toDictionary];
    
    return YES;
}
@end
