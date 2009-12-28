//
//  DatabaseShoppingListAppDelegate.h
//  DatabaseShoppingList
//
//  Created by Steve Baker on 12/28/09.
//  Copyright Beepscore LLC 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatabaseShoppingListAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end