//
//  Api.h
//  yandex_translator
//
//  Created by Nikolay Eckert on 06/10/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//


@interface Api : NSObject

+ (NSDictionary *)getListSupportedLanguages:(NSString *)ui;

+ (NSDictionary *)translateText:(NSString *)content lang:(NSString *)language;

+ (Boolean)checkInternetConnection;

@end

