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

// MARK: -
// MARK: Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfoOfTranslation];
    
    self.tableViewHistory.dataSource = self;
    self.tableViewHistory.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self initInfoOfTranslation];
    
    [self updateContentForTable];
    [self.tableViewHistory reloadData];
}


// MARK: -
// MARK: UITableView

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

// MARK: -
// MARK: Services

- (void)updateContentForTable {
    NSArray *translates = [self extractionHistoryTranslates];
    
    for (NSDictionary *elem in translates) {
        NSString *sectionName = [elem objectForKey:@"direction"];
        [sections addObject:sectionName];
        
        NSMutableArray *contentTranslate = [@[[elem objectForKey:@"beforeTranslation"], [elem objectForKey:@"afterTranslation"]] mutableCopy];
        [contents addObject:contentTranslate];
    }
}

- (NSArray *)extractionHistoryTranslates {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *translates = [defaults objectForKey:@"history"];
    
    return translates;
}

- (void)initInfoOfTranslation {
    sections = [@[] mutableCopy];
    contents = [@[] mutableCopy];
}

@end
