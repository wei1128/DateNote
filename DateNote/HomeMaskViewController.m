//
//  HomeMaskViewController.m
//  DateNote
//
//  Created by Yu-Chen Shen on 2015/7/29.
//  Copyright (c) 2015年 EC. All rights reserved.
//

#import "HomeMaskViewController.h"

static CGFloat topMaskViewHeight = 0.6f;
static CGFloat calendarBottomMargin = 20.0f;
static CGFloat calendarWidth = 300.0f;
static CGFloat calendarHeight = 250.0f;

@interface HomeMaskViewController ()

@property(strong, nonatomic) UIView *topMaskView;
@property(strong, nonatomic) UIView *bottomMaskView;
@property(assign, nonatomic) CGPoint finalPoint;
@property(assign, nonatomic) CGPoint originalPoint;
@end

@implementation HomeMaskViewController

- (id)initWithCalendar:(KDCalendarView *)calendar tableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.calendar = calendar;
        self.tableView = tableView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView
{
    // UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    // create top mask view
    self.topMaskView = [[UIView alloc] initWithFrame:self.view.frame];
    CGRect rect = self.topMaskView.frame;
    rect.size.height = self.view.frame.size.height * topMaskViewHeight;
    rect.origin.y -= self.view.frame.size.height - self.view.frame.size.height * topMaskViewHeight;
    self.topMaskView.frame = rect;
    self.originalPoint = rect.origin;
    self.topMaskView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f];

    // set calendar position
    rect = CGRectMake(0.0f, 0.0f, calendarWidth, calendarHeight);
    rect.origin.x = (screenRect.size.width - calendarWidth) / 2;
    rect.origin.y = self.topMaskView.frame.size.height - calendarBottomMargin - calendarHeight;
    self.calendar.frame = rect;
    [self.topMaskView addSubview:self.calendar];

    // add pan event
    UIPanGestureRecognizer *singleFingerTap = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(handlePan:)];
    [self.topMaskView addGestureRecognizer:singleFingerTap];

    [self.view addSubview:self.topMaskView];


    // create bottom mask view
    self.bottomMaskView = [[UIView alloc] initWithFrame:self.view.frame];
    rect = self.bottomMaskView.frame;
    rect.size.height = self.view.frame.size.height * (1.0f - topMaskViewHeight);
    rect.origin.y = self.view.frame.size.height;
    self.bottomMaskView.frame = rect;
    self.bottomMaskView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f];

    // set table view position
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.frame = CGRectMake(0.0f, 0.0f, self.bottomMaskView.frame.size.width, self.bottomMaskView.frame.size.height);
    [self.bottomMaskView addSubview:self.tableView];

    [self.view addSubview:self.bottomMaskView];
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {

    // CGPoint point = [recognizer locationInView:recognizer.view];

    CGPoint translation = [recognizer translationInView:self.topMaskView];
    CGPoint velocity = [recognizer velocityInView:self.topMaskView];

    recognizer.view.center = CGPointMake(recognizer.view.center.x + 0.0f,
                                         recognizer.view.center.y + translation.y);

    self.finalPoint = translation;

    if (velocity.y <= 0.0f && self.topMaskView.frame.origin.y <= self.originalPoint.y) {
        //return;
    }

    if (velocity.y < 0.0f) {
        [UIView animateWithDuration: 0.2f
                      delay: 0 
                    options: UIViewAnimationOptionCurveEaseOut 
                 animations:^{
                    CGRect rect = CGRectMake(0.0f, self.originalPoint.y, self.topMaskView.frame.size.width, self.topMaskView.frame.size.height);
                    self.topMaskView.frame = rect;

                    CGRect rect2 = self.bottomMaskView.frame;
                    rect2.origin.y = self.view.frame.size.height;
                    self.bottomMaskView.frame = rect2;
                    }
                 completion:nil];
        return;
    }

    if (CGRectGetMaxY(self.topMaskView.frame) > 200.0f) {

        // Check here for the position of the view when the user stops touching the screen

        // Set "CGFloat finalX" and "CGFloat finalY", depending on the last position of the touch

        // Use this to animate the position of your view to where you want
        [UIView animateWithDuration: 0.2f
                              delay: 0 
                            options: UIViewAnimationOptionCurveEaseOut 
                         animations:^{
                            CGRect rect = CGRectMake(0.0f, 0.0f, recognizer.view.frame.size.width, recognizer.view.frame.size.height);
                            recognizer.view.frame = rect;
                            }
                         completion:nil];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration: 0.2f
                              delay: 0 
                            options: UIViewAnimationOptionCurveEaseOut 
                         animations:^{
                            CGRect rect = CGRectMake(0.0f, self.originalPoint.y, recognizer.view.frame.size.width, recognizer.view.frame.size.height);
                            recognizer.view.frame = rect;
                            }
                         completion:nil];
    }

    [recognizer setTranslation:CGPointMake(0, 0) inView:self.topMaskView];

    // move bottom view
    CGFloat offset = self.topMaskView.frame.origin.y - self.originalPoint.y;
    CGRect rect = self.bottomMaskView.frame;
    rect.origin.y = self.view.frame.size.height - offset;
    self.bottomMaskView.frame = rect;
}

@end
