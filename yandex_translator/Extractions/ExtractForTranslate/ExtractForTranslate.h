//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataManaged.h"
#import "UserDefaults.h"
#import "ExtractNameFromLangsApi.h"

#import "EnumConstants.h"
#import "EnumEntities.h"
#import "EnumTranslationDirections.h"
#import "EnumTranslationHistory.h"


@interface ExtractForTranslate : NSObject

- (void)extractionDirectionsOfTranslate;

- (NSString *)extractionTranslatedContent:(NSString *)sourceContent;

+ (NSArray *)clean:(NSArray *)value;

@end
