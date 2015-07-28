//
//  BigImageCell.m
//  DateNote
//
//  Created by Man-Chun Hsieh on 7/28/15.
//  Copyright (c) 2015 EC. All rights reserved.
//

#import "BigImageCell.h"

@implementation BigImageCell

- (void)awakeFromNib {
    self.bigImage.layer.shadowColor = [UIColor grayColor].CGColor;
    self.bigImage.layer.shadowOffset = CGSizeMake(0, 1);
    self.bigImage.layer.shadowOpacity = 1;
    self.bigImage.layer.shadowRadius = 1.0;
    self.bigImage.clipsToBounds = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
