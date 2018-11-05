//
//  ThemeManager.m
//  ItunesCollection
//
//  Created by lautmn on 2018/11/5.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "ThemeManager.h"
#import <UIKit/UIKit.h>

@implementation ThemeManager

+ (instancetype)shareInstance {
    static ThemeManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ThemeManager alloc] init];
    });
    return instance;
}


- (NSArray *)getThemeList {
    return @[@"深色主題", @"淺色主題"];
}

- (NSString *)getCurrentThemeName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currentThemeName = [userDefaults objectForKey:@"themeName"];
    if (!currentThemeName) {
        currentThemeName = @"淺色主題";
        [userDefaults setObject:currentThemeName forKey:@"themeName"];
        [userDefaults synchronize];
    }
    [UIApplication sharedApplication].statusBarStyle = [currentThemeName isEqualToString:@"淺色主題"] ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
    return currentThemeName;
}

- (void)changeThemeColorWithName:(NSString *)themeName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:themeName forKey:@"themeName"];
    [userDefaults synchronize];
    
    [UIApplication sharedApplication].statusBarStyle = [[self getCurrentThemeName] isEqualToString:@"淺色主題"] ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOULD_CHANGE_THEME" object:nil];
}

@end
