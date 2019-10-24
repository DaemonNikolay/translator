//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import "CoreDataManaged.h"


@interface CoreDataManaged () {
    AppDelegate *appDelegate;
    NSManagedObjectContext *context;
    NSManagedObject *entityObj;
}

@end


@implementation CoreDataManaged

- (instancetype)init:(NSString *)entityName {
    self = [super init];
    if (self) {
        appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        context = appDelegate.persistentContainer.viewContext;
        entityObj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:(id) context];
    }
    return self;
}


- (void)addValue:(NSString *)value entity:(NSString *)entityName attribute:(NSString *)attributeName {
    if (entityName == nil || attributeName == nil) {
        return;
    }

    [entityObj setValue:value forKey:attributeName];
}

- (void)save {
    [appDelegate saveContext];
}

- (NSArray *)getValues:(NSString *)entityName attribute:(NSString *)attributeName {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSArray *results = [context executeFetchRequest:request error:nil];

    return results;
}

- (NSUInteger)countElements:(NSString *)entityName attribute:(NSString *)attributeName {
    return [self getValues:entityName attribute:attributeName].count;
}

- (void)clearEntity:(NSString *)entityName {
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
//    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
//
//    [context executeRequest:delete error:nil];


    NSFetchRequest *allCars = [[NSFetchRequest alloc] init];
    [allCars setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
    [allCars setIncludesPropertyValues:NO];

    NSError *error = nil;
    NSArray *cars = [context executeFetchRequest:allCars error:&error];

    for (NSManagedObject *car in cars) {
        [context deleteObject:car];
    }

    NSError *saveError = nil;
    [context save:&saveError];
}

@end

