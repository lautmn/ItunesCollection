//
//  MusicTableViewCell.m
//  ItunesCollection
//
//  Created by lautmn on 2018/10/31.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "MusicTableViewCell.h"

@implementation MusicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)collectButtonClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCollectMusicInCell:)]) {
        [self.delegate didCollectMusicInCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
