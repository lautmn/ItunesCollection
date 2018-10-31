//
//  MediaCollectionManager.m
//  ItunesCollection
//
//  Created by lautmn on 2018/10/31.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "MediaCollectionManager.h"

@implementation MediaCollectionManager

+ (instancetype)shareInstance {
    static MediaCollectionManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MediaCollectionManager alloc] init];
    });
    return instance;
}

- (void)storeCollectionWithInfo:(NSDictionary *)info {
    
}

- (void)deleteCollectionWithTrackId:(NSString *)trackId {
    
}

@end
