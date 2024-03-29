//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"


@interface CoreDataManaged : NSObject


- (instancetype)init;

- (void)addValue:(NSString *)value entity:(NSString *)entityName attribute:(NSString *)attributeName;

- (NSArray *)getValues:(NSString *)entity;

- (void)clearEntity:(NSString *)entityName;

- (void)save;

@end
