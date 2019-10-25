//
// Created by Nikolay Eckert on 24.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ExtractNameFromLangsApi : NSObject

+ (NSString *)extractFullLanguageName:(NSString *)shortLanguageName langs:(NSDictionary *)langs;

@end