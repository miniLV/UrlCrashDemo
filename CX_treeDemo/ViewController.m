//
//  ViewController.m
//  CityTest
//
//  Created by Felix on 2017/9/20.
//  Copyright © 2017年 Felix. All rights reserved.
//

#import "ViewController.h"
#import "YHAFNHelper.h"
#import "CommonModel.h"
#import <YYModel.h>
#import "BMChineseSort.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *totalArray;
@property (nonatomic, strong) NSMutableArray *selectIDArray;

@end

static NSString *cellID = @"cellID";
@implementation ViewController

- (NSMutableArray *)selectIDArray {
    if (!_selectIDArray) {
        _selectIDArray = @[].mutableCopy;
    }
    return _selectIDArray;
}

- (NSMutableArray *)totalArray {
    if (!_totalArray) {
        _totalArray = @[].mutableCopy;
    }
    return _totalArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadProvinceData];
    [self setupUI];
}

- (void)loadProvinceData {
    //1.调用接口 - 获取数据
    NSString *urlString = @"https://testapi.henzfin.com/areas/0";
    
    [YHAFNHelper get:urlString parameter:nil success:^(id responseObject) {
        NSArray *array = [NSArray yy_modelArrayWithClass:[CommonModel class] json:responseObject].mutableCopy;
        self.totalArray = [BMChineseSort sortObjectArray:array Key:@"letterName"];
        [self.tableView reloadData];
    } faliure:^(id error) {
        
        NSLog(@"error - %@",error);
    }];
}


- (void)setupUI {
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.totalArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *provincesArray = self.totalArray[section];
    return provincesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [UITableViewCell new];
    }
    NSArray *provincesArray = self.totalArray[indexPath.section];
    CommonModel *model = provincesArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@", model.full_name,model.ID];
    // cell有缩进的方法
    cell.indentationLevel = [model.depth integerValue] - 1; // 缩进级别
    cell.indentationWidth = 30.f; // 每个缩进级别的距离
    return cell;
}

//headerView的样式
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *provincesArray = self.totalArray[section];
    CommonModel *model = provincesArray[0];
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor lightGrayColor];
    label.text = model.letterName;
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *provincesArray = self.totalArray[indexPath.section];
    CommonModel *provinceModel = provincesArray[indexPath.row];
    
    NSLog(@"provincesArray == %@",provincesArray);
    
    NSLog(@"provinceModel = %@",provinceModel);
    
    //发送HTTP请求 - 请求数据
    NSString *BaseurlString = @"https://testapi.henzfin.com/areas/";
    NSString *objID = provinceModel.ID;
    NSString *getUrlString = [BaseurlString stringByAppendingString:[NSString stringWithFormat:@"%@",objID]];
    
    
    [YHAFNHelper get:getUrlString parameter:nil success:^(id responseObject) {
        NSArray *citysArray = [NSArray yy_modelArrayWithClass:[CommonModel class] json:responseObject];
        
        if ([self.selectIDArray containsObject:provinceModel]) {
            // 缩回
            [self.selectIDArray removeObject:provinceModel];
            NSUInteger startPosition = indexPath.row + 1;
            NSUInteger endPosition = indexPath.row + citysArray.count;
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, citysArray.count)];

            [provincesArray removeObjectsAtIndexes:indexSet];
            
            
            NSLog(@"startPosition = %lu,endPosition = %lu",(unsigned long)startPosition,(unsigned long)endPosition);
            
            NSLog(@"选中了 - 当前的省or市！");
            
            //获得需要修正的indexPath
            NSMutableArray *indexPathArray = [NSMutableArray array];
            
            for (NSUInteger i = startPosition; i <= endPosition; i++) {
                NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                [indexPathArray addObject:tempIndexPath];
//                NSLog(@"tempIndexPath = %@", tempIndexPath);
            }

            [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            
            
        }else {
            // 展开
            [self.selectIDArray addObject:provinceModel];
            NSUInteger startPosition = indexPath.row + 1;
            NSUInteger endPosition = indexPath.row + citysArray.count;
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, citysArray.count)];
            
            [provincesArray insertObjects:citysArray atIndexes:indexSet];
            //获得需要修正的indexPath
            NSMutableArray *indexPathArray = [NSMutableArray array];
            
            for (NSUInteger i = startPosition; i <= endPosition; i++) {
                NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                [indexPathArray addObject:tempIndexPath];
                NSLog(@"tempIndexPath = %@", tempIndexPath);
            }
            [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        }
        
    } faliure:^(id error) {
        NSLog(@"error - %@",error);
    }];
}


@end
