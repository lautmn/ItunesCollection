//
//  ThemeUINavigationBar.m
//  ItunesCollection
//
//  Created by lautmn on 2018/11/5.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "ThemeUINavigationBar.h"
#import "MediaCollectionManager.h"

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
    MediaCollectionManager *collectionManager = [MediaCollectionManager shareInstance];
    // 背景顏色
    self.barTintColor = [[collectionManager getCurrentThemeName] isEqualToString:@"淺色主題"] ? [UIColor cyanColor] : [UIColor blackColor];
    // 返回按鈕文字圖案顏色
    self.tintColor = [[collectionManager getCurrentThemeName] isEqualToString:@"淺色主題"] ? [UIColor blackColor] : [UIColor whiteColor];
    // 標題顏色
    self.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[[collectionManager getCurrentThemeName] isEqualToString:@"淺色主題"] ? [UIColor blackColor] : [UIColor whiteColor], NSForegroundColorAttributeName, nil];
}


@end
