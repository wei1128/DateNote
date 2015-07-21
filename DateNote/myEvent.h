//
//  myEvent.h
//  DateNote
//
//  Created by Brian Huang on 7/19/15.
//  Copyright (c) 2015 EC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myEvent : NSObject 

@property (nonatomic, assign) NSInteger me_id;
@property (nonatomic, assign) NSInteger mt_id;
@property (nonatomic, strong) NSString *e_title;
@property (nonatomic, strong) NSString *e_detail_url;
@property (nonatomic, strong) NSDate *e_time;
@property (nonatomic, strong) NSString *r_id;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *img_url;
@property (nonatomic, strong) NSString *t_name;
@property (nonatomic, strong) NSString *color;

- (id)initWithDictionary :(NSDictionary *)dictionary;

+ (NSArray *)from:(NSDate *)start pg:(NSInteger)pg mt_id:(NSString *)mt_id;
+ (NSArray *)from:(NSDate *)start pg:(NSInteger)pg;
+ (NSArray *)before:(NSDate *)start pg:(NSInteger)pg mt_id:(NSString *)mt_id;
+ (NSArray *)before:(NSDate *)start pg:(NSInteger)pg;
+ (NSArray *)from:(NSDate *)time to:(NSDate *)end;

+ (NSArray *)myEventsWithArray:(NSArray *)array;

@end
