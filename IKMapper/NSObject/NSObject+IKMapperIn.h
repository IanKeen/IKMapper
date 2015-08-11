//
//  NSObject+IKMapper.h
//  IKMapper
//
//  Created by Ian Keen on 1/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (IKMapperIn)
+(instancetype)instanceFromDictionary:(NSDictionary *)dictionary;
-(void)populateFromDictionary:(NSDictionary *)dictionary;
@end
