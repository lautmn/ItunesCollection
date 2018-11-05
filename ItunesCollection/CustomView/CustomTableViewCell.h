//
//  CustomTableViewCell.h
//  ItunesCollection
//
//  Created by lautmn on 2018/11/5.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomTableViewCell;
@protocol CustomCellDelegate <NSObject>
- (void)didCollectItemInCell:(CustomTableViewCell *)cell;
- (void)didClickReadMoreInCell:(CustomTableViewCell *)cell;
@end

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *trackName;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *collectionName;
@property (weak, nonatomic) IBOutlet UILabel *trackTime;
@property (weak, nonatomic) IBOutlet UILabel *longDescription;

@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;

@property (weak, nonatomic) IBOutlet UIButton *readMoreButton;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@property (weak, nonatomic) id <CustomCellDelegate> delegate;

@end
