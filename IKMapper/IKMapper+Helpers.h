//
//  IKMapper+Helpers.h
//  IKMapper
//
//  Created by Ian Keen on 2/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (IKMapper)
-(NSString *)toString;
@end

@interface NSString (IKMapper)
-(NSNumber *)toNumber;
@end