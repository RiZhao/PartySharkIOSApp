//
//  NavigationManager.m
//  PartyShark
//
//  Created by Ri Zhao on 2016-01-22.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//
#import <RESideMenu/RESideMenu.h>
#import "NavigationManager.h"

#import "SettingsViewController.h"

#import "MainMenuViewController.h"
#import "MainViewController.h"
#import "SearchViewController.h"


@interface NavigationManager ()

@end

@implementation NavigationManager

+ (NavigationManager* )singletonInstance {
    
    /* Create singleton instance of NavigationManager to be used everywhere */
    static dispatch_once_t once_token;
    static NavigationManager *_singletonInstance = nil;
    
    dispatch_once(&once_token, ^{
        _singletonInstance = [[NavigationManager alloc] init];
    });
    
    return _singletonInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) goToSettings {
    SettingsViewController* settingsVC = [[SettingsViewController alloc] init];
    [self setViewControllers:@[settingsVC] animated:YES];
}

- (void) goToMainSectionWithAnimation:(BOOL)animated {
    
    [self setNavigationBarHidden:NO];
    MainViewController* mainSectionVC = [[MainViewController alloc] init];
    [self setViewControllers:@[mainSectionVC] animated:animated];
}

- (void) goToMainSection {
    [self goToMainSectionWithAnimation:YES];
}

- (void) goToSearch {
    SearchViewController* searchVC = [[SearchViewController alloc]init];
    [self setViewControllers:@[searchVC] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) joinPartyAlert{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Joining Party" message:@"Please Input Party Code" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Join" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self goToMainSection];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter text:";
        textField.secureTextEntry = NO;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}





@end
