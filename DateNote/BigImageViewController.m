//
//  BigImageViewController.m
//  DateNote
//
//  Created by Man-Chun Hsieh on 7/28/15.
//  Copyright (c) 2015 EC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BigImageViewController.h"
#import "BigImageCell.h"

@interface BigImageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *bigImageTable;

@end

@implementation BigImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bigImageTable.dataSource=self;
    self.bigImageTable.delegate=self;
    self.bigImageTable.separatorStyle=NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];  //取消選取
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BigImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBigImageCell" forIndexPath:indexPath];

    // 邊筐
    //[cell.bigImage.layer setBorderColor: [[UIColor grayColor] CGColor]];
    //[cell.bigImage.layer setBorderWidth: 1];
    //[cell.bigImage.layer setMasksToBounds:YES];

    
    //陰影
    [cell.testview.layer setShadowOffset:CGSizeMake(0.0, 0.0)]; //陰影的位移量
    [cell.testview.layer setShadowRadius:3.0];    //陰影的散射半徑（緊實程度）
    [cell.testview.layer setShadowOpacity:0.8];    //陰影的透明度1為不透明
    [cell.testview.layer setShadowColor:[UIColor blackColor].CGColor];    //陰影顏色


    return cell;
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
