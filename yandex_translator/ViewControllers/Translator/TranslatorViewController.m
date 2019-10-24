//
//  TranslatorViewController.m
//  yandex_translator
//
//  Created by Nikolay Eckert on 28/09/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import "TranslatorViewController.h"
#import "Api.h"
#import "CoreDataManaged.h"


@interface TranslatorViewController () {
    NSDictionary *languages;
    NSInteger selectNumberElementOfPicker;
}

@end


@implementation TranslatorViewController


// MARK: --
// MARK: Init Constants

NSString *const LangTranslationFrom = @"langTranslationFrom";
NSString *const LangTranslationTo = @"langTranslationTo";

NSString *const ShortLangName = @"shortLangName";
NSString *const FullLangName = @"fullLangName";


// MARK: --
// MARK: Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initButtonTitleOfLabels];
    [self extractionDirectionsOfTranslateAsync];
    [self dismissKeyboardByClicking];


    CoreDataManaged *coreDataManaged = [[CoreDataManaged alloc] init];
    [coreDataManaged saveValue:@"My name is Joke" entity:@"TranslationDirections" attribute:@"name"];

    NSLog(@"ikgui %@", [coreDataManaged getValues:@"TranslationDirections" attribute:@"name"]);
}


// MARK: --
// MARK: PickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return languages.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [languages allValues][(NSUInteger) row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectNumberElementOfPicker = row;
}


// MARK: --
// MARK: Additional UI

- (UIAlertController *)createDialogForChoiceLanguage {
    UIAlertController *alert = [self createAlertDialog:@"Choice lang\n\n\n\n\n\n\n"];

    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 270.0, 200.0)];

    picker.dataSource = self;
    picker.delegate = self;

    [alert.view addSubview:picker];

    return alert;
}

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

    UIAlertController *alert = [self createDialogForChoiceLanguage];

    [alert addAction:[UIAlertAction actionWithTitle:@"Ok"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                NSUInteger numberSelectedElement = (NSUInteger) self->selectNumberElementOfPicker;
                                                NSString *languageName = [self->languages allValues][numberSelectedElement];

                                                [self saveLanguage:languageName langKey:LangTranslationFrom];
                                                [self extractionDirectionsOfTranslateAsync];
                                                [[self buttonTranslationFrom] setTitle:languageName forState:UIControlStateNormal];
                                            }]];

    [self presentViewController:alert animated:NO completion:nil];
}

- (IBAction)buttonTranslationTo_click:(id)sender {
    [self dismissKeyboard];

    UIAlertController *alert = [self createDialogForChoiceLanguage];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                NSUInteger numberSelectedElement = (NSUInteger) self->selectNumberElementOfPicker;
                                                NSString *languageName = [self->languages allValues][numberSelectedElement];

                                                [self saveLanguage:languageName langKey:LangTranslationTo];
                                                [[self buttonTranslationTo] setTitle:languageName forState:UIControlStateNormal];
                                            }]];

    [self presentViewController:alert animated:NO completion:nil];
}

- (IBAction)buttonTranslate_click:(id)sender {
    [self dismissKeyboard];

    NSString *textToTranslate = self->_textViewSourceContent.text;
    if (textToTranslate == nil || [textToTranslate length] == 0) {
        return;
    }

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *langTo = [[defaults objectForKey:LangTranslationTo] objectForKey:ShortLangName];
    if (!langTo) {
        langTo = @"en";
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *json;

        @try {
            json = [Api translateText:textToTranslate lang:langTo];

            NSString *translationContent = [json valueForKey:@"text"][0];

            self.textViewTranslateContent.text = translationContent;

            [self saveToHistoryOfTranslate:translationContent sourceText:textToTranslate];
        } @catch (NSException *exception) {
            UIAlertController *alert = [self createAlertDialog:@"Network error\n"];

            [alert addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                    }]];

            [self presentViewController:alert animated:NO completion:nil];
        }
    });
}


