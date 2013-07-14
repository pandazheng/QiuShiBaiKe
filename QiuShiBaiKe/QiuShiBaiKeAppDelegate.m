//
//  QiuShiBaiKeAppDelegate.m
//  QiuShiBaiKe
//
//  Created by panda zheng on 13-7-14.
//  Copyright (c) 2013年 panda zheng. All rights reserved.
//

#import "QiuShiBaiKeAppDelegate.h"

#import "QiuShiBaiKeViewController.h"

@implementation QiuShiBaiKeAppDelegate
@synthesize tabBarController = _tabBarController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
//    self.viewController = [[[QiuShiBaiKeViewController alloc] initWithNibName:@"QiuShiBaiKeViewController" bundle:nil] autorelease];
//    self.window.rootViewController = self.viewController;
    QiuShiBaiKeViewController *viewController1,*viewController2,*viewController3;
    QiuShiBaiKeViewController *viewController4,*viewController5;
    
    viewController1 = [[QiuShiBaiKeViewController alloc] initWithNibName:nil bundle:nil];
    viewController1.title = @"随便逛逛";
    viewController1.MainQiuTime=QiuShiTimeRandom;
    viewController2 = [[QiuShiBaiKeViewController alloc] initWithNibName:nil bundle:nil];
    viewController2.title = @"8小时最糗";
    viewController2.MainQiuTime=QiuShiTimeDay;
    viewController3 = [[[QiuShiBaiKeViewController alloc] initWithNibName:nil bundle:nil]autorelease];
    viewController3.title = @"7天内最糗";
    viewController3.MainQiuTime=QiuShiTimeWeek;
    viewController4 = [[[QiuShiBaiKeViewController alloc] initWithNibName:nil bundle:nil]autorelease];
    viewController4.title = @"30天内最糗";
    viewController4.MainQiuTime=QiuShiTimeMonth;
    viewController5 = [[[QiuShiBaiKeViewController alloc] initWithNibName:nil bundle:nil]autorelease];
    viewController5.title = @"真相";
    viewController5.MainQiuTime=QiuShiTimePhoto;
    
    
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:viewController1] ;
    nav1.navigationBarHidden=YES;
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:viewController2] ;
    nav2.navigationBarHidden=YES;
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:viewController3];
    nav3.navigationBarHidden=YES;
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:viewController4];
    nav4.navigationBarHidden=YES;
    UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController:viewController5] ;
    nav5.navigationBarHidden=YES;
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:nav1,nav2,nav3,nav4,nav5, nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
