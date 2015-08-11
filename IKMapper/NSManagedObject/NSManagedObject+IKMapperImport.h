//
//  NSManagedObject+IKMapperImport.h
//  IKMapper
//
//  Created by Ian Keen on 10/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

@import CoreData;

/**
 *  The block that is called when an entity is created or updated
 *
 *  @param entity The new or updated entity
 *  @param json   The NSDictionary that was used for mapping
 */
typedef void(^importItemBlock)(id entity, NSDictionary *json);

/**
 *  The block that is called when the import requires core data to perform a save
 *
 *  @param complete This should be called once the save is complete, failing to call this will cause unexpected results
 */
typedef void(^importSaveBlock)(dispatch_block_t complete);

@interface NSManagedObject (IKMapperImport)
/**
 *  Performs an efficient bulk import of NSDictionary objects to NSManagedObject entities.
 *  It will decide wether or not each item requires a new entity or simply an update to an existing one.
 *  The save block is called at set intervals so that the import performs saves in 'batches'. This also helps to make the import more performant.
 *  
 *  Deletions can be deteted by looking at the entities that exist before the import, and deleting any that were not included in the import.
 *
 *  @param objects         An NSArray of NSDictionary objects
 *  @param primaryKey      The name of the property/attribute to use to uniquely identify entities
 *  @param detectDeletions Wether or not to consider the incoming data to be the complete set and detect entities that are to be deleted
 *  @param context         The NSManagedObjectContext that should be used to perform the work
 *  @param itemBlock       The block that will be called when an entity is created or updated; can be nil.
 *  @param saveBlock       The block that is called when a save is required, the block allows for custom routines as there are many ways to configure a core data stack
 *  @param complete        The block that will be called once the import has completed; can be nil.
 */
+(void)importFromDictionaries:(NSArray *)objects
                   primaryKey:(NSString *)primaryKey
              detectDeletions:(BOOL)detectDeletions
         managedObjectContext:(NSManagedObjectContext *)context
                         item:(importItemBlock)itemBlock
                         save:(importSaveBlock)saveBlock
                     complete:(dispatch_block_t)complete;
@end
