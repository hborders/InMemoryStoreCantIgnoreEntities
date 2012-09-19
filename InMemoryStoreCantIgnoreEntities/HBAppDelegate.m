//
//  HBAppDelegate.m
//  InMemoryStoreCantIgnoreEntities
//
//  Created by dev1 on 9/19/12.
//  Copyright (c) 2012 Heath Borders. All rights reserved.
//

#import "HBAppDelegate.h"
#import <CoreData/CoreData.h>
#import "Entity.h"

@implementation HBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSURL *databaseFile = [NSURL fileURLWithPath:[documentsDir stringByAppendingString:@"/Sqlite.sqlite"]];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    [fileMgr removeItemAtURL:databaseFile
                       error:NULL];

    NSURL *issueLogManagedObjectModelURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"Model"
                                                                                    withExtension:@"mom"];
    NSManagedObjectModel *issueLogManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:issueLogManagedObjectModelURL];
    {
        NSPersistentStoreCoordinator *sqlitePersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:issueLogManagedObjectModel];
        [sqlitePersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:databaseFile
                                                             options:nil
                                                               error:nil];
        NSManagedObjectContext *sqliteManagedObjectContext = [NSManagedObjectContext new];
        [sqliteManagedObjectContext setPersistentStoreCoordinator:sqlitePersistentStoreCoordinator];

        Entity *sqliteIgnoredEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Entity"
                                                                    inManagedObjectContext:sqliteManagedObjectContext];
        sqliteIgnoredEntity.stringAttribute = @"sqliteEntity1";

        Entity *sqliteReturnedEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Entity"
                                                                     inManagedObjectContext:sqliteManagedObjectContext];
        sqliteReturnedEntity.stringAttribute = @"sqliteEntity2";

        [sqliteManagedObjectContext save:NULL];

        NSFetchRequest *sqliteFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Entity"];
        [sqliteFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"NOT (%@ CONTAINS SELF)",
                                          [NSSet setWithObject:sqliteIgnoredEntity]]];
        NSArray *sqliteResults = [sqliteManagedObjectContext executeFetchRequest:sqliteFetchRequest
                                                                           error:NULL];
        NSLog(@"sqliteResults: %@", sqliteResults);
    }

    {
        NSPersistentStoreCoordinator *inMemoryPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:issueLogManagedObjectModel];
        [inMemoryPersistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                         configuration:nil
                                                                   URL:nil
                                                               options:nil
                                                                 error:nil];
        NSManagedObjectContext *inMemoryManagedObjectContext = [NSManagedObjectContext new];
        [inMemoryManagedObjectContext setPersistentStoreCoordinator:inMemoryPersistentStoreCoordinator];

        Entity *inMemoryIgnoredEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Entity"
                                                                      inManagedObjectContext:inMemoryManagedObjectContext];
        inMemoryIgnoredEntity.stringAttribute = @"inMemoryEntity1";

        Entity *inMemoryReturnedEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Entity"
                                                                       inManagedObjectContext:inMemoryManagedObjectContext];
        inMemoryReturnedEntity.stringAttribute = @"inMemoryEntity2";

        [inMemoryManagedObjectContext save:NULL];

        NSFetchRequest *inMemoryFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Entity"];
        [inMemoryFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"NOT (%@ CONTAINS SELF)",
                                            [NSSet setWithObject:inMemoryIgnoredEntity]]];
        NSArray *inMemoryResults = [inMemoryManagedObjectContext executeFetchRequest:inMemoryFetchRequest
                                                                               error:NULL];
        NSLog(@"inMemoryResults: %@", inMemoryResults);
    }

    self.window.rootViewController = [UIViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
