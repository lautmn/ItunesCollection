//
//  CustomTableViewCell.m
//  ItunesCollection
//
//  Created by lautmn on 2018/11/5.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)collectButtonClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCollectItemInCell:)]) {
        [self.delegate didCollectItemInCell:self];
    }
}

- (IBAction)readMoreButtonClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickReadMoreInCell:)]) {
        [self.delegate didClickReadMoreInCell:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
