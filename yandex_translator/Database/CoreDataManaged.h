//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"


@interface CoreDataManaged : NSObject

- (void)saveValue:(NSString *)value entity:(NSString *)entityName attribute:(NSString *)attributeName;

- (NSArray<NSString *> *)getValues:(NSString *)entity attribute:(NSString *)attributeName;

@end