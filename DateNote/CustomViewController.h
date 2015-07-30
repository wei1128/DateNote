//
//  CustomViewController.h
//  DateNote
//
//  Created by Man-Chun Hsieh on 7/20/15.
//  Copyright (c) 2015 EC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomViewController : UIViewController <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIDatePicker *dataPicker;
    NSArray *plurk;
    NSArray *repeat;
}
@property (strong, nonatomic) NSDictionary *template;
@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *startTime;
@property (weak, nonatomic) IBOutlet UITextField *e_title;
@property (weak, nonatomic) IBOutlet UITextField *e_desc;
@property (weak, nonatomic) IBOutlet UITextField *img_url;
@property (weak, nonatomic) IBOutlet UITextField *e_template;
@property (weak, nonatomic) IBOutlet UITextField *e_repeat;

@property (nonatomic, retain) UIPickerView *templatePicker;
@property (nonatomic, retain) UIPickerView *repeatPicker;

@end