//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import "EnumTranslationDirections.h"


@implementation EnumTranslationDirections

+ (NSDictionary *)attributeNamesTranslationDirections {
    return @{
            @(name): @"name"
    };
}

+ (NSString *)getAttributeTranslationDirections:(EnumAttributesTranslationDirections)attributeName {
    return [EnumTranslationDirections attributeNamesTranslationDirections][@(attributeName)];
}


@end
