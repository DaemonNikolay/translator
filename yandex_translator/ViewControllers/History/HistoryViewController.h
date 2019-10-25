//
//  SecondViewController.h
//  yandex_translator
//
//  Created by Nikolay Eckert on 28/09/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtractHistoryTranslations.h"

#import "EnumTranslationHistory.h"


@interface HistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, UITabBarControllerDelegate>

// MARK: --
// MARK: IBOutlets

@property (weak, nonatomic) IBOutlet UITableView *tableViewHistory;


@end

