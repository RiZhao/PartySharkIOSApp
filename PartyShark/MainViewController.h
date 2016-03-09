//
//  MainViewController.h
//  PartyShark
//
//  Created by Ri Zhao on 2016-01-22.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "MGSwipeTableCell.h"
#include "MGSwipeButton.h"
#import "BaseViewController.h"
#import "CurrentSongTableViewCell.h"    
#import "playlistTableViewCell.h"

@interface MainViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *currentSongView;
@property (strong, nonatomic) UITableView *playlistView;

@property (strong, nonatomic)   NSArray *indexArray;
@property (nonatomic)           int             rowCount;

@property(strong, nonatomic) NSArray *titles;

@property(strong, nonatomic) UIRefreshControl *refreshControl;

@end
