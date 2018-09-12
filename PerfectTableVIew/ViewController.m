//
//  ViewController.m
//  PerfectTableVIew
//
//  Created by Yang,Dongzheng on 2018/9/12.
//  Copyright © 2018年 Yang,Dongzheng. All rights reserved.
//

#import "ViewController.h"
#import "ListDataCell.h"

@implementation ContainerTableView

/**
 同时识别多个手势
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) ContainerTableView *contentScrollView;
@property (nonatomic, strong) UITableViewCell *header;
@property (nonatomic, strong) UILabel *titleBar;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) ListDataCell *contentCell;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"嵌套Tableview";
    self.canScroll = YES;
    
    [self.view addSubview:self.contentScrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat bottomCellOffset = [_contentScrollView rectForSection:1].origin.y;
    if (scrollView.contentOffset.y > bottomCellOffset) {
        scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        if (self.canScroll) {
            self.canScroll = NO;
            self.contentCell.cellCanScroll = YES;
        }
    }else{
        if (!self.canScroll) {//子视图到顶部
            scrollView.contentOffset = CGPointMake(0.f, bottomCellOffset);
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100.f;
    }
    return CGRectGetHeight(self.view.bounds);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 44.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.titleBar;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ListDataCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"ListDataCell" forIndexPath:indexPath];
        self.contentCell = listCell;
        __weak typeof(self) weakself = self;
        self.contentCell.enableScrollCallback = ^{
            [weakself changeScrollStatus];
        };
        return listCell;
    }
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"header" forIndexPath:indexPath];
        cell.textLabel.text = @"头部";
        cell.backgroundColor = [UIColor redColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.header = cell;
        return cell;
    }
    return nil;
}

//改变主视图的状态
- (void)changeScrollStatus {
    self.canScroll = YES;
    self.contentCell.cellCanScroll = NO;
}

- (UILabel *)titleBar {
    if (_titleBar == nil) {
        CGRect frame = CGRectMake(0, 0.f, CGRectGetWidth(self.view.bounds), 44.f);
        _titleBar = [[UILabel alloc] initWithFrame:frame];
        _titleBar.text = @"悬停的Bar";
        _titleBar.textAlignment = NSTextAlignmentCenter;
        _titleBar.backgroundColor = [UIColor orangeColor];
    }
    return _titleBar;
}

- (ContainerTableView *)contentScrollView {
    if (_contentScrollView == nil) {
        CGRect frame =CGRectMake(0.f, 0.f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        _contentScrollView = [[ContainerTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        [_contentScrollView registerClass:[ListDataCell class] forCellReuseIdentifier:@"ListDataCell"];
        [_contentScrollView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"header"];
        _contentScrollView.delegate = self;
        _contentScrollView.dataSource = self;
        _contentScrollView.bounces = NO;
        _contentScrollView.scrollsToTop = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
    }
    return _contentScrollView;
}

@end
