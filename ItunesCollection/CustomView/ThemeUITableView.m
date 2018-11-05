//
//  ThemeUITableView.m
//  ItunesCollection
//
//  Created by lautmn on 2018/11/5.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "ThemeUITableView.h"
#import "MediaCollectionManager.h"

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
    MediaCollectionManager *collectionManager = [MediaCollectionManager shareInstance];
    self.backgroundColor = [[collectionManager getCurrentThemeName] isEqualToString:@"淺色主題"] ? [UIColor whiteColor] : [UIColor darkGrayColor];
}

@end
