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


// MARK: --
// MARK: Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableViewDirections.dataSource = self;
    self.tableViewDirections.delegate = self;

    NSString *entityName = [EnumEntities getEntityName:TranslationDirections];
    CoreDataManaged *coreDataManaged = [[CoreDataManaged alloc] init:entityName];

    NSString *attributeFullName = [EnumTranslationDirections getAttributeTranslationDirection:fullName];
    NSString *attributeShortName = [EnumTranslationDirections getAttributeTranslationDirection:shortName];

    NSArray *languagesCoreData = [coreDataManaged getValues:entityName];

    NSArray *sourceLanguageFullNames = [languagesCoreData valueForKey:attributeFullName];
    languagesFullNames = [ExtractForTranslate clean:sourceLanguageFullNames];

    NSArray *sourceLanguageShortNames = [languagesCoreData valueForKey:attributeShortName];
    languagesShortNames = [ExtractForTranslate clean:sourceLanguageShortNames];
}


// MARK: --
// MARK: Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return languagesFullNames.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *languageShortName = languagesShortNames[(NSUInteger) indexPath.item];
    NSString *languageFullName = languagesFullNames[(NSUInteger) indexPath.item];
    UserDefaults *userDefaults = [[UserDefaults alloc] init];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });

        [userDefaults setShortLanguageNameFrom:languageShortName];
        [userDefaults setFullNameLanguageFrom:languageFullName];
    });
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
