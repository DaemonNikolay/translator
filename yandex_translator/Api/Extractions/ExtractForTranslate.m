//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import "ExtractForTranslate.h"
#import "Api.h"


@implementation ExtractForTranslate

- (void)extractionDirectionsOfTranslateAsync {
    dispatch_async(dispatch_get_main_queue(), (dispatch_block_t) ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        NSString *langTranslationFrom = [EnumConstants getConstant:LangTranslationFrom];
        NSString *langTranslationTo = [EnumConstants getConstant:LangTranslationTo];
        NSString *shortLangName = [EnumConstants getConstant:ShortLangName];

        NSString *shortLanguageNameFrom = [[defaults objectForKey:langTranslationFrom] objectForKey:shortLangName];
        NSString *shortLanguageNameTo = [[defaults objectForKey:langTranslationTo] objectForKey:shortLangName];

        if (!shortLanguageNameFrom) {
            shortLanguageNameFrom = @"ru";
        }
        if (!shortLanguageNameTo) {
            shortLanguageNameTo = @"en";
        }

        @try {
            CoreDataManaged *coreDataManaged = [[CoreDataManaged alloc] init];

            NSDictionary *languages = [Api getListSupportedLanguages:shortLanguageNameFrom][@"langs"];
            NSString *entityName = [EnumEntities getEntityName:TranslationDirections];
            NSString *attributeName = [EnumTranslationDirections getAttributeTranslationDirection:name];

            [coreDataManaged clearEntity:entityName];
            for (NSString *language in languages) {
                NSString *fullNameLang = languages[language];
                [coreDataManaged saveValue:fullNameLang entity:entityName attribute:attributeName];
                [coreDataManaged saveValue:language entity:entityName attribute:attributeName]; //TODO нужно поле под короткое имя
            }

        } @catch (NSException *exception) {
            [NSException raise:@"error extraction languages" format:@""];
        }
    });
}


@end