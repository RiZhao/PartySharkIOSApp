//
//  settingsDataModel.h
//  PartyShark
//
//  Created by Ryan Toth on 2016-03-21.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "AFNetworking.h"

@interface settingsDataModel : NSObject

@property (strong, nonatomic) NSNumber *maxParticipants;
@property (strong, nonatomic) NSNumber *maxPlaylistSize;
@property BOOL *virtualDJ;
@property (strong, nonatomic) NSNumber *defaultGenre;

@end
