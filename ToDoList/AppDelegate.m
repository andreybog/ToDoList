//
//  AppDelegate.m
//  ToDoList
//
//  Created by goit on 8/10/16.
//  Copyright © 2016 goit. All rights reserved.
//


/*
 10.08.2016
 Due: Friday, August 12, 2016 at 11:59 pm
 1. Добавить свойcтво priority в ToDoItem
 - это свойство будет enum, которое состоит из элементов Low, Default, High, Urgent
 - в зависимости от этого поля будет изменен цвет текста
 2. При добавлении ячейки учесть приоритетность
 3. Добавить возможность удаления ячейки свайпом
 */

/*
 10.08.2016
 ToDoItems:
  1. Добавить картинки для разных приоритетов
 2. Добавить возможность изменять приоритет прямо на самой ячейке
 - при нажатии на кнопку с картинкой приоритета увеличивать его по кругу
 3*. Редактировать название todoitem при нажатии на ячейку.
 */


#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
