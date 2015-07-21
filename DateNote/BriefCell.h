//
//  BriefCell.h
//  DateNote
//
//  Created by Man-Chun Hsieh on 7/21/15.
//  Copyright (c) 2015 EC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BriefCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hourminLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIView *dotView;
@property (weak, nonatomic) IBOutlet UILabel *templateNameLabel;

@end
