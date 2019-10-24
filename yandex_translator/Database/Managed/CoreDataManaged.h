//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"


@interface CoreDataManaged : NSObject

- (instancetype)init:(NSString *)entityName;

- (void)addValue:(NSString *)value entity:(NSString *)entityName attribute:(NSString *)attributeName;

- (NSArray *)getValues:(NSString *)entity;

- (NSUInteger)countElements:(NSString *)entityName;

- (void)clearEntity:(NSString *)entityName;

- (void)save;

@end
