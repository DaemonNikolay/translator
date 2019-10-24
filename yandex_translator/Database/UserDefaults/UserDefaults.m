//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import "UserDefaults.h"


@implementation UserDefaults

- (void)saveLanguage:(NSString *)languageName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setObject:languageName forKey:[EnumConstants getConstant:ShortLangName]];
}

@end