//
//  ThemeUINavigationBar.m
//  ItunesCollection
//
//  Created by lautmn on 2018/11/5.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "ThemeUINavigationBar.h"
#import "ThemeManager.h"

@implementation ThemeUINavigationBar

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
    // 背景顏色
    self.barTintColor = [[themeManager getCurrentThemeName] isEqualToString:@"淺色主題"] ? [UIColor cyanColor] : [UIColor blackColor];
    // 返回按鈕文字圖案顏色
    self.tintColor = [[themeManager getCurrentThemeName] isEqualToString:@"淺色主題"] ? [UIColor blackColor] : [UIColor whiteColor];
    // 標題顏色
    self.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[[themeManager getCurrentThemeName] isEqualToString:@"淺色主題"] ? [UIColor blackColor] : [UIColor whiteColor], NSForegroundColorAttributeName, nil];
}


@end
