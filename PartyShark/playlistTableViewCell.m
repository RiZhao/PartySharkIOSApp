//
//  playlistTableViewCell.m
//  PartyShark
//
//  Created by Ri Zhao on 2016-03-04.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "playlistTableViewCell.h"

@implementation playlistTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // configure control(s)
        
    }
    return self;
}

@end
