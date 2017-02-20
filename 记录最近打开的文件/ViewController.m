//
//  ViewController.m
//  记录最近打开的文件
//
//  Created by apple on 2017/2/16.
//  Copyright © 2017年 Chuckie. All rights reserved.
//

#import "ViewController.h"
#import "ReadViewController.h"
#import "OpenFileDao.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation ViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewOne.delegate = self;
    self.tableViewOne.dataSource = self;
    self.tableViewOne.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSString *onePath = [[NSBundle mainBundle] pathForResource:@"Functional Specification for CAM iPoS -Supplement v0.3" ofType:@"doc"];
//    NSURL *onePath = [[NSBundle mainBundle] URLForResource:@"Functional Specification for CAM iPoS -Supplement v0.3" withExtension:@"doc"];
    NSString *twoPath = [[NSBundle mainBundle] pathForResource:@"Functional Specification_PAL_Wrapper_V1.1" ofType:@"docx"];
    NSString *threePath = [[NSBundle mainBundle] pathForResource:@"Functional Specification for CAM iPoS v0.9" ofType:@"doc"];
    
    NSData *oneData = [NSData dataWithContentsOfFile:onePath];
    NSData *twoData = [NSData dataWithContentsOfFile:twoPath];
    NSData *threeData = [NSData dataWithContentsOfFile:threePath];
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];

    [dict1 setObject:@"Functional Specification for CAM iPoS -Supplement v0.3" forKey:@"fileName"];
    NSString *str1 = [[NSString alloc] initWithData:oneData encoding:NSUTF8StringEncoding];
    NSString *str2 = [[NSString alloc] initWithData:twoData encoding:NSUTF8StringEncoding];
    NSString *str3 = [[NSString alloc] initWithData:threeData encoding:NSUTF8StringEncoding];
    
    [dict1 setObject:FORMAT(@"%@",str1) forKey:@"fileData"];
    
    [dict2 setObject:@"Functional Specification_PAL_Wrapper_V1.1" forKey:@"fileName"];
    [dict2 setObject:FORMAT(@"%@",str2) forKey:@"fileData"];
    
    [dict3 setObject:@"Functional Specification for CAM iPoS v0.9" forKey:@"fileName"];
    [dict3 setObject:FORMAT(@"%@",str3) forKey:@"fileData"];
    
    [self.dataSource addObject:dict1];
    [self.dataSource addObject:dict2];
    [self.dataSource addObject:dict3];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellOne"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellOne"];
    }
    NSString *title = ((NSDictionary *)self.dataSource[indexPath.row])[@"fileName"];
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = ((NSDictionary *)self.dataSource[indexPath.row])[@"fileName"];
    ReadViewController *vc = [[ReadViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    OpenFileBean *openBean = [[OpenFileDao getInstance] queryReadFileBeanWith:title];
    if (!openBean) {
        openBean = [OpenFileBean createBean];
        openBean.fileName = title;
        [openBean save];
    }
    [self presentViewController:nvc animated:YES completion:nil];
    
    NSLog(@"%s",__func__);
}


@end
