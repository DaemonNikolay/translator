//
//  SecondViewController.m
//  yandex_translator
//
//  Created by Nikolay Eckert on 28/09/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import "HistoryViewController.h"
#import "TranslatedContent.h"

@interface HistoryViewController() {
    NSArray *names;
    
    NSInteger selectNumberElementOfPicker;
}

@end


@implementation HistoryViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];

    names = @[@"gfd", @"1234", @"uiytuyrt"];

    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
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
    selectNumberElementOfPicker = row;
}

- (IBAction)button_click:(id)sender {
    NSLog(@"%@", names[selectNumberElementOfPicker]);
    self.pickerView.hidden = true;
}


@end
