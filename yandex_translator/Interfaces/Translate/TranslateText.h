//
//  TranslateText.h
//  yandex_translator
//
//  Created by Nikolay Eckert on 06/10/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

@interface TransalteText : NSObject

@property (nonatomic, readonly) int code;
@property (nonatomic, readonly) NSString *lang;
@property (nonatomic, readonly) NSArray<NSString *> *text;

@end
