//
//  SelectThemeViewController.m
//  ItunesCollection
//
//  Created by lautmn on 2018/11/5.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "SelectThemeViewController.h"
#import "MediaCollectionManager.h"
#import "ThemeTableViewCell.h"

@interface SelectThemeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *themeTableView;
@property (strong, nonatomic) MediaCollectionManager *collectionManager;

@end

@implementation SelectThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionManager = [MediaCollectionManager shareInstance];
    [self.themeTableView registerNib:[UINib nibWithNibName:@"ThemeTableViewCell" bundle:nil] forCellReuseIdentifier:@"ThemeTableViewCell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.collectionManager getThemeList].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ThemeTableViewCell";

    ThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.themeNameLabel.text = [self.collectionManager getThemeList][indexPath.row];

    cell.checkImageView.hidden = [cell.themeNameLabel.text isEqualToString:[self.collectionManager getCurrentThemeName]] ? NO : YES;

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![[self.collectionManager getCurrentThemeName] isEqualToString:[self.collectionManager getThemeList][indexPath.row]]) {
        [self.collectionManager changeThemeColorWithName:[self.collectionManager getThemeList][indexPath.row]];
        [self.themeTableView reloadData];
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
