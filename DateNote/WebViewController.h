//
//  WebViewController.h
//  DateNote
//
//  Created by Yu-Chen Shen on 2015/7/21.
//  Copyright (c) 2015年 EC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property(weak, nonatomic) IBOutlet UIWebView *webView;
@property(strong, nonatomic) NSString *urlString;

- (id)initWithUrlString:(NSString *)urlString;

@end
