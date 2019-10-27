//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumAttributeNames.h"


typedef NS_ENUM(NSUInteger, Constants) {
    LangTranslationFrom = 0,
    LangTranslationTo = 1,

    ShortLangNameFrom = 2,
    ShortLangNameTo = 3,

    FullLangNameFrom = 4,
    FullLangNameTo = 5,

    CustomError = 6
};

@interface EnumConstants : NSObject <EnumAttributeNames>

+ (NSString *)getConstant:(Constants)attributeName;

@end