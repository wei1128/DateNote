//
//  HomeMaskViewController.h
//  DateNote
//
//  Created by Yu-Chen Shen on 2015/7/29.
//  Copyright (c) 2015年 EC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDCalendarView.h"

@interface HomeMaskViewController : UIViewController

@property(strong, nonatomic) KDCalendarView *calendar;
@property(strong, nonatomic) UITableView *tableView;

- (id)initWithCalendar:(KDCalendarView *)calendar tableView:(UITableView *)tableView;

@end
