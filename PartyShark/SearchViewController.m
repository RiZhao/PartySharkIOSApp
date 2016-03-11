//
//  SearchViewController.m
//  PartyShark
//
//  Created by Ri Zhao on 2016-03-08.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    SBSearchBar *searchBarCustom = [[SBSearchBar alloc] initWithFrame:CGRectMake(0, 63, 200, 50)]; //set your searchBar frame
    searchBarCustom.delegate = self;
    
    //if you need custom color, font, etc
    [searchBarCustom setTextColor:[UIColor whiteColor]];
    searchBarCustom.placeHolderColor = [UIColor whiteColor];
    searchBarCustom.font = [UIFont fontWithName:@"Arial" size:14];
    
    //you can set a custom lens image
    searchBarCustom.lensImage = [UIImage imageNamed:@"ic_lens"];
    //you can set a custom X image
    //searchBarCustom.cancelButtonImage = [UIImage imageNamed:@"FormReset"];
    
    //you cand show an additional cancel button
    searchBarCustom.addExtraCancelButton = YES;
    
    
    searchBarCustom.searchFieldsContainerView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1];
    searchBarCustom.extraCancelButton.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    searchBarCustom.extraCancelButton.layer.borderWidth = 1;
    searchBarCustom.extraCancelButton.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1].CGColor;
    
    
    [self.view addSubview:searchBarCustom];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 113, self.view.frame.size.width, self.view.frame.size.height - 113 ) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];



}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"searchCell";
    searchTableViewCell *cell = (searchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"searchResultCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.delegate = self;
    
    songDataModel *songModel = self.searchResultArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = songModel.songTitle;
    cell.artistLabel.text = songModel.songArtist;
    cell.albumLabel.text = songModel.songCode;
    cell.imageView.image = nil;
    return cell;
    
}

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction;
{
    return YES;
}

-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings :(searchTableViewCell*) searchCell
{
    
    swipeSettings.transition = MGSwipeTransitionClipCenter;
    swipeSettings.keepButtonsSwiped = NO;
    expansionSettings.buttonIndex = 0;
    expansionSettings.threshold = 1.0;
    expansionSettings.expansionLayout = MGSwipeExpansionLayoutCenter;
    expansionSettings.expansionColor = [UIColor colorWithRed:33/255.0 green:175/255.0 blue:67/255.0 alpha:1.0];
    expansionSettings.triggerAnimation.easingFunction = MGSwipeEasingFunctionCubicOut;
    expansionSettings.fillOnTrigger = YES;
    if (direction == MGSwipeDirectionRightToLeft) {
        MGSwipeButton * queueButton = [MGSwipeButton buttonWithTitle:@"Add to Dock" backgroundColor:[UIColor colorWithRed:33/255.0 green:175/255.0 blue:67/255.0 alpha:1.0] padding:15 callback:^BOOL(MGSwipeTableCell *sender) {
            
            [self addSongToPlaylist: searchCell];
            
            NSLog(@"Queue song");
            return YES;
        }];
        return @[queueButton];
    }
    
    return nil;
}

-(void) swipeTableCell:(MGSwipeTableCell*) cell didChangeSwipeState:(MGSwipeState)state gestureIsActive:(BOOL)gestureIsActive
{
    NSString * str;
    switch (state) {
        case MGSwipeStateNone: str = @"None"; break;
        case MGSwipeStateSwippingLeftToRight: str = @"SwippingLeftToRight"; break;
        case MGSwipeStateSwippingRightToLeft: str = @"SwippingRightToLeft"; break;
        case MGSwipeStateExpandingLeftToRight: str = @"ExpandingLeftToRight"; break;
        case MGSwipeStateExpandingRightToLeft: str = @"ExpandingRightToLeft"; break;
    }
    NSLog(@"Swipe state: %@ ::: Gesture: %@", str, gestureIsActive ? @"Active" : @"Ended");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.searchResultArray){
        return self.searchResultArray.count;
    }else {
        return 0;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 80;
}


- (void) addSongToPlaylist: (searchTableViewCell*) cell {
    
    NSString *URLString = [NSString stringWithFormat:@"http://nreid26.xyz:3000/parties/%@/playlist", [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"]];
    
    //TODO: get the song code from the cell and send it to the server
    NSDictionary *parameters = @{@"code": cell.albumLabel.text};
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    
    [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            //Error
            NSLog(@"Error: %@", error);
            
        } else {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [dataTask resume];
    
}

- (void) SBSearchBarSearchButtonClicked:(SBSearchBar *)searchBar {
    songFactory *factory = [[songFactory alloc]init];
    NSString *temp = searchBar.text;
    songFactory *fetch = [[songFactory alloc]init];
    [fetch gatherData:temp :^(BOOL success, NSMutableArray *songs, NSError *error) {
        if (!success){
            NSLog(@"%@", error);
        }else {
            self.searchResultArray = songs;
            [self.tableView reloadData];
        
        }
    }];
    [searchBar resignFirstResponder];
}


@end
