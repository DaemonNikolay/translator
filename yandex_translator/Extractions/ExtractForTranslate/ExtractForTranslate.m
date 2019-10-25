//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import "ExtractForTranslate.h"
#import "Api.h"


@implementation ExtractForTranslate


// MARK: --
// MARK: Public methods

- (void)extractionDirectionsOfTranslate {
    UserDefaults *userDefaults = [[UserDefaults alloc] init];
    NSString *shortLanguageNameFrom = [userDefaults getShortLanguageNameFrom];
    NSString *shortLanguageNameTo = [userDefaults getShortLanguageNameTo];

    NSString *entityName = [EnumEntities getEntityName:TranslationDirections];

    CoreDataManaged *coreDataManagedClear = [[CoreDataManaged alloc] init];
    [coreDataManagedClear clearEntity:entityName];

    @try {
        NSDictionary *languages = [self getLanguagesList:shortLanguageNameFrom];

        [userDefaults setFullNameLanguageFrom:[self getNewFullLangName:shortLanguageNameFrom languages:languages]];
        [userDefaults setFullNameLanguageTo:[self getNewFullLangName:shortLanguageNameTo languages:languages]];

        NSString *attributeFullName = [EnumTranslationDirections getAttributeTranslationDirection:fullName];
        NSString *attributeShortName = [EnumTranslationDirections getAttributeTranslationDirection:shortName];

        [self saveLanguageDirectionsToCoreData:languages
                                    entityName:entityName
                            attributeShortName:attributeShortName
                             attributeFullName:attributeFullName];
    } @catch (NSException *exception) {
        [NSException raise:@"error extraction languages" format:@"%@", exception];
    }
}

- (NSString *)extractionTranslatedContent:(NSString *)sourceContent {
    UserDefaults *userDefaults = [[UserDefaults alloc] init];
    NSString *shortLangName = [userDefaults getShortLanguageNameTo];

    NSDictionary *json = [self translate:sourceContent shortLangName:shortLangName];
    NSString *translatedContent = json[@"text"][0];
    if (json == nil || !translatedContent) {
        return @"";
    }

    [self saveTranslationHistoryToCoreData:sourceContent
                         translatedContent:translatedContent
                              userDefaults:userDefaults];

    return translatedContent;
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


// MARK: --
// MARK: Private methods

- (void)saveLanguageDirectionsToCoreData:(NSDictionary *)languages
                              entityName:(NSString *)entityName
                      attributeShortName:(NSString *)attributeShortName
                       attributeFullName:(NSString *)attributeFullName {

    @synchronized (self) {
        for (NSString *language in languages) {
            NSString *fullNameLang = languages[language];

            CoreDataManaged *coreDataManaged = [[CoreDataManaged alloc] init];

            [coreDataManaged addValue:fullNameLang entity:entityName attribute:attributeFullName];
            [coreDataManaged addValue:language entity:entityName attribute:attributeShortName];

            [coreDataManaged save];
        }
    }
}

- (NSDictionary *)getLanguagesList:(NSString *)shortLanguageNameFrom {
    return [Api getListSupportedLanguages:shortLanguageNameFrom][@"langs"];
}

- (NSDictionary *)translate:(NSString *)sourceContent shortLangName:(NSString *)shortLanguageName {
    return [Api translateText:sourceContent lang:shortLanguageName];
}

- (NSString *)getNewFullLangName:(NSString *)shortLangName languages:(NSDictionary *)languages {
    NSString *newFullLangName = [ExtractNameFromLangsApi extractFullLanguageName:shortLangName
                                                                           langs:languages];

    return newFullLangName;
}

- (void)saveTranslationHistoryToCoreData:(NSString *)sourceContent
                       translatedContent:(NSString *)translatedContent
                            userDefaults:(UserDefaults *)userDefaults {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CoreDataManaged *coreDataManaged = [[CoreDataManaged alloc] init];
        NSString *entityName = [EnumEntities getEntityName:TranslationHistory];

        [coreDataManaged addValue:sourceContent entity:entityName
                        attribute:[EnumTranslationHistory
                                getAttributeTranslationHistories:(EnumAttributesTranslationHistory) contentSource]];

        [coreDataManaged addValue:translatedContent entity:entityName
                        attribute:[EnumTranslationHistory
                                getAttributeTranslationHistories:(EnumAttributesTranslationHistory) translationContents]];

        NSString *fullLanguageFrom = [userDefaults getFullLanguageNameFrom];
        [coreDataManaged addValue:fullLanguageFrom entity:entityName
                        attribute:[EnumTranslationHistory
                                getAttributeTranslationHistories:(EnumAttributesTranslationHistory) directionTranslateFrom]];

        NSString *fullLanguageTo = [userDefaults getFullLanguageNameTo];
        [coreDataManaged addValue:fullLanguageTo entity:entityName
                        attribute:[EnumTranslationHistory
                                getAttributeTranslationHistories:(EnumAttributesTranslationHistory) directionTranslateTo]];

        [coreDataManaged save];
    });
}

@end
