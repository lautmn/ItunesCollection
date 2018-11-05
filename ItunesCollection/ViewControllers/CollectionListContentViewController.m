//
//  CollectionListContentViewController.m
//  ItunesCollection
//
//  Created by lautmn on 2018/11/5.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "CollectionListContentViewController.h"
#import "CustomTableViewCell.h"
#import "MediaCollectionManager.h"

@interface CollectionListContentViewController () <UITableViewDataSource, UITableViewDelegate, CustomCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *collectionListTableView;

@property (strong, nonatomic) NSMutableArray *collectionListArray;

@property (strong, nonatomic) MediaCollectionManager *collectionManager;

@end

@implementation CollectionListContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.collectionManager = [MediaCollectionManager shareInstance];
    [self.collectionListTableView registerNib:[UINib nibWithNibName:@"MusicTableViewCell" bundle:nil] forCellReuseIdentifier:@"MusicTableViewCell"];
    [self.collectionListTableView registerNib:[UINib nibWithNibName:@"MovieTableViewCell" bundle:nil] forCellReuseIdentifier:@"MovieTableViewCell"];
    self.collectionListArray = [[NSMutableArray alloc] initWithArray:[self.collectionManager getCollectionWithType:[self getMediaType]]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldReload) name:@"SHOULD_RELOAD" object:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.collectionListArray.count > 0 ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.collectionListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *cellIdentifier;
    
    switch (self.displayMediaType) {
        case Movie:
            cellIdentifier = @"MovieTableViewCell";
            break;
            
        case Music:
            cellIdentifier = @"MusicTableViewCell";
            break;
            
        default:
            break;
    }

    CustomTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    customCell.delegate = self;
    customCell.trackName.text = [self.collectionListArray[indexPath.row] objectForKey:@"trackName"];
    customCell.artistName.text = [self.collectionListArray[indexPath.row] objectForKey:@"artistName"];
    customCell.collectionName.text = [self.collectionListArray[indexPath.row] objectForKey:@"collectionName"];
    customCell.trackTime.text = [NSString stringWithFormat:@"%@", [self.collectionListArray[indexPath.row] objectForKey:@"trackTimeMillis"]];
    customCell.longDescription.text = [self.collectionListArray[indexPath.row] objectForKey:@"longDescription"];
    
    NSString *imgName = [NSString stringWithFormat:@"img_%@.png", [self.collectionListArray[indexPath.row] objectForKey:@"trackId"]];
    NSString *imgPath = [cachesPath stringByAppendingPathComponent:imgName];
    customCell.artworkImageView.image = [UIImage imageNamed:@"Black.png"];
    if (![NSData dataWithContentsOfFile:imgPath]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *imgUrlString = [self.collectionListArray[indexPath.row] objectForKey:@"artworkUrl100"];
            NSURL *imgUrl = [NSURL URLWithString:imgUrlString];
            NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
            dispatch_async(dispatch_get_main_queue(), ^{
                customCell.artworkImageView.image = [UIImage imageWithData:imgData];
            });
        });
    } else {
        customCell.artworkImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]];
    }
    
    customCell.longDescription.numberOfLines = 2;
    customCell.readMoreButton.hidden = NO;
    
    customCell.collectButton.selected = [self.collectionManager isCollectedTrackId:[self.collectionListArray[indexPath.row] objectForKey:@"trackId"] andType:[self getMediaType]];
    
    return customCell;

}

#pragma mark - CustomCellDelegate

- (void)didClickReadMoreInCell:(CustomTableViewCell *)cell {
    cell.longDescription.numberOfLines = 0;
    cell.readMoreButton.hidden = YES;
    [self.collectionListTableView beginUpdates];
    [self.collectionListTableView endUpdates];
}

- (void)didCollectItemInCell:(CustomTableViewCell *)cell {
    NSIndexPath *indexPath = [self.collectionListTableView indexPathForCell:cell];
    NSString *mediaType = [self getMediaType];
    
    if (!cell.collectButton.isSelected) {
        // 收藏
        [self.collectionManager storeCollectionWithInfo:self.collectionListArray[indexPath.row] andType:mediaType];
    } else {
        // 取消收藏
        [self.collectionManager deleteCollectionWithTrackId:[self.collectionListArray[indexPath.row] objectForKey:@"trackId"] andType:mediaType];
    }
    cell.collectButton.selected = !cell.collectButton.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOULD_RELOAD" object:nil];
}

#pragma mark - NSNotificationCenter
- (void)shouldReload {
    self.collectionListArray = [[NSMutableArray alloc] initWithArray:[self.collectionManager getCollectionWithType:[self getMediaType]]];
    [self.collectionListTableView reloadData];
}

- (NSString *)getMediaType {
    switch (self.displayMediaType) {
        case Movie:
            return @"movie";
            break;
            
        case Music:
            return @"music";
            break;
            
        default:
            return @"";
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
