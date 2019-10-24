//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumAttributeNames.h"


typedef NS_ENUM(NSUInteger, EnumEntityNames) {
    TranslationDirections = 0,
    TranslationHistory = 1
};

@interface EnumEntities : NSObject <EnumAttributeNames>

+ (NSString *)getEntityName:(EnumEntityNames)attributeName;

@end