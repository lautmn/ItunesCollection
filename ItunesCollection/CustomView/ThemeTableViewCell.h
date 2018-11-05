//
//  ThemeTableViewCell.h
//  ItunesCollection
//
//  Created by lautmn on 2018/11/5.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ThemeUILabel.h"

@interface ThemeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@end
