//
//  SecondViewController.m
//  yandex_translator
//
//  Created by Nikolay Eckert on 28/09/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import "HistoryViewController.h"
#import "TranslatedContent.h"


@implementation HistoryViewController

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (!self) {
        return nil;
    }

    NSLog(@"%@", [coder decodeObjectForKey:@"title"]);

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    NSString *content = @"this is title";
    [encoder encodeObject:content forKey:@"title"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
