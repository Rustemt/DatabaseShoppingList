//
//  DatabaseShoppingListAppDelegate.h
//  DatabaseShoppingList
//
//  Created by Chris Adamson on 3/27/09.
//  Copyright Subsequently and Furthermore, Inc. 2009. All rights reserved.
//
//
//  Licensed with the Apache 2.0 License
//  http://apache.org/licenses/LICENSE-2.0
//

#import <UIKit/UIKit.h>

@interface DatabaseShoppingListAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>
{
    UIWindow *window;
    UITabBarController *tabBarController;
    NSString *dbFilePath;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, copy, readonly) NSString *dbFilePath;

@end
