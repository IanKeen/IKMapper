//
//  IKMapperProtocols.h
//  IKMapper
//
//  Created by Ian Keen on 1/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IKMapperIncomingProtocol <NSObject>
@optional
-(NSDictionary *)transformIncomingDictionary:(NSDictionary *)dictionary;
-(NSString *)transformIncomingKey:(NSString *)key;
-(id)transformIncomingValue:(id)value key:(NSString *)key;
-(Class)transformIncomingClass:(Class)class value:(id)value key:(NSString *)key;
@end

@protocol IKMapperOutgoingProtocol <NSObject>
@optional
-(NSString *)transformOutgoingKey:(NSString *)key;
-(id)transformOutgoingValue:(id)value key:(NSString *)key;
-(BOOL)ignoreOutgoingKey:(NSString *)key;
@end


@protocol IKMapperImportProtocol <NSObject>
-(NSString *)primaryKey;
@end