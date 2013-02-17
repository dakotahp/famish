//
//  AppDelegate.m
//  Famish
//
//  Created by Francisco Flores on 11/27/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#import "AppDelegate.h"
#import "TimezonePickerViewController.h"
#import "FamishInAppPurchaseHelper.h"
#import <Crashlytics/Crashlytics.h>
#import "Tapstream.h"
#import "Appirater.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [FamishInAppPurchaseHelper sharedInstance];
    
    // Crashlytics
    [Crashlytics startWithAPIKey:@"af61c1874590fd1ecd6b32ead09f7418ae099444"];
    
    // Tapstream
    [Tapstream createWithAccountName:@"adr-enal-in" developerSecret:@"-bGuUhmAQEWzR_Ol2zXkQw"];
    
    // Appirater
    [Appirater setAppId:@"590035109"];
    [Appirater appLaunched:YES];
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
    [Appirater appEnteredForeground:YES];
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
