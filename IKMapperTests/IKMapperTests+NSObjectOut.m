//
//  IKMapperTests+NSObjectOut.m
//  IKMapper
//
//  Created by Ian Keen on 10/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import "IKMapperTests+NSObjectBase.h"

@interface IKMapperTests_NSObjectOut : IKMapperTests_NSObjectBase
@end

@implementation IKMapperTests_NSObjectOut
-(void)testNSObjectOutput {
    Parent *object = [self parentObject];
    NSDictionary *dictionary = [object toDictionary];
    NSDictionary *expectedDictionary = [self expectedDictionary];
    XCTAssertEqualObjects(dictionary, expectedDictionary);
}
@end
