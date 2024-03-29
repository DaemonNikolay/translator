//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import "EnumTranslationDirections.h"


@implementation EnumTranslationDirections

+ (NSDictionary *)nameCollection {
    return @{
            @(fullName): @"fullName",
            @(shortName): @"shortName"
    };
}

+ (NSString *)getAttributeTranslationDirection:(EnumAttributesTranslationDirections)attributeName {
    return [EnumTranslationDirections nameCollection][@(attributeName)];
}


@end
