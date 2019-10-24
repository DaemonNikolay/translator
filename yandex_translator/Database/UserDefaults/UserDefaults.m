//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import "UserDefaults.h"


@implementation UserDefaults

- (void)saveLanguage:(NSString *)languageName langKey:(NSString *)languageKey languages:(NSArray <NSString *> *)languages {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *shortNameLang;
    NSString *fullNameLang;

//    for ( *langKey in languages) {
//
//        NSLog(@"%@", langKey);
//
//        if ( == languageName) {
//            shortNameLang = langKey;
//            fullNameLang = languageName;
//
//            break;
//        }
//    }

    NSDictionary *language = @{
            [EnumConstants getConstant:ShortLangName]: shortNameLang,
            [EnumConstants getConstant:FullLangName]: fullNameLang
    };

    [defaults setObject:language forKey:languageKey];
}

@end