//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import "ExtractForTranslate.h"


@implementation ExtractForTranslate

- (void)extractionDirectionsOfTranslateAsync {
    dispatch_async(dispatch_get_main_queue(), ^{

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
            self->languages = [Api getListSupportedLanguages:shortLanguageNameFrom][@"langs"];

            NSString *titleTranslationFrom = self->languages[shortLanguageNameFrom];
            NSString *titleTranslationTo = self->languages[shortLanguageNameTo];

            [[self buttonTranslationFrom] setTitle:titleTranslationFrom forState:UIControlStateNormal];
            [[self buttonTranslationTo] setTitle:titleTranslationTo forState:UIControlStateNormal];

        } @catch (NSException *exception) {
            UIAlertController *alert = [self createAlertDialog:@"Network error\n"];

            [alert addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                    }]];

            [self presentViewController:alert animated:NO completion:nil];
        }
    });
}


@end