//
//  TranslatorViewController.m
//  yandex_translator
//
//  Created by Nikolay Eckert on 28/09/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import "TranslatorViewController.h"
#import "Api.h"


@interface TranslatorViewController () {
    NSDictionary *languages;
    NSInteger selectNumberElementOfPicker;
}

@end


@implementation TranslatorViewController

// MARK: -
// MARK: Init propeties

NSString *const LangTranslationFrom = @"langTranslationFrom";
NSString *const LangTranslationTo = @"langTranslationTo";

NSString *const ShortLangName = @"shortLangName";
NSString *const FullLangName = @"fullLangName";

NSString *const NameFileHistoryRequests = @"textfile.txt";


// MARK: -
// MARK: Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initButtonTitleOfLabels];
    [self extractionDirectionsOfTranslateAsync];
}

// MARK: -
// MARK: PickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return languages.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [languages allValues][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectNumberElementOfPicker = row;
}

// MARK: -
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

// MARK: -
// MARK: Actions

- (IBAction)buttonTranslationFrom_click:(id)sender {
    UIAlertController *alert = [self createDialogForChoiceLanguage];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
        NSString *languageName = [self->languages allValues][self->selectNumberElementOfPicker];
        
        [self saveLanguage:languageName langKey:LangTranslationFrom];
        
        self.labelOfButtonTranslateFrom.text = languageName;
    }]];
    
    [self presentViewController:alert animated:NO completion:nil];
}

- (IBAction)buttonTranslationTo_click:(id)sender {
    UIAlertController *alert = [self createDialogForChoiceLanguage];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
        
        NSString *languageName = [self->languages allValues][self->selectNumberElementOfPicker];
        
        [self saveLanguage:languageName langKey:LangTranslationTo];
        
        self.labelOfButtonTranslateTo.text = languageName;
    }]];
    
    [self presentViewController:alert animated:NO completion:nil];
}

- (IBAction)buttonTranslate_click:(id)sender {
    NSString *textToTransalte = self->_textViewSourceContent.text;
    
    if (textToTransalte == nil || [textToTransalte length] == 0) {
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
            json = [Api translateText:textToTransalte language:langTo];
            
            NSString *translationContent = [json valueForKey:@"text"][0];
            
            self.textViewTranslateContent.text = translationContent;
            
            [self saveToHistoryOfTranslate:translationContent sourceText:textToTransalte];
        } @catch (NSException *exception) {
            UIAlertController *alert = [self createAlertDialog:@"Network error\n"];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) { }]];
            
            [self presentViewController:alert animated:NO completion:nil];
        }
    });
}

// MARK: -
// MARK: Init content of UI elements

- (void)initButtonTitleOfLabels {
    self.labelOfButtonTranslateFrom.text = [self getLanguageTitle:LangTranslationFrom defaultLangName:@"Русский"];
    self.labelOfButtonTranslateTo.text = [self getLanguageTitle:LangTranslationTo defaultLangName:@"English"];
}

- (NSString *)getLanguageTitle:(NSString *)languageName defaultLangName:(NSString *)defaultLanguageName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults objectForKey:languageName]) {
        return defaultLanguageName;
    }
    else {
        return [[defaults objectForKey:languageName] objectForKey:FullLangName];
    }
}

// MARK: -
// MARK: Memory

- (void)saveLanguage:(NSString *)languageName langKey:(NSString *)languageKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *shortNameLang;
    NSString *fullNameLang;
    
    for (NSString *langKey in languages) {
        if ([languages objectForKey:langKey] == languageName) {
            shortNameLang = langKey;
            fullNameLang = languageName;
            
            break;
        }
    }
    
    NSDictionary *language = @{
        ShortLangName : shortNameLang,
        FullLangName : fullNameLang
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

// MARK: -
// MARK: Extractions

- (NSMutableString *)extractionDirectionTranslation {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableString *directionTranslate = [NSMutableString string];
    
    NSString *langTranslationFrom = [[defaults objectForKey:LangTranslationFrom] objectForKey:FullLangName];
    NSString *langTranslationTo = [[defaults objectForKey:LangTranslationTo] objectForKey:FullLangName];
    
    if (!langTranslationFrom) {
        langTranslationFrom = self.labelOfButtonTranslateFrom.text;
    }
    
    if (!langTranslationTo) {
        langTranslationTo = self.labelOfButtonTranslateTo.text;
    }
    
    [directionTranslate appendFormat:@"%@->%@", langTranslationFrom, langTranslationTo];
    
    return directionTranslate;
}

- (void)extractionDirectionsOfTranslateAsync {
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            self->languages = [[Api getListSupportedLanguages:@"ru"] objectForKey:@"langs"];
        } @catch (NSException *exception) {
            UIAlertController *alert = [self createAlertDialog:@"Network error\n"];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Reload"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                
                [self extractionDirectionsOfTranslateAsync];
            }]];
            
            [self presentViewController:alert animated:NO completion:nil];
        }
    });
}

@end
