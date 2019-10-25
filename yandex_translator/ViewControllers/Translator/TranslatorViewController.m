//
//  TranslatorViewController.m
//  yandex_translator
//
//  Created by Nikolay Eckert on 28/09/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import "TranslatorViewController.h"

@interface TranslatorViewController () {
    Boolean isLanguageFrom;
}

@end


@implementation TranslatorViewController

// MARK: --
// MARK: Constants

const NSString *IDENTIFIER_SEGUE_CHOOSE_LANGUAGE = @"chooseLanguage";


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

    [defaults removeObserver:self
                  forKeyPath:[EnumTranslationDirections
                          getAttributeTranslationDirection:(EnumAttributesTranslationDirections) FullLangNameTo]
    ];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

    NSString *fullLangNameFrom = [EnumConstants getConstant:FullLangNameFrom];
    NSString *fullLangNameTo = [EnumConstants getConstant:FullLangNameTo];

    if ([keyPath isEqualToString:fullLangNameFrom]) {
        ExtractForTranslate *extractForTranslate = [[ExtractForTranslate alloc] init];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [extractForTranslate extractionDirectionsOfTranslate];
                [self initButtonsTitle];
            });
        });
    } else if ([keyPath isEqualToString:fullLangNameTo]) {
        [self initButtonsTitle];
        [[self buttonTranslate] sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:(NSString *) IDENTIFIER_SEGUE_CHOOSE_LANGUAGE]) {
        TranslateDirectionsViewController *translateDirectionsViewController = [segue destinationViewController];
        translateDirectionsViewController.isLanguageFrom = isLanguageFrom;
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

    isLanguageFrom = YES;

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
    isLanguageFrom = NO;

    [self performSegueWithIdentifier:(NSString *) IDENTIFIER_SEGUE_CHOOSE_LANGUAGE sender:nil];
}

- (IBAction)buttonTranslate_click:(id)sender {  // TODO FIXXX
    [self dismissKeyboard];

    NSString *textToTranslate = self->_textViewSourceContent.text;
    if (textToTranslate == nil || [textToTranslate length] == 0) {
        return;
    }

    UserDefaults *userDefaults = [[UserDefaults alloc] init];
    NSString *shortLangName = [userDefaults getShortLanguageNameTo];

    ExtractForTranslate *extractForTranslate = [[ExtractForTranslate alloc] init];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *translatedContent = [extractForTranslate extractionTranslatedContent:textToTranslate
                                                                         shortLangName:shortLangName];

        dispatch_sync(dispatch_get_main_queue(), ^{
            self.textViewTranslateContent.text = translatedContent;
        });
    });





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

    [defaults addObserver:self
               forKeyPath:[EnumConstants getConstant:FullLangNameTo]
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
}

- (void)clearTranslatedTextView {
    self.textViewTranslateContent.text = @"";
}


@end
