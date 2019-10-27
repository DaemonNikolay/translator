//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import "UserDefaults.h"
#import "ExtractForTranslate.h"
#import "Api.h"

@interface UserDefaults () {
    NSUserDefaults *defaults;

    NSString *defaultFullLanguageNameFrom;
    NSString *defaultFullLanguageNameTo;

    NSString *defaultShortLanguageNameFrom;
    NSString *defaultShortLanguageNameTo;
}

@end

@implementation UserDefaults

- (instancetype)init {
    self = [super init];
    if (self) {
        defaults = [NSUserDefaults standardUserDefaults];

        defaultFullLanguageNameFrom = @"Русский";
        defaultFullLanguageNameTo = @"Английский";
        defaultShortLanguageNameFrom = @"ru";
        defaultShortLanguageNameTo = @"en";
    }
    return self;
}


// MARK: --
// MARK: Setters

- (void)setShortLanguageNameFrom:(NSString *)languageName {
    [defaults setObject:languageName forKey:[EnumConstants getConstant:ShortLangNameFrom]];
}

- (void)setShortLanguageNameTo:(NSString *)languageName {
    [defaults setObject:languageName forKey:[EnumConstants getConstant:ShortLangNameTo]];
}

- (void)setFullNameLanguageFrom:(NSString *)languageName {
    [defaults setObject:languageName forKey:[EnumConstants getConstant:FullLangNameFrom]];
}

- (void)setFullNameLanguageTo:(NSString *)languageName {
    [defaults setObject:languageName forKey:[EnumConstants getConstant:FullLangNameTo]];
}

- (void)setError:(NSString *)message {
    [defaults setObject:message forKey:[EnumConstants getConstant:CustomError]];
}


// MARK: --
// MARK: Getters

- (NSString *)getShortLanguageNameFrom {
    NSString *name = [defaults objectForKey:[EnumConstants getConstant:ShortLangNameFrom]];

    return [self filterName:name defaultName:defaultShortLanguageNameFrom];
}

- (NSString *)getShortLanguageNameTo {
    NSString *name = [defaults objectForKey:[EnumConstants getConstant:ShortLangNameTo]];

    return [self filterName:name defaultName:defaultShortLanguageNameTo];
}

- (NSString *)getFullLanguageNameFrom {
    NSString *name = [defaults objectForKey:[EnumConstants getConstant:FullLangNameFrom]];

    return [self filterName:name defaultName:defaultFullLanguageNameFrom];
}

- (NSString *)getFullLanguageNameTo {
    NSString *name = [defaults objectForKey:[EnumConstants getConstant:FullLangNameTo]];

    return [self filterName:name defaultName:defaultFullLanguageNameTo];
}

- (NSString *)getError {
    NSString *message = [defaults objectForKey:[EnumConstants getConstant:CustomError]];

    return message;
}


// MARK: --
// MARK: Save

+ (void)saveChangedCurrentDirection:(Boolean)isLanguageFrom
                      langShortName:(NSString *)languageShortName
                       langFullName:(NSString *)languageFullName {

    if (![Api checkInternetConnection]) {
        [NSException raise:@"Internet error connection" format:@""];
    }

    UserDefaults *userDefaults = [[UserDefaults alloc] init];

    if (isLanguageFrom) {
        [userDefaults setShortLanguageNameFrom:languageShortName];
        [userDefaults setFullNameLanguageFrom:languageFullName];

        return;
    }

    [userDefaults setShortLanguageNameTo:languageShortName];
    [userDefaults setFullNameLanguageTo:languageFullName];
}


// MARK: --
// MARK: Services

- (NSString *)filterName:(NSString *)name defaultName:(NSString *)defaultName {
    if (name == nil) {
        return defaultName;
    }

    return name;
}


@end
