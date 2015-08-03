//
//  NSArray+Group
//
//  Created by Ian Keen on 12/06/2015.
//  Copyright (c) 2015 IanKeen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^groupFunction)(id item);

@interface NSArray (Group)
/**
 *  Group elements in the receiver by the value returned by `function`
 *
 *  @param function a block that takes an array element and returns a value used for grouping. If the return value is nil the element is not included in the final output
 *
 *  @return an NSDictionary containing the receivers elements grouped by the function output
 */
-(NSDictionary *)groupBy:(groupFunction)function;
@end
