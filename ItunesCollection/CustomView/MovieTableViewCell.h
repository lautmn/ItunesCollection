//
//  MovieTableViewCell.h
//  ItunesCollection
//
//  Created by lautmn on 2018/10/31.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MovieTableViewCell;
@protocol MovieCellDelegate <NSObject>
- (void)didCollectMovieInCell:(MovieTableViewCell *)cell;
- (void)didClickReadMoreInCell:(MovieTableViewCell *)cell;
@end

@interface MovieTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *trackName;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *collectionName;
@property (weak, nonatomic) IBOutlet UILabel *trackTime;
@property (weak, nonatomic) IBOutlet UILabel *longDescription;

@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;

@property (weak, nonatomic) IBOutlet UIButton *readMoreButton;
@property (weak, nonatomic) IBOutlet UIButton *collectMovieButton;

@property (weak, nonatomic) id <MovieCellDelegate> delegate;

@end
