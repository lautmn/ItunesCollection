//
//  MediaCollectionManager.h
//  ItunesCollection
//
//  Created by lautmn on 2018/10/31.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaCollectionManager : NSObject

+ (instancetype)shareInstance;
- (void)storeCollectionWithInfo:(NSDictionary *)info;
- (void)deleteCollectionWithTrackId:(NSString *)trackId;

@end
