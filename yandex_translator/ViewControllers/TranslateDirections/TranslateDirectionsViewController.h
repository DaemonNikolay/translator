//
//  TranslateDirectionsViewController.h
//  yandex_translator
//
//  Created by Nikolay Eckert on 24.10.2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TranslateDirectionsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableViewDirections;

@end

