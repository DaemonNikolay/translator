//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import "EnumEntities.h"


@implementation EnumEntities

+ (NSDictionary *)nameCollection {
    return @{
            @(TranslationDirections): @"TranslationDirections",
            @(TranslationHistory): @"TranslationHistory"
    };
}

+ (NSString *)getEntityName:(EnumEntityNames)attributeName {
    return [EnumEntities nameCollection][@(attributeName)];
}


@end