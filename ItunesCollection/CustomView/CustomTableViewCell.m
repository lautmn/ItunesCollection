//
//  CustomTableViewCell.m
//  ItunesCollection
//
//  Created by lautmn on 2018/11/5.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "ThemeManager.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self shouldChangeTheme];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChangeTheme) name:@"SHOULD_CHANGE_THEME" object:nil];
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

- (void)shouldChangeTheme {
    ThemeManager *themeManager = [ThemeManager shareInstance];
    self.backgroundColor = [[themeManager getCurrentThemeName] isEqualToString:@"淺色主題"] ? [UIColor whiteColor] : [UIColor darkGrayColor];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
