//
//  SelectThemeViewController.m
//  ItunesCollection
//
//  Created by lautmn on 2018/11/5.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "SelectThemeViewController.h"
#import "ThemeTableViewCell.h"
#import "ThemeManager.h"

@interface SelectThemeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *themeTableView;
@property (strong, nonatomic) ThemeManager *themeManager;

@end

@implementation SelectThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.themeManager = [ThemeManager shareInstance];
    [self.themeTableView registerNib:[UINib nibWithNibName:@"ThemeTableViewCell" bundle:nil] forCellReuseIdentifier:@"ThemeTableViewCell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.themeManager getThemeList].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ThemeTableViewCell";

    ThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.themeNameLabel.text = [self.themeManager getThemeList][indexPath.row];

    cell.checkImageView.hidden = [cell.themeNameLabel.text isEqualToString:[self.themeManager getCurrentThemeName]] ? NO : YES;

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![[self.themeManager getCurrentThemeName] isEqualToString:[self.themeManager getThemeList][indexPath.row]]) {
        [self.themeManager changeThemeColorWithName:[self.themeManager getThemeList][indexPath.row]];
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
