//
//  SearchViewController.m
//  ItunesCollection
//
//  Created by lautmn on 2018/10/30.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "SearchViewController.h"
#import "ItunesApiConnector.h"
#import "MusicTableViewCell.h"
#import "MovieTableViewCell.h"
#import "MediaCollectionManager.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, MovieCellDelegate, MusicCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@property (weak, nonatomic) IBOutlet UITextField *keywordTextField;

@property (strong, nonatomic) NSMutableArray *musicArray;
@property (strong, nonatomic) NSMutableArray *movieArray;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.musicArray = [[NSMutableArray alloc] init];
    self.movieArray = [[NSMutableArray alloc] init];
    [self.resultTableView registerNib:[UINib nibWithNibName:@"MusicTableViewCell" bundle:nil] forCellReuseIdentifier:@"MusicTableViewCell"];
    [self.resultTableView registerNib:[UINib nibWithNibName:@"MovieTableViewCell" bundle:nil] forCellReuseIdentifier:@"MovieTableViewCell"];
}

- (IBAction)searchButtonClicked:(id)sender {
    [self.movieArray removeAllObjects];
    [self.musicArray removeAllObjects];
//    [self.resultTableView reloadData];
    
    ItunesApiConnector *connector = [ItunesApiConnector shareInstance];
    [connector searchItunesMusicWithKeyword:self.keywordTextField.text completion:^(id result, NSError *error) {
        if (result) {
            NSLog(@"success");
            self.musicArray = [[NSMutableArray alloc] initWithArray:[result objectForKey:@"results"]];
            [self.resultTableView reloadData];
        } else {
            NSLog(@"fail");
        }
    }];
    [connector searchItunesMovieWithKeyword:self.keywordTextField.text completion:^(id result, NSError *error) {
        if (result) {
            NSLog(@"success");
            self.movieArray = [[NSMutableArray alloc] initWithArray:[result objectForKey:@"results"]];
            [self.resultTableView reloadData];
        } else {
            NSLog(@"fail");
        }
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionCount = 0;
    sectionCount = self.movieArray.count > 0 ? sectionCount + 1 : sectionCount;
    sectionCount = self.musicArray.count > 0 ? sectionCount + 1 : sectionCount;
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.movieArray.count > 0 ? self.movieArray.count : self.musicArray.count;
            break;
            
        case 1:
            return self.musicArray.count;
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.movieArray.count > 0 ? @"電影" : @"音樂";
            break;

        case 1:
            return @"音樂";
            break;
            
        default:
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.movieArray.count > 0) {
        static NSString *movieCellIdentifier = @"MovieTableViewCell";
        MovieTableViewCell *movieCell = [tableView dequeueReusableCellWithIdentifier:movieCellIdentifier];
        movieCell.delegate = self;
        movieCell.trackName.text = [self.movieArray[indexPath.row] objectForKey:@"trackName"];
        movieCell.artistName.text = [self.movieArray[indexPath.row] objectForKey:@"artistName"];
        movieCell.collectionName.text = [self.movieArray[indexPath.row] objectForKey:@"collectionName"];
        movieCell.trackTime.text = [NSString stringWithFormat:@"%@", [self.movieArray[indexPath.row] objectForKey:@"trackTimeMillis"]];
        movieCell.longDescription.text = [self.movieArray[indexPath.row] objectForKey:@"longDescription"];
        movieCell.longDescription.numberOfLines = 2;
        movieCell.readMoreButton.hidden = NO;
        return movieCell;
    } else {
        static NSString *musicCellIdentifier = @"MusicTableViewCell";
        MusicTableViewCell *musicCell = [tableView dequeueReusableCellWithIdentifier:musicCellIdentifier];
        musicCell.delegate = self;
        musicCell.trackName.text = [self.musicArray[indexPath.row] objectForKey:@"trackName"];
        musicCell.artistName.text = [self.musicArray[indexPath.row] objectForKey:@"artistName"];
        musicCell.collectionName.text = [self.musicArray[indexPath.row] objectForKey:@"collectionName"];
        musicCell.trackTime.text = [NSString stringWithFormat:@"%@", [self.musicArray[indexPath.row] objectForKey:@"trackTimeMillis"]];
        return musicCell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicTableViewCell *musicCell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@", musicCell);
    
    musicCell.trackTime.numberOfLines = 0;
    [musicCell.trackTime sizeToFit];

    [tableView beginUpdates];
    [tableView endUpdates];
}

#pragma mark - MovieCellDelegate

- (void)didClickReadMoreInCell:(MovieTableViewCell *)cell {
    cell.longDescription.numberOfLines = 0;
    cell.readMoreButton.hidden = YES;
    [self.resultTableView beginUpdates];
    [self.resultTableView endUpdates];
}

- (void)didCollectMovieInCell:(MovieTableViewCell *)cell {
    NSLog(@"%@", cell);
//    MediaCollectionManager *collectionManager = [MediaCollectionManager shareInstance];
    cell.collectMovieButton.selected = !cell.collectMovieButton.selected;
    [self.resultTableView beginUpdates];
    [self.resultTableView endUpdates];
    
}

- (void)didCollectMusicInCell:(MusicTableViewCell *)cell {
    NSLog(@"MUSIC:%@", cell);
    cell.collectMusicButton.selected = !cell.collectMusicButton.selected;
    [self.resultTableView beginUpdates];
    [self.resultTableView endUpdates];
    
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