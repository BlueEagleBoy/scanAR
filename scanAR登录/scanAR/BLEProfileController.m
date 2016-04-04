//
//  BLEProfileController.m
//  LoginPage
//
//  Created by BlueEagleBoy on 16/3/7.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLEProfileController.h"
#import "BLEPhotosController.h"
#define BLECellId @"cell_id"

@interface BLEProfileController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSArray *dataArray;

@end

@implementation BLEProfileController

//加载profile.plist文件中的数据
- (NSArray *)dataArray {
    
    if (!_dataArray) {
        
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"profile.plist" ofType:nil];
        
        _dataArray = [NSArray arrayWithContentsOfFile:filePath];
        
    }
    return _dataArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:BLECellId];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]init];
    self.navigationController.navigationItem.titleView = [[UIView alloc]init];
  
}

#pragma mark 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *cellArray = self.dataArray[section];
    return cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BLECellId];
    
    NSDictionary *dataDic = self.dataArray[indexPath.section][indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:dataDic[@"icon"]];
    cell.textLabel.text = dataDic[@"title"];
    
    return cell;

}

#pragma mark 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0 ) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        BLEPhotosController *photoVc = [[BLEPhotosController alloc]initWithCollectionViewLayout:layout];
        
        [self.navigationController pushViewController:photoVc animated:YES];
    }
    
    if(indexPath.section == 1 && indexPath.row == 1) {
       
        UITableViewController *settingVc = [[UIStoryboard storyboardWithName:@"Setting" bundle:nil]instantiateInitialViewController];
        [self.navigationController pushViewController:settingVc animated:YES];
        
    }
 }

@end
