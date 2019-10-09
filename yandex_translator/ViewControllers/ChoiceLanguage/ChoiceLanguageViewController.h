//
//  ChoiceLanguage.h
//  yandex_translator
//
//  Created by Nikolay Eckert on 09/10/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import <UIkit/UIKit.h>


@interface ChoiceLanguageViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerChoiceLanguage;

- (IBAction)buttonChoice_click:(id)sender;

@end
