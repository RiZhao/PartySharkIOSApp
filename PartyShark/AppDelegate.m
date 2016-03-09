//
//  AppDelegate.m
//  PartyShark
//
//  Created by Ri Zhao on 2016-01-19.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "AppDelegate.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//Navigation
#import "NavigationManager.h"
#import "MainMenuViewController.h"
#import "MainViewController.h"
#import <RESideMenu/RESideMenu.h>

// ViewControllers
#import "WalkThroughViewController.h"

// Statics
#import "SystemStatics.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    self.window                    = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen]bounds]];
    self.navManager  = [NavigationManager singletonInstance];
    MainViewController* mainVC     = [[MainViewController alloc] init];
    [self.navManager setViewControllers:@[mainVC]];
    
    MainMenuViewController* menuVC = [[MainMenuViewController alloc] init];
    self.sideMenuVC         = [[RESideMenu alloc] initWithContentViewController:self.navManager
                                                                leftMenuViewController:menuVC
                                                               rightMenuViewController:nil];
    // Customize menu
    self.sideMenuVC.panGestureEnabled        = NO;
    self.sideMenuVC.scaleBackgroundImageView = NO;
    self.sideMenuVC.scaleMenuView            = NO;
    self.sideMenuVC.contentViewShadowEnabled = YES;
    //sideMenuVC.backgroundImage          = [UIImage imageNamed:@"background"];
    
    
    
    //Tutorial Screen setup
    
    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithTitle:@"Picture 1"
                                                            subTitle:@"1"
                                                         pictureName:@"tutorial_background_00@2x.jpg"
                                                            duration:3.0];
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithTitle:@"Picture 2"
                                                            subTitle:@"2"
                                                         pictureName:@"tutorial_background_01@2x.jpg"
                                                            duration:3.0];
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithTitle:@"Picture 3"
                                                            subTitle:@"3"
                                                         pictureName:@"tutorial_background_02@2x.jpg"
                                                            duration:3.0];
    ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithTitle:@"Picture 4"
                                                            subTitle:@"4"
                                                         pictureName:@"tutorial_background_03@2x.jpg"
                                                            duration:3.0];
    ICETutorialPage *layer5 = [[ICETutorialPage alloc] initWithTitle:@"Picture 5"
                                                            subTitle:@"5"
                                                         pictureName:@"tutorial_background_04@2x.jpg"
                                                            duration:3.0];
    NSArray *tutorialLayers = @[layer1,layer2,layer3,layer4,layer5];
    
    
    ICETutorialLabelStyle *titleStyle = [[ICETutorialLabelStyle alloc] init];
    [titleStyle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
    [titleStyle setTextColor:[UIColor whiteColor]];
    [titleStyle setLinesNumber:1];
    [titleStyle setOffset:180];
    [[ICETutorialStyle sharedInstance] setTitleStyle:titleStyle];
    
    // Set the subTitles style with few properties and let the others by default.
    [[ICETutorialStyle sharedInstance] setSubTitleColor:[UIColor whiteColor]];
    [[ICETutorialStyle sharedInstance] setSubTitleOffset:150];
    
    // Init tutorial.
    self.viewController = [[ICETutorialController alloc] initWithPages:tutorialLayers
                                                              delegate:self];
    
    // Run it.
    //[self.viewController startScrolling];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    
    //customize navbarcontroller
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xFFFFFF)];
    [[UINavigationBar appearance] setTintColor:UIColorFromRGB(0xFF5722)];
    
    NSDictionary *attributes = @{
                                 NSUnderlineStyleAttributeName: @1,
                                 NSForegroundColorAttributeName : UIColorFromRGB(0x000000),
                                 NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:17]
                                 };
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    
    
    return true;
}

#pragma mark - ICETutorialController delegate
- (void)tutorialController:(ICETutorialController *)tutorialController scrollingFromPageIndex:(NSUInteger)fromIndex toPageIndex:(NSUInteger)toIndex {
    //NSLog(@"Scrolling from page %lu to page %lu.", (unsigned long)fromIndex, (unsigned long)toIndex);
}

- (void)tutorialControllerDidReachLastPage:(ICETutorialController *)tutorialController {
    //NSLog(@"Tutorial reached the last page.");
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnLeftButton:(UIButton *)sender {

}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnRightButton:(UIButton *)sender {
    // Setup left hand nav
    
    
    //self.window.rootViewController = self.sideMenuVC;
    //[self.navManager goToMainSection];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Joining Party" message:@"Please Input Party Code" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Join" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        self.window.rootViewController = self.sideMenuVC;
        [self.navManager goToMainSection];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter text:";
        textField.secureTextEntry = NO;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];

    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    

}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [self saveContext];
}


#pragma mark - Core Data stack



@end
