//
//  NSManagedObject+IKMapperIn.m
//  IKMapper
//
//  Created by Ian Keen on 10/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import "NSManagedObject+IKMapperIn.h"
#import "NSObject+IKIntrospection.h"
#import "IKMapper+Shared.h"
#import "IKMapper+Helpers.h"
#import "NSManagedObject+Introspection.h"
#import <IKCore/NSObject+Null.h>

@implementation NSManagedObject (IKMapperIn)
+(instancetype)instanceFromDictionary:(NSDictionary *)dictionary {
    id instance = [self new];
    [instance populateFromDictionary:dictionary];
    return instance;
}
-(void)populateFromDictionary:(NSDictionary *)dictionary {
    NSDictionary *incomingDictionary = [self incomingDictionary:dictionary];
    
    [self populateAttributes:incomingDictionary];
    [self populateRelationships:incomingDictionary];
}

#pragma mark - Private
-(void)populateAttributes:(NSDictionary *)incomingDictionary {
    [[[self entity] attributesByName] enumerateKeysAndObjectsUsingBlock:^(NSString *modelKey, NSAttributeDescription *attribute, BOOL *stop) {
        NSString *incomingKey = [self incomingKey:modelKey];
        
        id value = incomingDictionary[incomingKey];
        id incomingValue = [self incomingValue:value key:incomingKey];
        
        id convertedValue = [NSObject convertValue:incomingValue
                                              from:[incomingValue normalizedClass]
                                                to:[attribute normalizedAttributeClass]
                                           numeric:[attribute isNumeric]];
        
        if (![NSObject isNil:convertedValue]) {
            [self setValue:convertedValue forKey:modelKey];
        }
    }];
}
-(void)populateRelationships:(NSDictionary *)incomingDictionary {
    [[[self entity] relationshipsByName] enumerateKeysAndObjectsUsingBlock:^(NSString *relationshipKey, NSRelationshipDescription *relationship, BOOL *stop) {
        NSString *incomingKey = [self incomingKey:relationshipKey];
        
        id value = incomingDictionary[incomingKey];
        id incomingValue = [self incomingValue:value key:incomingKey];
        
        if (![NSObject nilOrEmpty:incomingValue]) {
            if (relationship.toMany && [incomingValue isKindOfClass:[NSArray class]]) {
                NSArray *objects = (NSArray *)incomingValue;
                if (![NSObject nilOrEmpty:objects] && [objects isKindOfClass:[NSArray class]]) {
                    NSMutableSet *set = [self mutableSetValueForKey:relationshipKey];
                    [objects enumerateObjectsUsingBlock:^(NSDictionary *object, NSUInteger idx, BOOL *stop) {
                        NSManagedObject *target = [self createRelatedObject:relationship dictionary:object];
                        [set addObject:target];
                    }];
                }
                
            } else if ([incomingValue isKindOfClass:[NSDictionary class]]) {
                NSDictionary *object = (NSDictionary *)incomingValue;
                if (![NSObject nilOrEmpty:object] && [object isKindOfClass:[NSDictionary class]]) {
                    NSManagedObject *target = [self createRelatedObject:relationship dictionary:object];
                    [self setValue:target forKey:relationshipKey];
                }
            }
        }
    }];
}
-(NSManagedObject *)createRelatedObject:(NSRelationshipDescription *)relationship dictionary:(NSDictionary *)dictionary {
    NSString *targetName = relationship.destinationEntity.managedObjectClassName;
    NSEntityDescription *description = [NSEntityDescription entityForName:targetName inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *target = [[NSManagedObject alloc] initWithEntity:description insertIntoManagedObjectContext:self.managedObjectContext];
    
    [target populateFromDictionary:dictionary];
    return target;
}
@end
