//
//  SecondViewController.m
//  yandex_translator
//
//  Created by Nikolay Eckert on 28/09/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import "HistoryViewController.h"


@interface HistoryViewController () {
    NSMutableArray *sections;
    NSMutableArray *contents;
}

@end


@implementation HistoryViewController

// MARK: --
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


// MARK: --
// MARK: UITableView

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    cell.textLabel.numberOfLines = 0;

    NSUInteger sectionIndex = (NSUInteger) indexPath.section;
    NSUInteger rowIndex = (NSUInteger) indexPath.row;

    NSString *cc = contents[sectionIndex][rowIndex];

    cell.textLabel.text = contents[sectionIndex][rowIndex];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [contents[0] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *fds = sections[(NSUInteger) section];

    return sections[(NSUInteger) section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections.count;
}


// MARK: --
// MARK: Services

- (void)updateContentForTable {
    ExtractHistoryTranslations *extractHistoryTranslations = [[ExtractHistoryTranslations alloc] init];

    NSArray *history = [extractHistoryTranslations extractionHistoryTranslates];

    NSArray *historySourceContents = [history valueForKey:[EnumTranslationHistory getAttributeTranslationHistories:contentSource]];
    NSArray *historyTranslatedContents = [history valueForKey:[EnumTranslationHistory getAttributeTranslationHistories:translationContents]];
    NSArray *historyDirectionTranslateFrom = [history valueForKey:[EnumTranslationHistory getAttributeTranslationHistories:directionTranslateFrom]];
    NSArray *historyDirectionTranslateTo = [history valueForKey:[EnumTranslationHistory getAttributeTranslationHistories:directionTranslateTo]];


    for (int i = 0; i < [historyDirectionTranslateFrom count]; ++i) {

        NSString *directionTranslateFrom = historyDirectionTranslateFrom[(NSUInteger) i];
        NSString *directionTranslateTo = historyDirectionTranslateTo[(NSUInteger) i];

        NSMutableString *direction = [[NSMutableString alloc] init];
        [direction appendString:directionTranslateFrom];
        [direction appendString:@" -> "];
        [direction appendString:directionTranslateTo];

        [sections addObject:direction];


        NSString *sourceContent = historySourceContents[(NSUInteger) i];
        NSString *translatedContent = historyTranslatedContents[(NSUInteger) i];

        NSMutableArray *contentTranslate = [@[sourceContent, translatedContent] mutableCopy];

        [contents addObject:contentTranslate];
    }
}

//- (NSArray *)extractionHistoryTranslates {
////    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////    NSArray *translates = [defaults objectForKey:@"history"];
////
////    return translates;
//
//
//    Core
//
//}

- (void)initInfoOfTranslation {
    sections = [@[] mutableCopy];
    contents = [@[] mutableCopy];
}

@end
