//
//  Api.m
//  yandex_translator
//
//  Created by Nikolay Eckert on 06/10/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Api.h"


@implementation Api

NSString *baseUrl = @"https://translate.yandex.net/api/v1.5/tr.json";
NSString *apiToken = @"trnsl.1.1.20171112T154849Z.fc55bd1bcb9d8d6c.0c15c5d09889cf7c9a0d6dfb330619ddf07a9389";


+ (NSDictionary *)translateText:(NSString *)content lang:(NSString *)language {
    content = [content stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];

    NSMutableString *url = [NSMutableString string];
    [url appendString:baseUrl];
    [url appendString:@"/translate"];
    [url appendFormat:@"?key=%@", apiToken];
    [url appendFormat:@"&text=%@", content];
    [url appendFormat:@"&lang=%@", language];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];

    NSURLResponse __block *resp;
    NSError __block *err = NULL;

    NSDictionary *json = [self sendSynchronousRequest:request returningResponse:&resp error:&err];

    NSLog(@"RESULT /translate: \n %@", json);

    return json;
}

+ (NSDictionary *)getListSupportedLanguages:(NSString *)ui {
    NSMutableString *url = [NSMutableString string];
    [url appendString:baseUrl];
    [url appendString:@"/getLangs"];
    [url appendFormat:@"?key=%@", apiToken];
    [url appendFormat:@"&ui=%@", ui];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];

    NSURLResponse __block *resp;
    NSError __block *err = NULL;

    NSDictionary *json = [self sendSynchronousRequest:request returningResponse:&resp error:&err];

    NSLog(@"RESULT /getLangs: \n %@", json);

    return json;
}

+ (NSDictionary *)sendSynchronousRequest:(NSURLRequest *)request
                       returningResponse:(NSURLResponse **)response
                                   error:(NSError **)error {
    NSError __block *err = NULL;
    NSData __block *data;
    BOOL __block reqProcessed = false;
    NSURLResponse __block *resp;

    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *_Nullable _data,
                                             NSURLResponse *_Nullable _response,
                                             NSError *_Nullable _error) {
                                         resp = _response;
                                         err = _error;
                                         data = _data;
                                         reqProcessed = true;
                                     }] resume];

    while (!reqProcessed) {
        [NSThread sleepForTimeInterval:0];
    }

    *response = resp;
    *error = err;

    NSDictionary *json = [NSJSONSerialization
            JSONObjectWithData:data
                       options:(NSJSONReadingOptions) kNilOptions error:error];

    return json;
}

+ (Boolean)checkInternetConnection {
    NSString *contentOfUrl = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://www.google.com"]];

    return contentOfUrl != nil;
}


@end
