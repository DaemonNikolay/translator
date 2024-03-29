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

    CGColorRef colorGray = [[UIColor grayColor] CGColor];
    self.textViewSourceContent.layer.borderColor = colorGray;
    self.textViewTranslateContent.layer.borderColor = colorGray;

    self.textViewSourceContent.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self observingUserDefaults];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self removeObserversForUserDefault];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

    NSString *fullLangNameFrom = [EnumConstants getConstant:FullLangNameFrom];
    NSString *fullLangNameTo = [EnumConstants getConstant:FullLangNameTo];
    NSString *error = [EnumConstants getConstant:CustomError];

    if ([keyPath isEqualToString:fullLangNameFrom]) {
        ExtractForTranslate *extractForTranslate = [[ExtractForTranslate alloc] init];

        [self showActivityIndicator];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                @try {
                    @synchronized (self) {
                        [extractForTranslate extractionDirectionsOfTranslate];
                    }
                }
                @catch (NSException *) {
                    [self hideActivityIndicator];
                    [self presentViewController:[Alert alertErrorUpdateTitles] animated:YES completion:nil];

                    return;
                }

                [self initButtonsTitle];
                [self hideActivityIndicator];
            });
        });
    } else if ([keyPath isEqualToString:fullLangNameTo]) {
        [self initButtonsTitle];
        [[self buttonTranslate] sendActionsForControlEvents:UIControlEventTouchUpInside];
    } else if ([keyPath isEqualToString:error]) {
        UserDefaults *userDefaults = [[UserDefaults alloc] init];
        NSString *message = [userDefaults getError];

        [self presentViewController:[Alert alertError:message] animated:YES completion:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:(NSString *) IDENTIFIER_SEGUE_CHOOSE_LANGUAGE]) {
        TranslateDirectionsViewController *translateDirectionsViewController = [segue destinationViewController];
        translateDirectionsViewController.isLanguageFrom = isLanguageFrom;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }

    return YES;
}


// MARK: --
// MARK: Button actions

- (IBAction)buttonTranslationFrom_click:(id)sender {
    [self dismissKeyboard];

    isLanguageFrom = YES;

    [self movementChooseLanguageWithUpdateDirections];
}

- (IBAction)buttonTranslationTo_click:(id)sender {
    [self dismissKeyboard];

    isLanguageFrom = NO;

    [self movementChooseLanguageWithUpdateDirections];
}

- (IBAction)buttonTranslate_click:(id)sender {
    [self dismissKeyboard];

    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceCharacterSet];
    NSString *textToTranslate = [self->_textViewSourceContent.text stringByTrimmingCharactersInSet:whiteSpace];
    if (textToTranslate == nil || [textToTranslate length] == 0) {
        return;
    }

    [self showActivityIndicator];

    ExtractForTranslate *extractForTranslate = [[ExtractForTranslate alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *translatedContent;
        @try {
            translatedContent = [extractForTranslate extractionTranslatedContent:textToTranslate];
        }
        @catch (NSException *) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self hideActivityIndicator];
                [self presentViewController:[Alert alertErrorTranslate] animated:YES completion:nil];
            });

            return;
        }

        dispatch_sync(dispatch_get_main_queue(), ^{
            [self hideActivityIndicator];

            self.textViewTranslateContent.text = translatedContent;
        });
    });
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
// MARK: Services

- (void)dismissKeyboardByClicking {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];

    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)observingUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults addObserver:self
               forKeyPath:[EnumConstants getConstant:FullLangNameFrom]
                  options:NSKeyValueObservingOptionNew
                  context:NULL];

    [defaults addObserver:self
               forKeyPath:[EnumConstants getConstant:FullLangNameTo]
                  options:NSKeyValueObservingOptionNew
                  context:NULL];

    [defaults addObserver:self
               forKeyPath:[EnumConstants getConstant:CustomError]
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
}

- (void)hideActivityIndicator {
    [[self activityIndicator] setHidden:YES];
}

- (void)showActivityIndicator {
    [[self activityIndicator] setHidden:NO];
}

- (void)movementChooseLanguageWithUpdateDirections {
    [self showActivityIndicator];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([ExtractForTranslate directionsCount] == 0) {
            @synchronized (self) {
                ExtractForTranslate *extractForTranslate = [[ExtractForTranslate alloc] init];

                @try {
                    [extractForTranslate extractionDirectionsOfTranslate];
                }
                @catch (NSException *) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self hideActivityIndicator];
                        [self presentViewController:[Alert alertErrorCreateDirectionsList] animated:YES completion:nil];
                    });

                    return;
                }
            }
        }

        dispatch_sync(dispatch_get_main_queue(), ^{
            [self hideActivityIndicator];

            [self performSegueWithIdentifier:(NSString *) IDENTIFIER_SEGUE_CHOOSE_LANGUAGE sender:nil];
        });
    });
}

- (void)removeObserversForUserDefault {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults removeObserver:self
                  forKeyPath:[EnumConstants getConstant:FullLangNameFrom]
                     context:NULL
    ];

    [defaults removeObserver:self
                  forKeyPath:[EnumConstants getConstant:FullLangNameTo]
                     context:NULL
    ];

    [defaults removeObserver:self
                  forKeyPath:[EnumConstants getConstant:CustomError]
                     context:NULL
    ];
}

@end
