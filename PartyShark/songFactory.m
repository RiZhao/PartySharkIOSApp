//
//  songFactory.m
//  PartyShark
//
//  Created by Ri Zhao on 2016-03-10.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "songFactory.h"


@implementation songFactory

-(id)init{
    self = [super init];
    
    return self;
}

- (void) gatherData : (NSString*) textbarText : (newCompletionBlock)completionBlock{
    
    NSString *searchTerm = textbarText;
    fetchData *fetch = [[fetchData alloc]init];
    [fetch fetchsearchResults:searchTerm :^(BOOL success, NSMutableArray *data, NSError *error) {
        if (!success){
            NSLog(@"%@", error);
        }else{
            self.songResultArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < data.count; i++){
                songDataModel *songModel = [[songDataModel alloc]init];
                
                self.songs = [data objectAtIndex:i];
                songModel.songCode =        [self.songs objectAtIndex:0];
                songModel.songDuration =    [self.songs objectAtIndex:2];
                songModel.songTitle =       [self.songs objectAtIndex:3];
                songModel.songArtist =      [self.songs objectAtIndex:4];
               
                [self.songResultArray addObject:songModel];
                
            }
            if (self.songResultArray) {
                completionBlock(YES, self.songResultArray, nil);
                
            }else{
                completionBlock(NO, nil, nil);
                
            }
        }
    }];
    
}

@end
