//
//  ChoiceLanguage.m
//  yandex_translator
//
//  Created by Nikolay Eckert on 09/10/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChoiceLanguageViewController.h"
#import "TranslatorViewController.h"


@interface ChoiceLanguageViewController() {
    NSArray *names;
    
    NSInteger selectElementNumberOfPicker;
}

@end


@implementation ChoiceLanguageViewController

- (void)viewDidLoad {
    names = @[@"jgfido", @"ewq", @"76567"];
    
    self.pickerChoiceLanguage.dataSource = self;
    self.pickerChoiceLanguage.delegate = self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return names.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return names[row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectElementNumberOfPicker = row;
}

- (IBAction)buttonChoice_click:(id)sender {
    NSLog(@"%@", names[selectElementNumberOfPicker]);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
