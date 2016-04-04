//
//  BLECommentController.m
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/17.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLECommentController.h"
#import "AFNetworking.h"
#import "BLEUserResultModel.h"
#import "MJExtension.h"
#import "BLECommentHeaderView.h"
#import <UIImageView+WebCache.h>
#import "BLERequestData.h"
#import "BLETCommentCell.h"

#define cell_id @"cell_id"
@interface BLECommentController ()

@property (nonatomic, strong)BLECommentHeaderView *headerView;
@property (nonatomic, strong)NSMutableArray *commentArr;

@end

@implementation BLECommentController

- (BLECommentHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"CommentHeaderView" owner:nil options:nil]lastObject];
        
        _headerView.backgroundColor = [UIColor clearColor];
        
        __weak typeof(self) __weakSelf = self;
        _headerView.myBlock = ^(NSInteger height) {
            __weakSelf.tableView.sectionHeaderHeight = height;
            [__weakSelf.tableView reloadData];
        };
        _headerView.entityModel = self.entityModel;
        
        NSLog(@"%@",NSStringFromCGRect(self.headerView.commentView.frame));
    }
    return _headerView;
}

- (NSMutableArray *)commentArr {
    
    if (!_commentArr) {
        _commentArr = [NSMutableArray array];
    }
    
    return _commentArr;
}

- (void)loadView {
    
    [super loadView];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    BLERequestData *dataTool = [BLERequestData sharedInstance];
    
    [dataTool requestCommentModelWithId:self.entityModel.ids page:1 success:^(id responseTask) {
        
        [self.commentArr addObjectsFromArray:responseTask];
        
        [self.tableView reloadData];
        
    } fause:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
    
    UINib *nib = [UINib nibWithNibName:@"CommentRecordView" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cell_id];
}


#pragma mark tableView的数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.commentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cell_id";
    BLETCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[BLETCommentCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    BLEUserModel *model = self.commentArr[indexPath.row];
    cell.model = model;
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return self.headerView.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
