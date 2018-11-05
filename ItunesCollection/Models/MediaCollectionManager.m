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

- (void)changeThemeColor {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:@"themeColor"] || [[userDefaults objectForKey:@"themeColor"] isEqualToString:@"darkColor"]) {
        [userDefaults setObject:@"lightColor" forKey:@"themeColor"];
    } else {
        [userDefaults setObject:@"darkColor" forKey:@"themeColor"];
    }
    [userDefaults synchronize];
    
    NSDictionary *lightColorInfo = @{@"123":[UIColor redColor]};
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"GET_FIRST_LOGIN_SUCCESS" object:responseObject];
}

@end
