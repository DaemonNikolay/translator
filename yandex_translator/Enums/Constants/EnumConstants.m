//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import "EnumConstants.h"


@implementation EnumConstants

+ (NSDictionary *)nameCollection {
    return @{
            @(LangTranslationFrom): @"LangTranslationFrom",
            @(LangTranslationTo): @"LangTranslationTo",
            @(ShortLangName): @"ShortLangName",
            @(FullLangName): @"FullLangName"
    };
}

+ (NSString *)getConstant:(Constants)attributeName {
    return [EnumConstants nameCollection][@(attributeName)];
}

@end