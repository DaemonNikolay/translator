//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumAttributeNames.h"


typedef NS_ENUM(NSUInteger, EnumAttributesTranslationHistory) {
    translationContents = 0,
    contentSource = 1,
    directionTranslateFrom = 2,
    directionTranslateTo = 3
};


@interface EnumTranslationHistory : NSObject <EnumAttributeNames>

+ (NSString *)getAttributeTranslationHistories:(EnumAttributesTranslationHistory)attributeName;

@end