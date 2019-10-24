//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, EnumAttributesTranslationDirections) {
    name = 0
};


@interface EnumTranslationDirections : NSObject

+ (NSString *)getAttributeTranslationDirections:(EnumAttributesTranslationDirections)attributeName;

@end