//
//  AppDelegate.h
//  yandex_translator
//
//  Created by Nikolay Eckert on 28/09/2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;
@property(readwrite, strong) NSPersistentContainer *persistentContainer;
@property(readwrite, strong) NSManagedObjectContext *context;

- (void)saveContext;

- (NSManagedObjectContext *)mainQueueContext;

- (NSManagedObjectContext *)privateQueueContext;

@end

