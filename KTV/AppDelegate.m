//
//  AppDelegate.m
//  KTV
//
//  Created by stevenhu on 15/4/17.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "AppDelegate.h"
#import "UINavigationBar+customBar.h"
#import "MainViewController.h"
#import "SoundViewController.h"
#import "SettingViewController.h"
#import "BokongView.h"
#import "NmainViewController.h"
#import "UIImage+Resize.h"

@interface AppDelegate ()<BokongDelegate> {
    int currentItem;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UITabBarController *tabVC=[[UITabBarController alloc]init];
    tabVC.delegate=self;
    
    UIImage *imagebottom=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"nav_bottom_bg" ofType:@"png"]];
    UIImage *imagetop=[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"song_bt_bg" ofType:@"png"]]stretchableImageWithLeftCapWidth:0 topCapHeight:30];
    
    [tabVC.tabBar setBackgroundImage:imagebottom];
    NSDictionary * navBarTitleTextAttributes =@{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    
    UINavigationController *navC1=[[UINavigationController alloc]initWithRootViewController:[[MainViewController alloc]init]];
    //      UINavigationController *navC1=[[UINavigationController alloc]initWithRootViewController:[[NmainViewController alloc]init]];
    
    [navC1.navigationBar setBackgroundImage:imagetop forBarMetrics:UIBarMetricsDefault];
    
    //    UINavigationController *navC2=[[UINavigationController alloc]initWithRootViewController:[[UIViewController alloc]init]];
    //    [navC2.navigationBar setBackgroundImage:imagetop forBarMetrics:UIBarMetricsDefault];
    
    UINavigationController *navC3=[[UINavigationController alloc]initWithRootViewController:[[SoundViewController alloc]init]];
    [navC3.navigationBar setBackgroundImage:imagetop forBarMetrics:UIBarMetricsDefault];
    UINavigationController *navC4=[[UINavigationController alloc]initWithRootViewController:[[SettingViewController alloc]init]];
    [navC4.navigationBar setBackgroundImage:imagetop forBarMetrics:UIBarMetricsDefault];
    //    tabVC.viewControllers=@[navC1,navC2,navC3,navC4];
    tabVC.viewControllers=@[navC1,navC3,navC4];
    //设置标题
    
    //    navC1.title = @"k歌";
    //    navC2.title = @"播控";
    //    navC3.title = @"声控";
    //    navC4.title = @"设置";
    
    //kfq 0071
    navC1.title = @"k歌";
    navC3.title = @"播控";
    navC4.title = @"设置";
    
    //
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = [UIColor orangeColor];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    //设置图片
    navC1.tabBarItem.image = [[UIImage imageNamed:@"kege"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navC1.tabBarItem.selectedImage=[[UIImage imageNamed:@"kege_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    //    navC2.tabBarItem.image = [[UIImage imageNamed:@"bokong"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //     navC2.tabBarItem.selectedImage = [[UIImage imageNamed:@"bokong_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    navC3.tabBarItem.image = [[UIImage imageNamed:@"shenkong"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navC3.tabBarItem.selectedImage = [[UIImage imageNamed:@"shenkong_seleted"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    navC4.tabBarItem.image = [[UIImage imageNamed:@"setting"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navC4.tabBarItem.selectedImage = [[UIImage imageNamed:@"setting_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    currentItem=0;
    self.window.rootViewController=tabVC;
    return YES;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    //kfq
    currentItem=(int)tabBarController.selectedIndex;
}

- (void)boKongHadDimssed {
    
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
