//
//  NSManagedObject+IKMapperImport.m
//  IKMapper
//
//  Created by Ian Keen on 10/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import "NSManagedObject+IKMapperImport.h"
#import "NSManagedObject+IKMapperIn.h"
#import <IKCore/NSObject+Null.h>
#import <IKCore/NSArray+Filter.h>

static NSInteger batchSize = 50;

@implementation NSManagedObject (IKMapperImport)
+(void)importFromDictionaries:(NSArray *)objects
                   primaryKey:(NSString *)primaryKey
              detectDeletions:(BOOL)detectDeletions
         managedObjectContext:(NSManagedObjectContext *)context
                         item:(importItemBlock)itemBlock
                         save:(importSaveBlock)saveBlock
                     complete:(dispatch_block_t)complete {
    
    NSAssert(![NSObject nilOrEmpty:primaryKey], @"A primary key is required to perform an import!");
    NSAssert(context != nil, @"An NSManagedObjectContext is required");
    NSAssert(saveBlock != nil, @"A save block is required");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Sort the incoming JSON entities by primary key
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:primaryKey ascending:YES];
        NSArray *sortedJsonEntities = [objects sortedArrayUsingDescriptors:@[descriptor]];
        NSArray *jsonEntityKeys = [sortedJsonEntities valueForKey:primaryKey];
        NSEnumerator *jsonEnumerator = [sortedJsonEntities objectEnumerator];
        
        //Sort the existing entities by primary key
        NSArray *existingEntities = [[self class] entities:primaryKey in:jsonEntityKeys orderedBy:primaryKey ascending:YES context:context];
        NSEnumerator *entityEnumerator = [existingEntities objectEnumerator];
        
        //Get first item of each list
        NSDictionary *json = [jsonEnumerator nextObject];
        NSManagedObject *entity = [entityEnumerator nextObject];
        
        //Keep a list of entities that are created/updated
        NSMutableArray *processedEntities = [NSMutableArray array];
        NSInteger count = 0;
        while (json) {
            count++;
            
            //If the incoming json item and the existing entity at this position have the same primary key we update
            BOOL isUpdate = ([json[primaryKey] isEqual:[entity valueForKey:primaryKey]]);
            
            if (isUpdate) {
                //update entity from data
                [entity populateFromDictionary:json];
                if (itemBlock) { itemBlock(entity, json); }
                
                //add the processed entity to a list
                [processedEntities addObject:entity];
                
                //increment both pointers
                json = [jsonEnumerator nextObject];
                entity = [entityEnumerator nextObject];
                
            } else {
                //if the primary keys dont match we create
                NSManagedObject *newEntity = [self createNewEntity:context];
                
                //populate entity with data
                [newEntity populateFromDictionary:json];
                if (itemBlock) { itemBlock(entity, json); }
                
                //increment json pointer
                json = [jsonEnumerator nextObject];
            }
            
            if ((count % batchSize) == 0) {
                saveBlock(^{ /*not used here internally */ });
            }
        }
        
        if (detectDeletions) {
            //Compare the processed entity list to the initial list of items when we started
            //delete any entities from the initial list not in the processed list
            
            NSArray *handledPrimaryIds = [processedEntities valueForKey:primaryKey];
            [[existingEntities filter:^BOOL(NSManagedObject *item) {
                return ![handledPrimaryIds containsObject:[item valueForKey:primaryKey]];
                
            }] enumerateObjectsUsingBlock:^(NSManagedObject *obj, NSUInteger idx, BOOL *stop) {
                [obj deleteEntity:context];
            }];
        }
        
        saveBlock(^{
            //import completed
            if (complete) { complete(); }
        });
    });
}

#pragma mark - Private - CoreData Operations
+(NSArray *)entities:(NSString *)key in:(NSArray *)possibilities orderedBy:(NSString *)orderKey ascending:(BOOL)ascending context:(NSManagedObjectContext *)context {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K IN %@)", key, possibilities];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    request.fetchBatchSize = 20;
    request.predicate = predicate;
    
    if (![NSObject nilOrEmpty:orderKey]) {
        NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:orderKey ascending:ascending];
        request.sortDescriptors = @[sorter];
    }
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (error) { NSLog(@"COREDATA ERROR: %@", error); }
    return results;
}
+(instancetype)createNewEntity:(NSManagedObjectContext *)context {
    __block NSManagedObject *newObject = nil;
    [context performBlockAndWait:^{
        NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
        newObject = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    }];
    return newObject;
}
-(void)deleteEntity:(NSManagedObjectContext *)context {
    NSManagedObject *object = self;
    if (self.managedObjectContext != context) {
        object = [context objectWithID:self.objectID];
    }
    [context deleteObject:object];
}
@end
