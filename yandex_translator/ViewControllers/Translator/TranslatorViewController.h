//
//  TranslatorViewController.h
//  yandex_translator
//
//  Created by Nikolay Eckert on 28/09/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TranslatorViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>


// MARK: -
// MARK: Properties

@property (weak, nonatomic) IBOutlet UITextView *textViewSourceContent;
@property (weak, nonatomic) IBOutlet UITextView *textViewTranslateContent;

@property (weak, nonatomic) IBOutlet UIButton *buttonTranslationTo;
@property (weak, nonatomic) IBOutlet UIButton *buttonTranslationFrom;


// MARK: -
// MARK: Actions

- (IBAction)buttonTranslationFrom_click:(id)sender;
- (IBAction)buttonTranslationTo_click:(id)sender;
- (IBAction)buttonTranslate_click:(id)sender;


// MARK: -
// MARK: Constants

extern NSString *const LangTranslationFrom;
extern NSString *const LangTranslationTo;

extern NSString *const ShortLangName;
extern NSString *const FullLangName;

extern NSString *const NameFileHistoryRequests;


@end

