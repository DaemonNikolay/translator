//
// Created by Nikolay Eckert on 25.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import "ExtractHistoryTranslations.h"


@implementation ExtractHistoryTranslations

- (NSArray *)extractionHistoryTranslates {
    CoreDataManaged *coreDataManaged = [[CoreDataManaged alloc] init];

    NSString *entityName = [EnumEntities getEntityName:TranslationHistory];
    NSArray *history = [coreDataManaged getValues:entityName];

    return history;
}

@end