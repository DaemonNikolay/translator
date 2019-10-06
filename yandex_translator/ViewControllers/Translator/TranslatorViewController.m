//
//  TranslatorViewController.m
//  yandex_translator
//
//  Created by Nikolay Eckert on 28/09/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import "TranslatorViewController.h"
#import "Api.h"

@interface TranslatorViewController ()

@end

@implementation TranslatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Api getListSupportedLanguages:@"ru"];
    [Api translateText:@"привет" language:@"en"];
}


@end
