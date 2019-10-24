//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import "EnumTranslationHistory.h"


@implementation EnumTranslationHistory

+ (NSDictionary *)nameCollection {
    return @{
            @(translationContents): @"translationContents",
            @(contentSource): @"contentSource",
            @(directionTranslateFrom): @"directionTranslateFrom",
            @(directionTranslateTo): @"directionTranslateTo"
    };
}

+ (NSString *)getAttributeTranslationHistories:(EnumAttributesTranslationHistory)attributeName {
    return [EnumTranslationHistory nameCollection][@(attributeName)];
}


@end