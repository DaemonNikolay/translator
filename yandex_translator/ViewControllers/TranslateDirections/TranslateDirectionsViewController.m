//
//  TranslateDirectionsViewController.m
//  yandex_translator
//
//  Created by Nikolay Eckert on 24.10.2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import "TranslateDirectionsViewController.h"


@interface TranslateDirectionsViewController () {
    NSArray<NSDictionary *> *languages;
}

@end

@implementation TranslateDirectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableViewDirections.dataSource = self;
    self.tableViewDirections.delegate = self;

    CoreDataManaged *coreDataManaged = [[CoreDataManaged alloc] init];

    NSString *entityName = [EnumEntities getEntityName:TranslationDirections];
    NSString *attributeName = [EnumTranslationDirections getAttributeTranslationDirection:name];

    languages = [coreDataManaged getValues:entityName attribute:attributeName];

    NSLog(@"fdsfsd %@", languages[0]);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return languages.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *languageName = languages[indexPath.item];

    NSLog(@"%@", languageName);

    UserDefaults *userDefaults = [[UserDefaults alloc] init];
    [userDefaults saveLanguage:languageName langKey:[EnumConstants getConstant:LangTranslationFrom] languages:languages];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    cell.textLabel.numberOfLines = 0;


    cell.textLabel.text = languages[indexPath.item];


    return cell;
}

@end
