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
    NSString *shortLanguageNameTo = [userDefaults getShortLanguageNameTo];

    NSString *entityName = [EnumEntities getEntityName:TranslationDirections];

    CoreDataManaged *coreDataManagedClear = [[CoreDataManaged alloc] init:entityName];
    [coreDataManagedClear clearEntity:entityName];

    @try {
        NSDictionary *languages = [self getLanguagesList:shortLanguageNameFrom];

        [userDefaults setFullNameLanguageFrom:[self getNewFullLangName:shortLanguageNameFrom languages:languages]];
        [userDefaults setFullNameLanguageTo:[self getNewFullLangName:shortLanguageNameTo languages:languages]];

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

- (NSDictionary *)getLanguagesList:(NSString *)shortLanguageNameFrom {
//    if (withUpdate) {
    return [Api getListSupportedLanguages:shortLanguageNameFrom][@"langs"];
//    }

//    NSString *entityName = [EnumEntities getEntityName:TranslationDirections];
//
//    CoreDataManaged *coreDataManaged = [[CoreDataManaged alloc] init:entityName];
//    NSArray *langs = [coreDataManaged getValues:entityName];
//
//    NSString *keyFullName = [EnumTranslationDirections getAttributeTranslationDirection:fullName];
//    NSString *keyShortName = [EnumTranslationDirections getAttributeTranslationDirection:shortName];
//
//    NSMutableDictionary *mergeShortAndFullNames = [[NSMutableDictionary alloc] init];
//    for (int i = 0; i < [langs count]; ++i) {
//        NSString *shortNameLang = [[langs valueForKey:keyShortName] objectAtIndex:(NSUInteger) i];
//        NSString *fullNameLang = [[langs valueForKey:keyFullName] objectAtIndex:(NSUInteger) i];
//
//        mergeShortAndFullNames[shortNameLang] = fullNameLang;
//    }
//
//    return mergeShortAndFullNames;
}

- (NSString *)getNewFullLangName:(NSString *)shortLangName languages:(NSDictionary *)languages {
    NSString *newFullLangName = [ExtractNameFromLangsApi extractFullLanguageName:shortLangName
                                                                           langs:languages];

    return newFullLangName;
}

@end
