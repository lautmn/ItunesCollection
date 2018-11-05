//
//  SearchViewController.m
//  ItunesCollection
//
//  Created by lautmn on 2018/10/30.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "SearchViewController.h"
#import "ItunesApiConnector.h"
#import "CustomTableViewCell.h"
#import "MediaCollectionManager.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, CustomCellDelegate, UITextFieldDelegate> {
    BOOL didFinishSearchMovie;
    BOOL didFinishSearchMusic;
}
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@property (weak, nonatomic) IBOutlet UITextField *keywordTextField;

@property (strong, nonatomic) NSMutableArray *musicArray;
@property (strong, nonatomic) NSMutableArray *movieArray;

@property (strong, nonatomic) MediaCollectionManager *collectionManager;

//@property (assign, nonatomic) BOOL didFinishSearchMovie;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionManager = [MediaCollectionManager shareInstance];
    self.musicArray = [[NSMutableArray alloc] init];
    self.movieArray = [[NSMutableArray alloc] init];
    [self.resultTableView registerNib:[UINib nibWithNibName:@"MusicTableViewCell" bundle:nil] forCellReuseIdentifier:@"MusicTableViewCell"];
    [self.resultTableView registerNib:[UINib nibWithNibName:@"MovieTableViewCell" bundle:nil] forCellReuseIdentifier:@"MovieTableViewCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldReload) name:@"SHOULD_RELOAD" object:nil];
}

- (IBAction)searchButtonClicked:(id)sender {
    [self.resultTableView setContentOffset:CGPointZero animated:NO];
    [self.keywordTextField resignFirstResponder];
    
    ItunesApiConnector *connector = [ItunesApiConnector shareInstance];
    [self.movieArray removeAllObjects];
    [self.musicArray removeAllObjects];
    [self.resultTableView reloadData];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"搜尋中" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    
    [connector searchItunesMovieWithKeyword:self.keywordTextField.text completion:^(id result, NSError *error) {
        self->didFinishSearchMovie = YES;
        if (result) {
            self.movieArray = [[NSMutableArray alloc] initWithArray:[result objectForKey:@"results"]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self.movieArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
                    NSString *imgName = [NSString stringWithFormat:@"img_%@.png", [obj objectForKey:@"trackId"]];
                    NSString *imgPath = [cachesPath stringByAppendingPathComponent:imgName];

                    NSString *imgUrlString = [obj objectForKey:@"artworkUrl100"];
                    NSURL *imgUrl = [NSURL URLWithString:imgUrlString];
                    NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
                    [imgData writeToFile:imgPath atomically:YES];
                }];;
            });
//            [self.resultTableView reloadData];
            [self checkShouldReloadTableView];
        } else {
            
        }
    }];
    
    [connector searchItunesMusicWithKeyword:self.keywordTextField.text completion:^(id result, NSError *error) {
        self->didFinishSearchMusic = YES;
        if (result) {
            self.musicArray = [[NSMutableArray alloc] initWithArray:[result objectForKey:@"results"]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self.musicArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
                    NSString *imgName = [NSString stringWithFormat:@"img_%@.png", [obj objectForKey:@"trackId"]];
                    NSString *imgPath = [cachesPath stringByAppendingPathComponent:imgName];

                    NSString *imgUrlString = [obj objectForKey:@"artworkUrl100"];
                    NSURL *imgUrl = [NSURL URLWithString:imgUrlString];
                    NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
                    [imgData writeToFile:imgPath atomically:YES];
                }];;
            });
//            [self.resultTableView reloadData];
            [self checkShouldReloadTableView];
        } else {
            
        }
    }];
}

- (void)checkShouldReloadTableView {
    if (didFinishSearchMusic && didFinishSearchMovie) {
        [self dismissViewControllerAnimated:YES completion:nil];
        didFinishSearchMusic = NO;
        didFinishSearchMovie = NO;
        [self.resultTableView reloadData];
    }
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
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *cellIdentifier;
    NSArray *sourceArray;
    NSString *mediaType;
    if (indexPath.section == 0 && self.movieArray.count > 0) {
        cellIdentifier = @"MovieTableViewCell";
        sourceArray = self.movieArray;
        mediaType = @"movie";
    } else {
        cellIdentifier = @"MusicTableViewCell";
        sourceArray = self.musicArray;
        mediaType = @"music";
    }
    CustomTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    customCell.delegate = self;
    customCell.trackName.text = [sourceArray[indexPath.row] objectForKey:@"trackName"];
    customCell.artistName.text = [sourceArray[indexPath.row] objectForKey:@"artistName"];
    customCell.collectionName.text = [sourceArray[indexPath.row] objectForKey:@"collectionName"];
    customCell.trackTime.text = [NSString stringWithFormat:@"%@", [sourceArray[indexPath.row] objectForKey:@"trackTimeMillis"]];
    customCell.longDescription.text = [sourceArray[indexPath.row] objectForKey:@"longDescription"];
    
    NSString *imgName = [NSString stringWithFormat:@"img_%@.png", [sourceArray[indexPath.row] objectForKey:@"trackId"]];
    NSString *imgPath = [cachesPath stringByAppendingPathComponent:imgName];
    customCell.artworkImageView.image = [UIImage imageNamed:@"Black.png"];
    if (![NSData dataWithContentsOfFile:imgPath]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *imgUrlString = [self.movieArray[indexPath.row] objectForKey:@"artworkUrl100"];
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
    
    customCell.collectButton.selected = [self.collectionManager isCollectedTrackId:[sourceArray[indexPath.row] objectForKey:@"trackId"] andType:mediaType];
    
    return customCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *musicCell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@", musicCell);
    
    musicCell.trackTime.numberOfLines = 0;
    [musicCell.trackTime sizeToFit];

    [tableView beginUpdates];
    [tableView endUpdates];
}

#pragma mark - CustomCellDelegate

- (void)didClickReadMoreInCell:(CustomTableViewCell *)cell {
    cell.longDescription.numberOfLines = 0;
    cell.readMoreButton.hidden = YES;
    [self.resultTableView beginUpdates];
    [self.resultTableView endUpdates];
}

- (void)didCollectItemInCell:(CustomTableViewCell *)cell {
    NSIndexPath *indexPath = [self.resultTableView indexPathForCell:cell];
    NSArray *sourceArray;
    NSString *mediaType;
    if (indexPath.section == 0 && self.movieArray.count > 0) {
        sourceArray = self.movieArray;
        mediaType = @"movie";
    } else {
        sourceArray = self.musicArray;
        mediaType = @"music";
    }
    
    if (!cell.collectButton.isSelected) {
        // 收藏
        [self.collectionManager storeCollectionWithInfo:sourceArray[indexPath.row] andType:mediaType];
    } else {
        // 取消收藏
        [self.collectionManager deleteCollectionWithTrackId:[sourceArray[indexPath.row] objectForKey:@"trackId"] andType:mediaType];
    }
    cell.collectButton.selected = !cell.collectButton.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOULD_RELOAD" object:nil];
}

#pragma mark - UItextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - NSNotificationCenter
- (void)shouldReload {
    if (self.isViewLoaded && self.view.window) {
        [self.resultTableView beginUpdates];
        [self.resultTableView endUpdates];
    } else {
        [self.resultTableView reloadData];
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
