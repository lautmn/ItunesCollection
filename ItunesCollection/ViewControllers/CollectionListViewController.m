//
//  CollectionListViewController.m
//  ItunesCollection
//
//  Created by lautmn on 2018/11/2.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "CollectionListViewController.h"
#import "MusicTableViewCell.h"
#import "MovieTableViewCell.h"
#import "MediaCollectionManager.h"

@interface CollectionListViewController () <UITableViewDataSource, UITableViewDelegate, MovieCellDelegate, MusicCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *musicCollectionListTableView;
@property (weak, nonatomic) IBOutlet UITableView *movieCollectionListTableView;

@property (strong, nonatomic) NSMutableArray *collectionListArray;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegementControl;



@end

@implementation CollectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MediaCollectionManager *collectionManager = [MediaCollectionManager shareInstance];
    [self.musicCollectionListTableView registerNib:[UINib nibWithNibName:@"MusicTableViewCell" bundle:nil] forCellReuseIdentifier:@"MusicTableViewCell"];
    [self.movieCollectionListTableView registerNib:[UINib nibWithNibName:@"MovieTableViewCell" bundle:nil] forCellReuseIdentifier:@"MovieTableViewCell"];
    self.collectionListArray = [[NSMutableArray alloc] initWithArray:[collectionManager getCollectionWithType:@"movie"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldReload) name:@"SHOULD_RELOAD" object:nil];
}

- (IBAction)didChangeSegemey:(UISegmentedControl *)sender {
    
    
    MediaCollectionManager *collectionManager = [MediaCollectionManager shareInstance];
    [self.musicCollectionListTableView setContentOffset:CGPointZero animated:NO];
    if (sender.selectedSegmentIndex == 0) {
        self.collectionListArray = [[NSMutableArray alloc] initWithArray:[collectionManager getCollectionWithType:@"movie"]];
    } else {
        self.collectionListArray = [[NSMutableArray alloc] initWithArray:[collectionManager getCollectionWithType:@"music"]];
    }
    [self.musicCollectionListTableView reloadData];
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
    MediaCollectionManager *collectionManager = [MediaCollectionManager shareInstance];
    
    if (self.typeSegementControl.selectedSegmentIndex == 0) {
        static NSString *movieCellIdentifier = @"MovieTableViewCell";
        MovieTableViewCell *movieCell = [tableView dequeueReusableCellWithIdentifier:movieCellIdentifier];
        movieCell.delegate = self;
        movieCell.trackName.text = [self.collectionListArray[indexPath.row] objectForKey:@"trackName"];
        movieCell.artistName.text = [self.collectionListArray[indexPath.row] objectForKey:@"artistName"];
        movieCell.collectionName.text = [self.collectionListArray[indexPath.row] objectForKey:@"collectionName"];
        movieCell.trackTime.text = [NSString stringWithFormat:@"%@", [self.collectionListArray[indexPath.row] objectForKey:@"trackTimeMillis"]];
        movieCell.longDescription.text = [self.collectionListArray[indexPath.row] objectForKey:@"longDescription"];
        
        NSString *imgName = [NSString stringWithFormat:@"img_%@.png", [self.collectionListArray[indexPath.row] objectForKey:@"trackId"]];
        NSString *imgPath = [cachesPath stringByAppendingPathComponent:imgName];
        movieCell.artworkImageView.image = [UIImage imageNamed:@"Black.png"];
        if (![NSData dataWithContentsOfFile:imgPath]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *imgUrlString = [self.collectionListArray[indexPath.row] objectForKey:@"artworkUrl100"];
                NSURL *imgUrl = [NSURL URLWithString:imgUrlString];
                NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
                dispatch_async(dispatch_get_main_queue(), ^{
                    movieCell.artworkImageView.image = [UIImage imageWithData:imgData];
                });
            });
        } else {
            movieCell.artworkImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]];
        }
        
        movieCell.longDescription.numberOfLines = 2;
        movieCell.readMoreButton.hidden = NO;
        
        movieCell.collectMovieButton.selected = [collectionManager isCollectedTrackId:[self.collectionListArray[indexPath.row] objectForKey:@"trackId"] andType:@"movie"];
        
        return movieCell;
    } else {
        static NSString *musicCellIdentifier = @"MusicTableViewCell";
        MusicTableViewCell *musicCell = [tableView dequeueReusableCellWithIdentifier:musicCellIdentifier];
        musicCell.delegate = self;
        musicCell.trackName.text = [self.collectionListArray[indexPath.row] objectForKey:@"trackName"];
        musicCell.artistName.text = [self.collectionListArray[indexPath.row] objectForKey:@"artistName"];
        musicCell.collectionName.text = [self.collectionListArray[indexPath.row] objectForKey:@"collectionName"];
        musicCell.trackTime.text = [NSString stringWithFormat:@"%@", [self.collectionListArray[indexPath.row] objectForKey:@"trackTimeMillis"]];
        
        NSString *imgName = [NSString stringWithFormat:@"img_%@.png", [self.collectionListArray[indexPath.row] objectForKey:@"trackId"]];
        NSString *imgPath = [cachesPath stringByAppendingPathComponent:imgName];
        musicCell.artworkImageView.image = [UIImage imageNamed:@"Black.png"];
        if (![NSData dataWithContentsOfFile:imgPath]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *imgUrlString = [self.collectionListArray[indexPath.row] objectForKey:@"artworkUrl100"];
                NSURL *imgUrl = [NSURL URLWithString:imgUrlString];
                NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
                dispatch_async(dispatch_get_main_queue(), ^{
                    musicCell.artworkImageView.image = [UIImage imageWithData:imgData];
                });
            });
        } else {
            musicCell.artworkImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]];
        }
        
        musicCell.collectMusicButton.selected = [collectionManager isCollectedTrackId:[self.collectionListArray[indexPath.row] objectForKey:@"trackId"] andType:@"music"];
        
        return musicCell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *itunesUrlString = [self.collectionListArray[indexPath.row] objectForKey:@"trackViewUrl"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesUrlString] options:@{} completionHandler:nil];
}

