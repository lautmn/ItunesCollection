//
//  MusicTableViewCell.h
//  ItunesCollection
//
//  Created by lautmn on 2018/10/31.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MusicTableViewCell;
@protocol MusicCellDelegate <NSObject>
- (void)didCollectMusicInCell:(MusicTableViewCell *)cell;
@end

@interface MusicTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *trackName;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *collectionName;
@property (weak, nonatomic) IBOutlet UILabel *trackTime;

@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UIButton *collectMusicButton;

@property (weak, nonatomic) id <MusicCellDelegate> delegate;

@end
