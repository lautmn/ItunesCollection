//
//  ThemeUIButton.m
//  ItunesCollection
//
//  Created by lautmn on 2018/11/5.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "ThemeUIButton.h"
#import "ThemeManager.h"

@implementation ThemeUIButton

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
    [self setTitleColor:[[themeManager getCurrentThemeName] isEqualToString:@"淺色主題"] ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
}

@end