#pragma mark - MovieCellDelegate

- (void)didClickReadMoreInCell:(MovieTableViewCell *)cell {
    cell.longDescription.numberOfLines = 0;
    cell.readMoreButton.hidden = YES;
    [self.musicCollectionListTableView beginUpdates];
    [self.musicCollectionListTableView endUpdates];
}

- (void)didCollectMovieInCell:(MovieTableViewCell *)cell {
    MediaCollectionManager *collectionManager = [MediaCollectionManager shareInstance];
    NSIndexPath *indexPath = [self.musicCollectionListTableView indexPathForCell:cell];
    if (!cell.collectMovieButton.isSelected) {
        // 收藏
        [collectionManager storeCollectionWithInfo:self.collectionListArray[indexPath.row] andType:@"movie"];
    } else {
        // 取消收藏
        [collectionManager deleteCollectionWithTrackId:[self.collectionListArray[indexPath.row] objectForKey:@"trackId"] andType:@"movie"];
    }
    cell.collectMovieButton.selected = !cell.collectMovieButton.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOULD_RELOAD" object:nil];
}

#pragma mark - MusicCellDelegate

- (void)didCollectMusicInCell:(MusicTableViewCell *)cell {
    MediaCollectionManager *collectionManager = [MediaCollectionManager shareInstance];
    NSIndexPath *indexPath = [self.musicCollectionListTableView indexPathForCell:cell];
    if (!cell.collectMusicButton.isSelected) {
        // 收藏
        [collectionManager storeCollectionWithInfo:self.collectionListArray[indexPath.row] andType:@"music"];
    } else {
        // 取消收藏
        [collectionManager deleteCollectionWithTrackId:[self.collectionListArray[indexPath.row] objectForKey:@"trackId"] andType:@"music"];
    }
    cell.collectMusicButton.selected = !cell.collectMusicButton.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOULD_RELOAD" object:nil];
}

#pragma mark - NSNotificationCenter
- (void)shouldReload {
    MediaCollectionManager *collectionManager = [MediaCollectionManager shareInstance];
    if (self.typeSegementControl.selectedSegmentIndex == 0) {
        self.collectionListArray = [[NSMutableArray alloc] initWithArray:[collectionManager getCollectionWithType:@"movie"]];
    } else {
        self.collectionListArray = [[NSMutableArray alloc] initWithArray:[collectionManager getCollectionWithType:@"music"]];
    }
    [self.musicCollectionListTableView reloadData];
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
