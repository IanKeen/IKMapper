//
//  NSManagedObject+IKMapperOut.h
//  IKMapper
//
//  Created by Ian Keen on 10/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

@import CoreData;

@interface NSManagedObject (IKMapperOut)
-(NSDictionary *)toDictionary;
@end
