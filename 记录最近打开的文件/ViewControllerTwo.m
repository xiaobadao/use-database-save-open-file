//
//  ViewControllerTwo.m
//  记录最近打开的文件
//
//  Created by apple on 2017/2/16.
//  Copyright © 2017年 Chuckie. All rights reserved.
//

#import "ViewControllerTwo.h"
#import "OpenFileDao.h"
#import "ReadViewController.h"

@interface ViewControllerTwo ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *dataSource;
@end

@implementation ViewControllerTwo

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableViewTwo.delegate = self;
    self.tableViewTwo.dataSource = self;
    self.tableViewTwo.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.dataSource = [[OpenFileDao getInstance] selectAll];
    [self.tableViewTwo reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTwo"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellTwo"];
    }
    cell.textLabel.text = ((OpenFileBean *)self.dataSource[indexPath.row]).fileName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__func__);
}

@end
