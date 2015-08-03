//
//  NSArray+First.h
//  IKCore
//
//  Created by Ian Keen on 29/06/2015.
//  Copyright (c) 2015 IanKeen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL (^firstFunction)(id item);

@interface NSArray (First)
/**
 *  Calls `function` on each element in the receiver, returns the first element whose function is `YES`, returns Nil if none do
 *
 *  @param function a function to determine if this element is the one we want
 *
 *  @return the first matching element or nil if there were not any matches
 */
-(id)first:(firstFunction)function;
@end
