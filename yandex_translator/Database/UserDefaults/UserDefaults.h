//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "EnumConstants.h"

@class ExtractForTranslate;
@class EnumConstants;


@interface UserDefaults : NSObject

- (void)setShortLanguageNameFrom:(NSString *)languageName;

- (void)setShortLanguageNameTo:(NSString *)languageName;

- (void)setFullNameLanguageFrom:(NSString *)languageName;

- (void)setFullNameLanguageTo:(NSString *)languageName;

- (NSString *)getShortLanguageNameFrom;

- (NSString *)getShortLanguageNameTo;

- (NSString *)getFullLanguageNameFrom;

- (NSString *)getFullLanguageNameTo;

+ (void)saveCurrentLanguageDirections:(ExtractForTranslate *)extractForTranslate;

@end