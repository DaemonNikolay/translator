//
// Created by Nikolay Eckert on 27.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Alert : NSObject

+ (UIAlertController *)alertErrorCreateDirectionsList;

+ (UIAlertController *)alertErrorUpdateTitles;

+ (UIAlertController *)alertErrorTranslate;

+ (UIAlertController *)alertError:(NSString *)message;

@end