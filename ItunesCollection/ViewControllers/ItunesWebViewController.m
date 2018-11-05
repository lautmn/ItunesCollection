//
//  ItunesWebViewController.m
//  ItunesCollection
//
//  Created by lautmn on 2018/11/5.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "ItunesWebViewController.h"
#import <WebKit/WebKit.h>

@interface ItunesWebViewController () <UIScrollViewDelegate> {
    CGFloat latestY;
}
@property (weak, nonatomic) IBOutlet WKWebView *itunesWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *XbuttonHeight;

@end

@implementation ItunesWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:@"https://support.apple.com/itunes"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.itunesWebView loadRequest:request];
    self.itunesWebView.scrollView.delegate = self;
}

- (IBAction)XbuttonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (latestY < scrollView.contentOffset.y && scrollView.contentOffset.y > 0){
        [UIView animateWithDuration:0.2 animations:^{
            self.XbuttonHeight.constant = 0;
            [self.view layoutIfNeeded];
        }];
    } else if (latestY > scrollView.contentOffset.y && scrollView.contentOffset.y < scrollView.contentSize.height - scrollView.frame.size.height) {
        [UIView animateWithDuration:0.2 animations:^{
            self.XbuttonHeight.constant = 48;
            [self.view layoutIfNeeded];
        }];
    }
    latestY = scrollView.contentOffset.y;
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
