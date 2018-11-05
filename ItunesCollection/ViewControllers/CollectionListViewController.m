//
//  CollectionListViewController.m
//  ItunesCollection
//
//  Created by lautmn on 2018/11/2.
//  Copyright © 2018年 lautmn. All rights reserved.
//

#import "CollectionListViewController.h"
#import "CollectionListContentViewController.h"

@interface CollectionListViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentControl;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

@implementation CollectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageViewController = self.childViewControllers[0];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    [self.pageViewController setViewControllers:@[[self viewControllerWithMediaType:Movie]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

#pragma mark - IBAction

- (IBAction)didChangeSegment:(UISegmentedControl *)sender {
    MediaType mediaType = sender.selectedSegmentIndex == 0 ? Movie : Music;
    [self.pageViewController setViewControllers:@[[self viewControllerWithMediaType:mediaType]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger displayMediaType = ((CollectionListContentViewController *)viewController).displayMediaType;
    if (displayMediaType == Movie) {
        return nil;
    }
    return [self viewControllerWithMediaType:Movie];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger displayMediaType = ((CollectionListContentViewController *)viewController).displayMediaType;
    if (displayMediaType == Music) {
        return nil;
    }
    return [self viewControllerWithMediaType:Music];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    NSUInteger displayMediaType = ((CollectionListContentViewController *)pageViewController.viewControllers[0]).displayMediaType;
    self.typeSegmentControl.selectedSegmentIndex = displayMediaType == Movie ? 0 : 1;
}


#pragma mark - Private Methods
- (CollectionListContentViewController *)viewControllerWithMediaType:(MediaType)mediaType {
    CollectionListContentViewController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CollectionListContentViewController"];
    contentViewController.displayMediaType = mediaType;
    return contentViewController;
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
