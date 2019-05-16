//
//  AppDelegate.m
//  StackOverflow
//
//  Created by Сергей Мирошниченко on 12/05/2019.
//  Copyright © 2019 Сергей Мирошниченко. All rights reserved.
//

#import "AppDelegate.h"
#import "Config.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:GStackOverflowSettingKey_QuestionsInCoreData])
        [self loadQuestions];
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext)
        return _managedObjectContext;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel)
        return _managedObjectModel;
    
    NSString *resource = @"StackOverflow";
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:resource withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator)
        return _persistentStoreCoordinator;
    
    NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSString *databaseName = @"StackOverflow";
    
    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", databaseName]];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

#pragma mark - Loading, Saving

- (void)saveQuestions:(NSArray <Question *> *)questions {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:GStackOverflowCoreDataEntity_Question];
//    if (!matches || [matches count] > 1) {
//        NSLog(@"Есть в CoreData");
//    } else if (![matches count]){
//        mail = (CYMail *)[self createManagedObjectOfClass:CYMail.self];
//        // ...
//    } else {
//        mail = [matches lastObject];
//    }
//    return mail;
    
    for (Question *question in questions) {
        request.predicate = [NSPredicate predicateWithFormat:@"identifier = %ld", question.identifier];
        NSError *error;
        NSArray *matches = [managedObjectContext executeFetchRequest:request error:&error];
        if (!matches || [matches count] > 1) {
            NSLog(@"duplicate value");
        } else if (![matches count]) {
            NSManagedObject *questionManagedObject = [NSEntityDescription insertNewObjectForEntityForName:GStackOverflowCoreDataEntity_Question
                                                                                       inManagedObjectContext:managedObjectContext];
            [question updateManagedObject:&questionManagedObject];
        }
    }
    
    [self saveContext];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:GStackOverflowSettingKey_QuestionsInCoreData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadQuestions {
    self.questions = [NSMutableArray new];
    [self.questions removeAllObjects];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:GStackOverflowCoreDataEntity_Question];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:GStackOverflowCoreDataAttribute_Question_Identifier ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray *questionManagedObjects = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if (questionManagedObjects.count > 0) {
        for (NSManagedObject *questionManagedObject in questionManagedObjects) {
            Question *question = [Question questionFromManagedObject:questionManagedObject];
            [self.questions addObject:question];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:GStackOverflowSettingKey_QuestionsInCoreData];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


@end
