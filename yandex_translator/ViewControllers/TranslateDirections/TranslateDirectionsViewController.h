//
//  TranslateDirectionsViewController.h
//  yandex_translator
//
//  Created by Nikolay Eckert on 24.10.2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManaged.h"
#import "UserDefaults.h"
#import "ExtractForTranslate.h"

#import "EnumEntities.h"
#import "EnumTranslationDirections.h"

@class Alert;


@interface TranslateDirectionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(weak, nonatomic) IBOutlet UITableView *tableViewDirections;

@property Boolean isLanguageFrom;

@end

