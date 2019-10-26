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

- (instancetype)init {
    self = [super init];
    if (self) {
        if (!appDelegate) {
            appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        }

        if (!context) {
//            context = appDelegate.persistentContainer.viewContext;
            context = appDelegate.privateQueueContext;
        }
    }

    return self;
}


- (void)addValue:(NSString *)value entity:(NSString *)entityName attribute:(NSString *)attributeName {
    if (entityName == nil || attributeName == nil) {
        return;
    }

    if (entityObj == nil) {
        entityObj = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                  inManagedObjectContext:(id) context];
    }

    [entityObj setValue:value forKey:attributeName];
}

- (void)save {
    [appDelegate saveContext:context];
}

- (NSArray *)getValues:(NSString *)entityName {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSArray *results = [context executeFetchRequest:request error:nil];

    return results;
}

- (void)clearEntity:(NSString *)entityName {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
    [request setIncludesPropertyValues:NO];

    NSError *error = nil;
    NSArray *elements = [context executeFetchRequest:request error:&error];

    for (NSManagedObject *element in elements) {
        [context deleteObject:element];
    }

    NSError *saveError = nil;
    [context save:&saveError];
}

@end

