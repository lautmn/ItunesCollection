//
//  ItunesApiConnector.m
//  ItunesCollection
//
//  Created by lautmn on 2018/10/30.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "ItunesApiConnector.h"
#import <AFNetworking.h>

#define ITUNES_SEARCH_API_URL @"https://itunes.apple.com/search"

@implementation ItunesApiConnector

#pragma mark - Public Methods

+ (instancetype)shareInstance {
    static ItunesApiConnector *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ItunesApiConnector alloc] init];
    });
    return instance;
}

- (void)searchItunesMusicWithKeyword:(NSString *)keyword completion:(DoneBlock)doneBlock {
    NSDictionary *parameters = @{@"term":keyword, @"media":@"music"};
    [self doHttpGet:ITUNES_SEARCH_API_URL parameters:parameters completion:doneBlock];
}

- (void)searchItunesMovieWithKeyword:(NSString *)keyword completion:(DoneBlock)doneBlock {
    NSDictionary *parameters = @{@"term":keyword, @"media":@"movie"};
    [self doHttpGet:ITUNES_SEARCH_API_URL parameters:parameters completion:doneBlock];
}

#pragma mark - Private Methods

- (void)doHttpGet:(NSString *)urlString
       parameters:(NSDictionary *)parameters
       completion:(DoneBlock)doneBlock {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [sessionManager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        doneBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        doneBlock(nil, error);
    }];
}

@end
