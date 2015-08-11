//
//  IKMapper+Shared.h
//  IKMapper
//
//  Created by Ian Keen on 10/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (IKMapperInShared)
-(NSDictionary *)incomingDictionary:(NSDictionary *)dictionary;
-(NSString *)incomingKey:(NSString *)key;
-(id)incomingValue:(id)value key:(NSString *)key;
@end

@interface NSObject (IKMapperOutShared)
-(NSString *)outgoingKey:(NSString *)key;
-(id)outgoingValue:(id)value key:(NSString *)key;
@end

@interface NSObject (IKMapperValueConversion)
+(id)convertValue:(id)value from:(Class)fromClass to:(Class)toClass numeric:(BOOL)numeric;
@end