// MARK: --
// MARK: Init content of UI elements

- (void)initButtonTitleOfLabels {
    NSString *languageTitleFrom = [self getLanguageTitle:LangTranslationFrom defaultLangName:@"Русский"];
    NSString *languageTitleTo = [self getLanguageTitle:LangTranslationTo defaultLangName:@"Английский"];

    [[self buttonTranslationFrom] setTitle:languageTitleFrom forState:UIControlStateNormal];
    [[self buttonTranslationTo] setTitle:languageTitleTo forState:UIControlStateNormal];
}

- (NSString *)getLanguageTitle:(NSString *)languageName defaultLangName:(NSString *)defaultLanguageName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (![defaults objectForKey:languageName]) {
        return defaultLanguageName;
    } else {
        return [[defaults objectForKey:languageName] objectForKey:FullLangName];
    }
}

// MARK: --
// MARK: Memory

- (void)saveLanguage:(NSString *)languageName langKey:(NSString *)languageKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *shortNameLang;
    NSString *fullNameLang;

    for (NSString *langKey in languages) {
        if (languages[langKey] == languageName) {
            shortNameLang = langKey;
            fullNameLang = languageName;

            break;
        }
    }

    NSDictionary *language = @{
            ShortLangName: shortNameLang,
            FullLangName: fullNameLang
    };

    [defaults setObject:language forKey:languageKey];
}

- (void)saveToHistoryOfTranslate:(NSString *)textTranslate sourceText:(NSString *)sourceText {
    NSMutableString *directionTranslate = [self extractionDirectionTranslation];

    NSDictionary *infoOfTranslate = @{
            @"direction": directionTranslate,
            @"beforeTranslation": sourceText,
            @"afterTranslation": textTranslate
    };

    NSString *keyHistory = @"history";

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *collectionInfoOfTranslate = @[infoOfTranslate];

    if (![defaults objectForKey:keyHistory]) {
        [defaults setObject:collectionInfoOfTranslate forKey:keyHistory];
        return;
    }

    NSMutableArray *content = [[defaults objectForKey:keyHistory] mutableCopy];

    [content addObject:infoOfTranslate];
    [defaults setObject:content forKey:keyHistory];
}


// MARK: --
// MARK: Extractions

- (NSMutableString *)extractionDirectionTranslation {
    NSMutableString *directionTranslate = [NSMutableString string];

    NSString *langTranslationFrom = [[self buttonTranslationFrom] currentTitle];
    NSString *langTranslationTo = [[self buttonTranslationTo] currentTitle];

    [directionTranslate appendFormat:@"%@->%@", langTranslationFrom, langTranslationTo];

    return directionTranslate;
}

- (void)extractionDirectionsOfTranslateAsync {
    dispatch_async(dispatch_get_main_queue(), ^{

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *shortLanguageNameFrom = [[defaults objectForKey:LangTranslationFrom] objectForKey:ShortLangName];
        NSString *shortLanguageNameTo = [[defaults objectForKey:LangTranslationTo] objectForKey:ShortLangName];

        if (!shortLanguageNameFrom) {
            shortLanguageNameFrom = @"ru";
        }
        if (!shortLanguageNameTo) {
            shortLanguageNameTo = @"en";
        }

        @try {
            self->languages = [Api getListSupportedLanguages:shortLanguageNameFrom][@"langs"];

            NSString *titleTranslationFrom = self->languages[shortLanguageNameFrom];
            NSString *titleTranslationTo = self->languages[shortLanguageNameTo];

            [[self buttonTranslationFrom] setTitle:titleTranslationFrom forState:UIControlStateNormal];
            [[self buttonTranslationTo] setTitle:titleTranslationTo forState:UIControlStateNormal];

        } @catch (NSException *exception) {
            UIAlertController *alert = [self createAlertDialog:@"Network error\n"];

            [alert addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                    }]];

            [self presentViewController:alert animated:NO completion:nil];
        }
    });
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

@end
