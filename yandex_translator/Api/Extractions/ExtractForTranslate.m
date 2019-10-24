//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import "ExtractForTranslate.h"
#import "Api.h"


@implementation ExtractForTranslate

- (void)extractionDirectionsOfTranslate {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        NSString *langTranslationFrom = [EnumConstants getConstant:LangTranslationFrom];
        NSString *langTranslationTo = [EnumConstants getConstant:LangTranslationTo];
        NSString *shortLangName = [EnumConstants getConstant:ShortLangName];

        NSString *shortLanguageNameFrom = [[defaults objectForKey:langTranslationFrom] objectForKey:shortLangName];
        if (shortLanguageNameFrom == nil) {
            shortLanguageNameFrom = @"en";
        }

        NSString *entityName = [EnumEntities getEntityName:TranslationDirections];

        CoreDataManaged *coreDataManagedClear = [[CoreDataManaged alloc] init:entityName];
        NSInteger count = [coreDataManagedClear countElements:entityName];
        if (count > 2) {
            [coreDataManagedClear clearEntity:entityName];
        }

        @try {
            NSDictionary *languages = [Api getListSupportedLanguages:shortLanguageNameFrom][@"langs"];

            NSString *attributeFullName = [EnumTranslationDirections getAttributeTranslationDirection:fullName];
            NSString *attributeShortName = [EnumTranslationDirections getAttributeTranslationDirection:shortName];

            for (NSString *language in languages) {
                NSString *fullNameLang = languages[language];

                NSLog(@"treg %@", fullNameLang);

                CoreDataManaged *coreDataManaged = [[CoreDataManaged alloc] init:entityName];

                [coreDataManaged addValue:fullNameLang entity:entityName attribute:attributeFullName];
                [coreDataManaged addValue:language entity:entityName attribute:attributeShortName];
                [coreDataManaged save];
            }
        } @catch (NSException *exception) {
            [NSException raise:@"error extraction languages" format:@"%@", exception];
        }
    });
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