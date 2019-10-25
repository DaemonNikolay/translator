//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import "ExtractNameFromLangsApi.h"


@implementation ExtractNameFromLangsApi

+ (NSString *)extractFullLanguageName:(NSString *)shortLanguageName langs:(NSDictionary *)langs {
    for (NSString *keyLang in langs) {
        if (![keyLang isEqual:[NSNull null]] && [keyLang isEqualToString:shortLanguageName]) {
            return langs[keyLang];
        }
    }

    return nil;
}

@end