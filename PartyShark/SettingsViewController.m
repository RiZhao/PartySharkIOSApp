//
//  SettingsViewController.m
//  PartyShark
//
//  Created by Ri Zhao on 2016-01-22.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "SettingsViewController.h"
#import "NavigationManager.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.defaultGenres = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Classic Rock", @0,
                          @"Metal", @1,
                          @"Jazz", @2,
                          @"Country", @3,
                          @"Top Hits", @4,
                          @"Classical", @5,
                          @"Folk", @6,
                          @"Electronic", @7, nil];
    
    NSString* partyCode = [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"];
    partyCode = [NSString stringWithFormat:@"Party Code: %@", partyCode];
    self.title = partyCode;
    
    self.maxParticipantsTextField.delegate = self;
    self.maxPlaylistSizeTextField.delegate = self;
    self.adminCodeTextField.delegate = self;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [self getSettings];
}

- (void) getSettings {
    
    settingsFactory *fetch = [[settingsFactory alloc]init];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("MyQueue", NULL);
    dispatch_async(concurrentQueue, ^{
        [fetch gatherData :^(BOOL success, settingsDataModel *set, NSError *error) {
            if (!success){
                NSLog(@"%@", error);
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.settings = set;
                    [self setSettingsValues: set];
                    
                });
            }
        }
         ];
    });
    
}

-(void)dismissKeyboard {
    [self.maxParticipantsTextField resignFirstResponder];
    [self.maxPlaylistSizeTextField resignFirstResponder];
    [self.adminCodeTextField resignFirstResponder];
}

- (void) setSettingsValues : (settingsDataModel*) settings {
    
    if ([self.settings.maxParticipants isKindOfClass:[NSNull class]])
        self.maxParticipantsTextField.placeholder = @"Unlimited";
    else
        self.maxParticipantsTextField.placeholder = [NSString stringWithFormat:@"%@", settings.maxParticipants];
    
    if ([self.settings.maxPlaylistSize isKindOfClass:[NSNull class]])
        self.maxPlaylistSizeTextField.placeholder = @"Unlimited";
    else
        self.maxPlaylistSizeTextField.placeholder = [NSString stringWithFormat:@"%@", settings.maxPlaylistSize];
    
    [self.virtualDJSwitchButton setOn:settings.virtualDJ];
    
    self.adminCodeTextField.placeholder = [[NSUserDefaults standardUserDefaults] stringForKey:@"admin_code"];
    
    NSString *isAdmin = [[NSUserDefaults standardUserDefaults] stringForKey:@"is_admin"];
    
    if ([settings.defaultGenre isKindOfClass:[NSNull class]] || [settings.defaultGenre floatValue] == -1) {
        
        [self.defaultRadioButton setTitle:@"None" forState:UIControlStateNormal];
        
    }
    else {
        
        [self.defaultRadioButton setTitle:[self.defaultGenres objectForKey:settings.defaultGenre] forState:UIControlStateNormal];
        
    }
    
    if ([isAdmin isEqual:@"0"]) {
        
        [self.defaultRadioButton setEnabled:NO];
        [self.maxParticipantsTextField setEnabled:NO];
        [self.maxPlaylistSizeTextField setEnabled:NO];
        [self.virtualDJSwitchButton setEnabled:NO];
        [self.updateOptionsButton setEnabled:NO];
        
    }
    else {
        
        [self.adminCodeTextField setEnabled:NO];
        [self.adminCodeButton setEnabled:NO];
        [self.adminCodeButton setHidden:YES];
        
        [self.defaultRadioButton setEnabled:YES];
        [self.maxParticipantsTextField setEnabled:YES];
        [self.maxPlaylistSizeTextField setEnabled:YES];
        [self.virtualDJSwitchButton setEnabled:YES];
        [self.updateOptionsButton setEnabled:YES];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)virtualDJSwitch:(id)sender {
}

- (IBAction)updateOptionsButtonPressed:(id)sender {
    
    [self updateSettings];
    
}
- (IBAction)adminCodeTextFieldEdit:(id)sender {
    
    
    
}
- (IBAction)adminCodeButtonPressed:(id)sender {
    
    if (![self.adminCodeTextField.text isEqualToString:@""]) {
        [self promoteToAdmin];
    }
    
}

- (IBAction)defaultRadioButtonPressed:(id)sender {
    
    NSMutableArray *genres = self.defaultGenres.allValues;
    NSString *none = @"None";
    NSMutableArray *empty = [[NSMutableArray alloc]init];
    NSMutableArray *newArray = [[empty arrayByAddingObjectsFromArray:genres] mutableCopy];
    [newArray insertObject:none atIndex:0];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Choose Default Genre" rows: newArray initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue){
                                           
                                           [self.defaultRadioButton setTitle:selectedValue forState:UIControlStateNormal];
                                           
                                           NSNumber *num = [NSNumber numberWithInteger:(selectedIndex-1)];
                                           
                                           if([selectedValue isEqualToString:@"None"]) {
                                               self.settings.defaultGenre = @-1;
                                           }
                                           else {
                                               self.settings.defaultGenre = [self.defaultGenres allKeysForObject:selectedValue][0];
                                           }
                                           
                                           
                                           
                                       }cancelBlock:^(ActionSheetStringPicker *picker) {
                                           
                                       } origin:sender];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // allow backspace
    if (!string.length)
    {
        return YES;
    }
    
    if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
    {
        // BasicAlert(@"", @"This field accepts only numeric entries.");
        return NO;
    }
    
    return YES;
}


