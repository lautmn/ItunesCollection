//
//  ThemeManager.h
//  ItunesCollection
//
//  Created by lautmn on 2018/11/5.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeManager : NSObject

+ (instancetype)shareInstance;
- (NSArray *)getThemeList;
- (NSString *)getCurrentThemeName;
- (void)changeThemeColorWithName:(NSString *)themeName;

@end
