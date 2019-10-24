//
//  TranslateDirectionsViewController.m
//  yandex_translator
//
//  Created by Nikolay Eckert on 24.10.2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import "TranslateDirectionsViewController.h"


@interface TranslateDirectionsViewController () {
    NSArray *languagesFullNames;
    NSArray *languagesShortNames;
}

@end

@implementation TranslateDirectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableViewDirections.dataSource = self;
    self.tableViewDirections.delegate = self;

    NSString *entityName = [EnumEntities getEntityName:TranslationDirections];
    CoreDataManaged *coreDataManaged = [[CoreDataManaged alloc] init:entityName];

    NSString *attributeFullName = [EnumTranslationDirections getAttributeTranslationDirection:fullName];
    NSString *attributeShortName = [EnumTranslationDirections getAttributeTranslationDirection:shortName];

    NSArray *languagesCoreData = [coreDataManaged getValues:entityName attribute:attributeFullName];

    languagesFullNames = [languagesCoreData valueForKey:attributeFullName];
    languagesShortNames = [languagesCoreData valueForKey:attributeShortName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return languagesFullNames.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *languageShortName = languagesShortNames[(NSUInteger) indexPath.item];

    UserDefaults *userDefaults = [[UserDefaults alloc] init];
    [userDefaults saveLanguage:languageShortName];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = languagesFullNames[(NSUInteger) indexPath.item];

    return cell;
}

@end
