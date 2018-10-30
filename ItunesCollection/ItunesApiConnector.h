//
//  ItunesApiConnector.h
//  ItunesCollection
//
//  Created by lautmn on 2018/10/30.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DoneBlock)(id result, NSError *error);

@interface ItunesApiConnector : NSObject

+ (instancetype)shareInstance;
- (void)searchItunesMusicWithKeyword:(NSString *)keyword completion:(DoneBlock)doneBlock;

@end
