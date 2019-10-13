//
//  SecondViewController.m
//  yandex_translator
//
//  Created by Nikolay Eckert on 28/09/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import "HistoryViewController.h"


@interface HistoryViewController() {
    NSMutableArray *sections;
    NSMutableArray<NSMutableArray *> *contents;
}

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sections = [@[] mutableCopy];
    contents = [@[] mutableCopy];
    
    //    NSArray *translates = [self extractionHistoryTranslates];
    //
    //    for (NSDictionary *elem in translates) {
    //        NSString *sectionName = [elem objectForKey:@"direction"];
    //        [sections addObject:sectionName];
    //
    //        NSMutableArray *contentTranslate = [@[[elem objectForKey:@"beforeTranslation"], [elem objectForKey:@"afterTranslation"]] mutableCopy];
    //        [contents addObject:contentTranslate];
    //    }
    
    self.tableViewHistory.dataSource = self;
    self.tableViewHistory.delegate = self;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.numberOfLines = 0;
    
    cell.textLabel.text = contents[indexPath.section][indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[contents objectAtIndex:0] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return sections[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections.count;
}

- (NSArray *)extractionHistoryTranslates {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *translates = [defaults objectForKey:@"history"];
    
    NSLog(@"%@", translates);
    
    return translates;
}

- (void)updateContentForTable {
    NSArray *translates = [self extractionHistoryTranslates];
    
    for (NSDictionary *elem in translates) {
        NSString *sectionName = [elem objectForKey:@"direction"];
        [sections addObject:sectionName];
        
        NSMutableArray *contentTranslate = [@[[elem objectForKey:@"beforeTranslation"], [elem objectForKey:@"afterTranslation"]] mutableCopy];
        [contents addObject:contentTranslate];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateContentForTable];
    [self.tableViewHistory reloadData];
}


@end
