//
//  TranslatorViewController.h
//  yandex_translator
//
//  Created by Nikolay Eckert on 28/09/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TranslatorViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textViewSourceContent;
@property (weak, nonatomic) IBOutlet UITextView *textViewTranslateContent;
@property (weak, nonatomic) IBOutlet UILabel *labelOfButtonTranslateFrom;
@property (weak, nonatomic) IBOutlet UILabel *labelOfButtonTranslateTo;

- (IBAction)buttonTranslationFrom_click:(id)sender;
- (IBAction)buttonTranslationTo_click:(id)sender;
- (IBAction)buttonTranslate_click:(id)sender;

extern NSString *const LangTranslationFrom;
extern NSString *const LangTranslationTo;

extern NSString *const ShortLangName;
extern NSString *const FullLangName;

extern NSString *const NameFileHistoryRequests;

@end

