//
//  MediaCollectionManager.m
//  ItunesCollection
//
//  Created by lautmn on 2018/10/31.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "MediaCollectionManager.h"
#import <UIKit/UIKit.h>

@implementation MediaCollectionManager

+ (instancetype)shareInstance {
    static MediaCollectionManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MediaCollectionManager alloc] init];
    });
    return instance;
}

- (void)storeCollectionWithInfo:(NSDictionary *)info andType:(NSString *)type {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *collectionArray = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:type]];
    [collectionArray addObject:info];
    [userDefaults setObject:collectionArray forKey:type];
    [userDefaults synchronize];
}

- (void)deleteCollectionWithTrackId:(NSString *)trackId andType:(NSString *)type {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *collectionArray = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:type]];
    for (NSMutableDictionary *collectionInfo in collectionArray) {
        if ([[collectionInfo objectForKey:@"trackId"] isEqualToString:trackId]) {
            [collectionArray removeObject:collectionInfo];
            break;
        }
    }
    [userDefaults setObject:collectionArray forKey:type];
    [userDefaults synchronize];
}

- (BOOL)isCollectedTrackId:(NSString *)trackId andType:(NSString *)type {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *collectionArray = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:type]];
    for (NSDictionary *collectionInfo in collectionArray) {
        if ([[collectionInfo objectForKey:@"trackId"] isEqualToString:trackId]) {
            return YES;
        }
    }
    return NO;
}

- (NSMutableArray *)getCollectionWithType:(NSString *)type {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:type]];
}

- (NSUInteger)getCollectionAmount {
    return [self getCollectionWithType:@"movie"].count + [self getCollectionWithType:@"music"].count;
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
