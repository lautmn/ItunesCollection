//
//  ThemeUITableView.m
//  ItunesCollection
//
//  Created by lautmn on 2018/11/5.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "ThemeUITableView.h"
#import "ThemeManager.h"

@implementation ThemeUITableView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self shouldChangeTheme];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChangeTheme) name:@"SHOULD_CHANGE_THEME" object:nil];
    }
    return self;
}

- (void)shouldChangeTheme {
    ThemeManager *themeManager = [ThemeManager shareInstance];
    self.backgroundColor = [[themeManager getCurrentThemeName] isEqualToString:@"淺色主題"] ? [UIColor whiteColor] : [UIColor darkGrayColor];
}

@end
