//
// Created by Nikolay Eckert on 27.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//


#import "Alert.h"


@implementation Alert

// MARK: --
// MARK: Public methods

+ (UIAlertController *)alertErrorCreateDirectionsList {
    NSString *message = @"Error create directions list";
    NSString *titleAlert = @"Directions list";
    NSString *buttonCancelTitle = @"Understand";

    UIAlertController *alert = [self templateAlertError:message title:titleAlert buttonCancelTitle:buttonCancelTitle];

    return alert;
}

+ (UIAlertController *)alertErrorUpdateTitles {
    NSString *message = @"Error update languages";
    NSString *titleAlert = @"Languages";
    NSString *buttonCancelTitle = @"Understand";

    UIAlertController *alert = [self templateAlertError:message title:titleAlert buttonCancelTitle:buttonCancelTitle];

    return alert;
}

+ (UIAlertController *)alertErrorTranslate {
    NSString *message = @"Error translate content";
    NSString *titleAlert = @"Translate";
    NSString *buttonCancelTitle = @"Understand";

    UIAlertController *alert = [self templateAlertError:message title:titleAlert buttonCancelTitle:buttonCancelTitle];

    return alert;
}

+ (UIAlertController *)alertError:(NSString *)message {
    NSString *titleAlert = @"Error";
    NSString *buttonCancelTitle = @"Understand";

    UIAlertController *alert = [self templateAlertError:message title:titleAlert buttonCancelTitle:buttonCancelTitle];

    return alert;
}

// MARK: --
// MARK: Private methods

+ (UIAlertController *)createAlertDialog:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    return alert;
}

+ (UIAlertController *)templateAlertError:(NSString *)message
                                    title:(NSString *)title
                        buttonCancelTitle:(NSString *)buttonCancelTitle {

    UIAlertController *alert = [self createAlertDialog:message];
    [alert setTitle:title];

    UIAlertAction *buttonUnderstand = [UIAlertAction actionWithTitle:buttonCancelTitle
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
    [alert addAction:buttonUnderstand];

    return alert;
}

@end