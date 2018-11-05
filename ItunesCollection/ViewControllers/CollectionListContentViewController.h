//
//  CollectionListContentViewController.h
//  ItunesCollection
//
//  Created by lautmn on 2018/11/5.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionListContentViewController : UIViewController

typedef enum : NSUInteger {
    MovieAndMusic = 0,
    Movie,
    Music
} MediaType;

@property MediaType displayMediaType;

@end
