//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//


#import "CoreDataManaged.h"


@interface CoreDataManaged () {
    AppDelegate *appDelegate;
    NSManagedObjectContext *context;
}

@end


@implementation CoreDataManaged

- (instancetype)init {
    self = [super init];
    if (self) {
        appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        context = appDelegate.persistentContainer.viewContext;
    }
    return self;
}


- (void)saveValue:(NSString *)value entity:(NSString *)entityName attribute:(NSString *)attributeName {
    if (entityName == nil || attributeName == nil) {
        return;
    }

    NSManagedObject *entityObj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:(id) context];
    [entityObj setValue:value forKey:attributeName];

    [appDelegate saveContext];
}

- (NSArray<NSString *> *)getValues:(NSString *)entityName attribute:(NSString *)attributeName {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSArray *results = [context executeFetchRequest:request error:nil];

    return [results valueForKey:attributeName];
}


@end
