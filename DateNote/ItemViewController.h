//
//  ItemViewController.h
//  DateNote
//
//  Created by Jackal Wang on 2015/7/29.
//  Copyright (c) 2015年 EC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ItemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITableView *eventDateTableView;
@property (weak, nonatomic) IBOutlet UITableView *eventDescTableView;

@end
