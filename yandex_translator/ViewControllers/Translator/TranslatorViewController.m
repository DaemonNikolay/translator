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
    NSDictionary *names;
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
    
    [self initButtonContentOfLabels];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *langs = [[Api getListSupportedLanguages:@"ru"] objectForKey:@"langs"];
        
        self->names = langs;
    });
}

// MARK: -
// MARK: Coder

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (!self) {
        return nil;
    }
    
    NSLog(@"%@", [coder decodeObjectForKey:@"title"]);
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    NSString *content = @"this is title";
    [encoder encodeObject:content forKey:@"title"];
}

// MARK: -
// MARK: PickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return names.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [names allValues][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectNumberElementOfPicker = row;
}

// MARK: -
// MARK: Additional UI

- (UIAlertController *)createDialogForChoiceLanguage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"Choice lang\n\n\n\n\n\n\n"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 270.0, 200.0)];
    
    picker.dataSource = self;
    picker.delegate = self;
    
    [alert.view addSubview:picker];
    
    return alert;
}

// MARK: -
// MARK: Actions

- (IBAction)buttonTranslationFrom_click:(id)sender {
    UIAlertController *alert = [self createDialogForChoiceLanguage];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
        NSString *languageName = [self->names allValues][self->selectNumberElementOfPicker];
        
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
        
        NSString *languageName = [self->names allValues][self->selectNumberElementOfPicker];
        
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
        NSDictionary *json = [Api translateText:textToTransalte language:langTo];
        
        NSString *translationContent = [json valueForKey:@"text"][0];
        
        self.textViewTranslateContent.text = translationContent;
        
        [self appendTranslateToFile:translationContent sourceText:textToTransalte];
    });
}

// MARK: -
// MARK: Services

- (void)initButtonContentOfLabels {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *langTo = [[defaults objectForKey:LangTranslationTo] objectForKey:ShortLangName];
    
    if (![defaults objectForKey:LangTranslationFrom]) {
        NSString *langName = @"Русский";
        self.labelOfButtonTranslateFrom.text = langName;
    }
    else {
        self.labelOfButtonTranslateFrom.text = [[defaults objectForKey:LangTranslationFrom] objectForKey:FullLangName];
    }
    
    if (![defaults objectForKey:LangTranslationTo]) {
        NSString *langName = @"English";
        self.labelOfButtonTranslateTo.text = langName;
    }
    else {
        self.labelOfButtonTranslateTo.text = [[defaults objectForKey:LangTranslationTo] objectForKey:FullLangName];
    }
}

- (void)saveLanguage:(NSString *)languageName langKey:(NSString *)langKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *shortNameLang;
    NSString *fullNameLang;
    
    for (NSString *langKey in names) {
        if([names objectForKey:langKey] == languageName) {
            shortNameLang = langKey;
            fullNameLang = languageName;
            
            break;
        }
    }
    
    NSDictionary *lang = @{ ShortLangName : shortNameLang, FullLangName : fullNameLang};
    
    [defaults setObject:lang forKey:langKey];
}

- (void)appendTranslateToFile:(NSString *)textTranslate sourceText:(NSString *)sourceText {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableString *directionTranslate = [self extractionDirectTranslation];
    
    NSLog(@"gfd %@", directionTranslate);
    
    NSDictionary *cont = @{@"direction": directionTranslate, @"beforeTranslation": sourceText, @"afterTranslation": textTranslate};
    
    NSArray *arr = @[cont];
    
    NSString *field = @"history";
    
    if (![defaults objectForKey:field]) {
        [defaults setObject:arr forKey:field];
        return;
    }
    
    NSArray *content = [defaults objectForKey:field];
    NSMutableArray *arr1 = [@[content] mutableCopy];
    
    [arr1 addObject:arr];
    
    [defaults setObject:arr1 forKey:field];
    
    
    NSLog(@"rewrew %@", [defaults objectForKey:field]);
}

- (NSMutableString *)extractionDirectTranslation {
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

@end
