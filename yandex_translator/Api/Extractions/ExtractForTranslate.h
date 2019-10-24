//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataManaged.h"

#import "EnumConstants.h"
#import "EnumEntities.h"
#import "EnumTranslationDirections.h"


@interface ExtractForTranslate : NSObject

- (void)extractionDirectionsOfTranslate;

+ (NSArray *)clean:(NSArray *)value;

@end