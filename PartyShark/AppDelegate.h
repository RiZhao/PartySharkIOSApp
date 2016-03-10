//
//  AppDelegate.h
//  PartyShark
//
//  Created by Ri Zhao on 2016-01-19.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "WalkthroughViewController.h"
#import "ICETutorialController.h"
#import "NavigationManager.h"
#import <RESideMenu/RESideMenu.h>
#import "SCLAlertView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, ICETutorialControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UIWindow *onboardingWindow;
@property (strong, nonatomic) ICETutorialController *viewController;


@property (strong, nonatomic) NavigationManager *navManager;
@property (strong, nonatomic) RESideMenu *sideMenuVC;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) NSString *toSavePartyCode;

- (void) setUpTutorialScreen;

- (BOOL) tryJoinParty: (NSString *)partyCode;
- (BOOL) userAlreadyInParty :(NSString*)partyCode :(NSString*)userID;

@end
