//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import "ExtractForTranslate.h"
#import "Api.h"


@implementation ExtractForTranslate

- (void)extractionDirectionsOfTranslate {
    UserDefaults *userDefaults = [[UserDefaults alloc] init];
    NSString *shortLanguageNameFrom = [userDefaults getShortLanguageNameFrom];
    if (shortLanguageNameFrom == nil) {
        shortLanguageNameFrom = @"ru";
    }

    NSString *entityName = [EnumEntities getEntityName:TranslationDirections];

    CoreDataManaged *coreDataManagedClear = [[CoreDataManaged alloc] init:entityName];
    [coreDataManagedClear clearEntity:entityName];

    @try {
        NSDictionary *languages = [Api getListSupportedLanguages:shortLanguageNameFrom][@"langs"];

        NSString *attributeFullName = [EnumTranslationDirections getAttributeTranslationDirection:fullName];
        NSString *attributeShortName = [EnumTranslationDirections getAttributeTranslationDirection:shortName];

        for (NSString *language in languages) {
            NSString *fullNameLang = languages[language];

            CoreDataManaged *coreDataManaged = [[CoreDataManaged alloc] init:entityName];

            [coreDataManaged addValue:fullNameLang entity:entityName attribute:attributeFullName];
            [coreDataManaged addValue:language entity:entityName attribute:attributeShortName];
            [coreDataManaged save];
        }
    } @catch (NSException *exception) {
        [NSException raise:@"error extraction languages" format:@"%@", exception];
    }
}

+ (NSArray *)clean:(NSArray *)value {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if ([value count] == 0) {
        return result;
    }

    for (NSString *elem in value) {
        if (![elem isEqual:[NSNull null]]) {
            [result addObject:elem];
        }
    }

    return result;
}

@end