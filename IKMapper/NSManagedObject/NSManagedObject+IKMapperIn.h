//
//  NSManagedObject+IKMapperIn.h
//  IKMapper
//
//  Created by Ian Keen on 10/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

@import CoreData;

@interface NSManagedObject (IKMapperIn)
+(instancetype)instanceFromDictionary:(NSDictionary *)dictionary;
-(void)populateFromDictionary:(NSDictionary *)dictionary;
@end