- (void) promoteToAdmin {
    
    NSString *URLString = [NSString stringWithFormat:@"https://api.partyshark.tk/parties/%@/users/self", [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"]];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *value = [f numberFromString:self.adminCodeTextField.text];
    
    NSDictionary *parameters = @{@"admin_code": value};
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:URLString parameters:parameters error:nil];
    
    [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            //Error
            NSLog(@"Error: %@", error);
            
        } else {
            
            if ([[responseObject objectForKey:@"is_admin"]  isEqual: @1]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:self.adminCodeTextField.text forKey:@"admin_code"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
            // Saves if the user is now an admin
            [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"is_admin"] forKey:@"is_admin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self setSettingsValues : self.settings];
            
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    
    [dataTask resume];
}

- (void) updateSettings {
    
    NSString *URLString = [NSString stringWithFormat:@"https://api.partyshark.tk/parties/%@/settings", [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"]];
    
    //Set these to the set values
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSNumber *virtualDJ = [NSNumber numberWithBool:self.virtualDJSwitchButton.isOn];
    // NSNumber *vetoRatio = @0.30;
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:virtualDJ forKey:@"virtual_dj"];
    
    if (![self.maxPlaylistSizeTextField.text isEqualToString:@""]) {
        [parameters setObject:[f numberFromString:self.maxPlaylistSizeTextField.text] forKey:@"playthrough_cap"];
    }
    
    if (![self.maxParticipantsTextField.text isEqualToString:@""]) {
        [parameters setObject:[f numberFromString:self.maxParticipantsTextField.text] forKey:@"user_cap"];
    }
    
    [parameters setObject:self.settings.defaultGenre forKey:@"default_genre"];

    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:URLString parameters:parameters error:nil];
    
    [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            //Error
            NSLog(@"Error: %@", error);
            
        } else {
            
            self.settings.maxPlaylistSize = [responseObject objectForKey:@"playthrough_cap"];
            self.settings.maxParticipants = [responseObject objectForKey:@"user_cap"];
            self.settings.virtualDJ = [[responseObject objectForKey:@"virtual_dj"] boolValue];
            self.settings.defaultGenre = [responseObject objectForKey:@"default_genre"];
            
            [self setSettingsValues : self.settings];
            
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    
    [dataTask resume];
}

@end
