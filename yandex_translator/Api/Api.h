//
//  Api.h
//  yandex_translator
//
//  Created by Nikolay Eckert on 06/10/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//


@interface Api : NSObject {
    NSString *key;
}


+ (NSDictionary *)getListSupportedLanguages:(NSString *)ui;
+ (NSDictionary *)translateText:(NSString *)text language:(NSString *)lang;

@end

