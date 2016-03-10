//
//  leavePartyViewController.m
//  PartyShark
//
//  Created by Ri Zhao on 2016-03-09.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "leavePartyViewController.h"

@interface leavePartyViewController ()

@end

@implementation leavePartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leavePartyClicked{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"savedPartyCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [((AppDelegate*) [[UIApplication sharedApplication] delegate]) setUpTutorialScreen];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
