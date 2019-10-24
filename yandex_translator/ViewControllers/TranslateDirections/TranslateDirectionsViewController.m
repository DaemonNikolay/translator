//
//  TranslateDirectionsViewController.m
//  yandex_translator
//
//  Created by Nikolay Eckert on 24.10.2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import "TranslateDirectionsViewController.h"


@interface TranslateDirectionsViewController ()

@end

@implementation TranslateDirectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableViewDirections.dataSource = self;
    self.tableViewDirections.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    cell.textLabel.numberOfLines = 0;

    cell.textLabel.text = @"tt43";

    return cell;
}

@end
