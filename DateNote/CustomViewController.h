//
//  CustomViewController.h
//  DateNote
//
//  Created by Man-Chun Hsieh on 7/20/15.
//  Copyright (c) 2015 EC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomViewController : UIViewController <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{ UIDatePicker *dataPicker;
}
@property (strong, nonatomic) NSDictionary *template;
@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *endDate;
@end
