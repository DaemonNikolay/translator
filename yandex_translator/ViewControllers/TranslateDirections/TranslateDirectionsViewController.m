//
//  TranslateDirectionsViewController.m
//  yandex_translator
//
//  Created by Nikolay Eckert on 24.10.2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import "TranslateDirectionsViewController.h"


@interface TranslateDirectionsViewController () {
    NSArray<NSString *> *languages;
}

@end

@implementation TranslateDirectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableViewDirections.dataSource = self;
    self.tableViewDirections.delegate = self;

    CoreDataManaged *coreDataManaged = [[CoreDataManaged alloc] init];

    NSString *entityName = [EnumEntities getEntityName:TranslationDirections];
    NSString *attributeName = [EnumTranslationDirections getAttributeTranslationDirections:name];

    languages = [coreDataManaged getValues:entityName attribute:attributeName];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return languages.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", languages[(NSUInteger) indexPath.item]);

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    cell.textLabel.numberOfLines = 0;

    cell.textLabel.text = languages[(NSUInteger) indexPath.item];

    return cell;
}

@end
