//
//  TranslatorViewController.m
//  yandex_translator
//
//  Created by Nikolay Eckert on 28/09/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import "TranslatorViewController.h"
#import "Api.h"
#import "ChoiceLanguageViewController.h"


@interface TranslatorViewController () {
    NSArray *names;
    NSInteger selectNumberElementOfPicker;
}
    
@end


@implementation TranslatorViewController

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
    
    names = @[@"423", @"hgfd",@"423", @"hgfd"@"423", @"hgfd"@"423", @"hgfd"@"423", @"hgfd"@"423", @"hgfd"@"423", @"hgfd"@"423", @"hgfd"];
    
    NSError __block *err = NULL;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/textfile.txt",
                          documentsDirectory];
    
    NSString* content1 = [NSString stringWithContentsOfFile:fileName
    encoding:NSUTF8StringEncoding
       error:NULL]; // its work
    
    NSLog(@"%@", content1);
    
    //create content - four lines of text
//    NSString *content = @"One\nTwo\nThree\nFour\nFive";
////    //save content to the documents directory
//    [content writeToFile:fileName
//              atomically:NO
//                encoding:NSStringEncodingConversionAllowLossy
//                   error:nil];
//
//    NSLog(@"%@", fileName);
    
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [Api getListSupportedLanguages:@"ru"];
    //        [Api translateText:@"привет" language:@"en"];
    //    });
}

//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    return ;
//}

- (IBAction)buttonTranslationFrom_click:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                        message:@"Choice lang\n\n\n\n\n\n\n"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 270.0, 200.0)];
    
    NSLog(@"1111 %f", picker.frame.size.width);
    NSLog(@"2222 %f", alert.view.frame.size.width);
    
    picker.dataSource = self;
    picker.delegate = self;
    
    [alert.view addSubview:picker];

    [alert addAction:[UIAlertAction actionWithTitle:@"Ok"
      style:UIAlertActionStyleDefault
    handler:^(UIAlertAction *action) {

        NSLog(@"Do Something Tapped %@", names[selectNumberElementOfPicker]); // TODO: заменить заглушку на реальное действие
    }]];
    
    [self presentViewController:alert animated:NO completion:nil];
    
//    [self performSegueWithIdentifier:@"choiceLanguage" sender:self];
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
    NSLog(@"654566");
    selectNumberElementOfPicker = row;
}

- (IBAction)buttonTranslationTo_click:(id)sender {
    NSLog(@"jgkfpdjg2");
}

- (IBAction)buttonTranslate_click:(id)sender {
    NSString *textToTransalte = _textViewSourceContent.text;
    
    if (textToTransalte == nil || [textToTransalte length] == 0) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *json = [Api translateText:textToTransalte language:@"en"];
        
        self.textViewTranslateContent.text = [json valueForKey:@"text"][0];
    });
}

@end
