//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumAttributeNames.h"


typedef NS_ENUM(NSUInteger, Constants) {
    LangTranslationFrom = 0,
    LangTranslationTo = 1,
    ShortLangName = 2,
    FullLangName = 3
};

@interface EnumConstants : NSObject <EnumAttributeNames>

+ (NSString *)getConstant:(Constants)attributeName;

@end