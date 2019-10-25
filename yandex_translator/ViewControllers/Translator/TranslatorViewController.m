//
//  TranslatorViewController.m
//  yandex_translator
//
//  Created by Nikolay Eckert on 28/09/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import "TranslatorViewController.h"


@implementation TranslatorViewController


// MARK: --
// MARK: Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initButtonsTitle];
    [self dismissKeyboardByClicking];

    [self observingOnChangeLanguageTitles];
}

- (void)viewDidDisappear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults removeObserver:self
                  forKeyPath:[EnumTranslationDirections
                          getAttributeTranslationDirection:(EnumAttributesTranslationDirections) FullLangNameFrom]
    ];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

    NSString *fullLangNameFrom = [EnumConstants getConstant:FullLangNameFrom];;

    if ([keyPath isEqualToString:fullLangNameFrom]) {
        ExtractForTranslate *extractForTranslate = [[ExtractForTranslate alloc] init];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [extractForTranslate extractionDirectionsOfTranslate];

            dispatch_sync(dispatch_get_main_queue(), ^{
                [extractForTranslate extractionDirectionsOfTranslate];
                [self initButtonsTitle];
            });
        });
    }
}


// MARK: --
// MARK: Additional UI

- (UIAlertController *)createAlertDialog:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    return alert;
}


// MARK: --
// MARK: Button actions

- (IBAction)buttonTranslationFrom_click:(id)sender {
    [self dismissKeyboard];

    ExtractForTranslate *extractForTranslate = [[ExtractForTranslate alloc] init];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [extractForTranslate extractionDirectionsOfTranslate];

        dispatch_sync(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"chooseLanguage" sender:nil];
        });
    });
}

- (IBAction)buttonTranslationTo_click:(id)sender { // TODO FIXXX
    [self dismissKeyboard];
}

- (IBAction)buttonTranslate_click:(id)sender {  // TODO FIXXX
    [self dismissKeyboard];

//    NSString *textToTranslate = self->_textViewSourceContent.text;
//    if (textToTranslate == nil || [textToTranslate length] == 0) {
//        return;
//    }
//
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *langTo = [[defaults objectForKey:[EnumConstants getConstant:LangTranslationTo]] objectForKey:[EnumConstants getConstant:ShortLangNameFrom]];
//    if (!langTo) {
//        langTo = @"en";
//    }
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSDictionary *json;
//
//        @try {
//            json = [Api translateText:textToTranslate lang:langTo];
//
//            NSString *translationContent = [json valueForKey:@"text"][0];
//
//            self.textViewTranslateContent.text = translationContent;
//
//            [self saveToHistoryOfTranslate:translationContent sourceText:textToTranslate];
//        } @catch (NSException *exception) {
//            UIAlertController *alert = [self createAlertDialog:@"Network error\n"];
//
//            [alert addAction:[UIAlertAction actionWithTitle:@"Ok"
//                                                      style:UIAlertActionStyleDefault
//                                                    handler:^(UIAlertAction *action) {
//                                                    }]];
//
//            [self presentViewController:alert animated:NO completion:nil];
//        }
//    });
}


// MARK: --
// MARK: Init content of UI elements

- (void)initButtonsTitle {
    UserDefaults *userDefaults = [[UserDefaults alloc] init];
    NSString *languageTitleFrom = [userDefaults getFullLanguageNameFrom];
    NSString *languageTitleTo = [userDefaults getFullLanguageNameTo];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[self buttonTranslationFrom] setTitle:languageTitleFrom forState:UIControlStateNormal];
            [[self buttonTranslationTo] setTitle:languageTitleTo forState:UIControlStateNormal];
        });
    });
}


// MARK: --
// MARK: Memory

- (void)saveToHistoryOfTranslate:(NSString *)textTranslate sourceText:(NSString *)sourceText {
//    NSMutableString *directionTranslate = [self extractionDirectionTranslation];
//
//    NSDictionary *infoOfTranslate = @{
//            @"direction": directionTranslate,
//            @"beforeTranslation": sourceText,
//            @"afterTranslation": textTranslate
//    };
//
//    NSString *keyHistory = @"history";
//
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSArray *collectionInfoOfTranslate = @[infoOfTranslate];
//
//    if (![defaults objectForKey:keyHistory]) {
//        [defaults setObject:collectionInfoOfTranslate forKey:keyHistory];
//        return;
//    }
//
//    NSMutableArray *content = [[defaults objectForKey:keyHistory] mutableCopy];
//
//    [content addObject:infoOfTranslate];
//    [defaults setObject:content forKey:keyHistory];

// TODO FIXXX
}


// Mark: --
// Mark: Services

- (void)dismissKeyboardByClicking {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];

    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)observingOnChangeLanguageTitles {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults addObserver:self
               forKeyPath:[EnumConstants getConstant:FullLangNameFrom]
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
}


@end
