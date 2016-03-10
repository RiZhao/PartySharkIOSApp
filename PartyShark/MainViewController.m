//
//  MainViewController.m
//  PartyShark
//
//  Created by Ri Zhao on 2016-01-22.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "MainViewController.h"
#import "NavigationManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentSongView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, self.view.frame.size.width, 200 ) style:UITableViewStylePlain];
    self.currentSongView.scrollEnabled = NO;
    
    self.playlistView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height - 200) style:UITableViewStylePlain];
    self.playlistView.alwaysBounceVertical = YES;
    
    
    [self.view addSubview:self.currentSongView];
    [self.view addSubview:self.playlistView];
    
    self.currentSongView.delegate = self;
    self.currentSongView.dataSource = self;
    
    self.playlistView.delegate = self;
    self.playlistView.dataSource = self;
    
    //refresh
    
        self.refreshControl = [[UIRefreshControl alloc]init];
        [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
        [self.playlistView addSubview:self.refreshControl];
    
    
    [self reloadData];
    
}

- (void) reloadData{
    
 

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    //wrap with if authenticated function so it doesnt pop up everytime

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //SECTIONS
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //ROWS
    if (tableView == self.currentSongView) {
        return 1;
    }else {
        return 10;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    
    UIImage *myImage = [UIImage imageNamed:@"tutorial_background_00@2x.jpg"];
    if (tableView == self.currentSongView) {
        //UIImage *myImage = [UIImage imageNamed:@"tutorial_background_00@2x.jpg"];
        
        NSString *identifier = @"DockCurrentSongCell";
        CurrentSongTableViewCell *cell = (CurrentSongTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"dockCurrentSongCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"skip song" backgroundColor:[UIColor greenColor]callback:^BOOL(MGSwipeTableCell *sender) {
            //skip functionality
            NSLog(@"skipped");
            return YES;
        }], [MGSwipeButton buttonWithTitle:@"play/pause" backgroundColor:[UIColor blueColor]callback:^BOOL(MGSwipeTableCell *sender) {
            //play/pause functionality
            return YES;
        }]];
        cell.rightSwipeSettings.transition = MGSwipeTransitionDrag;
        
        
        cell.titleLabel.text = @"Sorry";
        cell.artistLabel.text = @"Justin";
        cell.albumLabel.text = @"Purpose";
        cell.albumView.image = myImage;
        
        return cell;
    }else {
        
        NSString *identifier2 = @"playlistCell";
        playlistTableViewCell *cell2 = (playlistTableViewCell *) [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell2 == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"playlistSongCell" owner:self options:nil];
            cell2 = [nib objectAtIndex:0];
        }
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        cell2.rightButtons = @[[MGSwipeButton buttonWithTitle:@"remove song" backgroundColor:[UIColor redColor]callback:^BOOL(MGSwipeTableCell *sender) {
            //remove functionality
            return YES;
        }]];
        cell2.rightSwipeSettings.transition = MGSwipeTransitionDrag;
        cell2.leftButtons = @[[MGSwipeButton buttonWithTitle:@"upvote" backgroundColor:[UIColor greenColor]callback:^BOOL(MGSwipeTableCell *sender) {
            //upvote functionality
            return YES;
        }], [MGSwipeButton buttonWithTitle:@"downvote" backgroundColor:[UIColor redColor]callback:^BOOL(MGSwipeTableCell *sender) {
            //downvote functionality
            return YES;
        }]];
        cell2.leftSwipeSettings.transition = MGSwipeTransitionDrag;
        
        cell2.titleLabel.text = @"Poetic Justice";
        cell2.artistLabel.text = @"Kendrick Lamar";
        cell2.suggestorLabel.text = @"Bill";
        cell2.voteLabel.text = @"12";
        cell2.voteLabel.textColor = [UIColor greenColor];
        cell2.artworkImage.image = myImage;
        
        return cell2;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if  (tableView == self.currentSongView){
        return 150;
    }else {
        return 80;
    }
    
}


#pragma refreshcontrol

- (void)handleRefresh:(id)sender
{
 
    // do your refresh here...
    NSLog(@"data reloaded");
    [self reloadData];
    [self.refreshControl endRefreshing];
}


@end