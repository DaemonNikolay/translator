//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ExtractForTranslate;
@class EnumConstants;
@class Api;


@interface UserDefaults : NSObject


// MARK: --
// MARK: Setters

- (void)setShortLanguageNameFrom:(NSString *)languageName;

- (void)setShortLanguageNameTo:(NSString *)languageName;

- (void)setFullNameLanguageFrom:(NSString *)languageName;

- (void)setFullNameLanguageTo:(NSString *)languageName;

- (void)setError:(NSString *)message;


// MARK: --
// MARK: Getters

- (NSString *)getShortLanguageNameFrom;

- (NSString *)getShortLanguageNameTo;

- (NSString *)getFullLanguageNameFrom;

- (NSString *)getFullLanguageNameTo;

- (NSString *)getError;


// MARK: --
// MARK: Save

+ (void)saveChangedCurrentDirection:(Boolean)isLanguageFrom
                      langShortName:(NSString *)languageShortName
                       langFullName:(NSString *)languageFullName;

@end