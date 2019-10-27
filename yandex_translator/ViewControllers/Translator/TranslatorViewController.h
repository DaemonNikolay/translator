//
//  TranslatorViewController.h
//  yandex_translator
//
//  Created by Nikolay Eckert on 28/09/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtractForTranslate.h"
#import "UserDefaults.h"

#import "EnumTranslationDirections.h"
#import "EnumEntities.h"

#import "TranslateDirectionsViewController.h"
#import "Alert.h"


@interface TranslatorViewController : UIViewController


// MARK: -
// MARK: Properties

@property(weak, nonatomic) IBOutlet UITextView *textViewSourceContent;
@property(weak, nonatomic) IBOutlet UITextView *textViewTranslateContent;

@property(weak, nonatomic) IBOutlet UIButton *buttonTranslationTo;
@property(weak, nonatomic) IBOutlet UIButton *buttonTranslationFrom;
@property(weak, nonatomic) IBOutlet UIButton *buttonTranslate;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


// MARK: -
// MARK: Actions

- (IBAction)buttonTranslationFrom_click:(id)sender;

- (IBAction)buttonTranslationTo_click:(id)sender;

- (IBAction)buttonTranslate_click:(id)sender;


@end

