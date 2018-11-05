//
//  ProfileViewController.m
//  ItunesCollection
//
//  Created by lautmn on 2018/10/30.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "ProfileViewController.h"
#import "MediaCollectionManager.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *themeColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionAmountLabel;
@property (strong, nonatomic) MediaCollectionManager *collectionManager;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionManager = [MediaCollectionManager shareInstance];
    self.collectionAmountLabel.text = [NSString stringWithFormat:@"共有 %li 項收藏", [self.collectionManager getCollectionAmount]];
    self.themeColorLabel.text = [self.collectionManager getCurrentThemeName];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldReload) name:@"SHOULD_RELOAD" object:nil];
}

#pragma mark - IBAction
- (IBAction)aboutItunesButtonClick:(id)sender {
    
}

#pragma mark - NSNotificationCenter
- (void)shouldReload {
    self.collectionAmountLabel.text = [NSString stringWithFormat:@"共有 %li 項收藏", [self.collectionManager getCollectionAmount]];
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
