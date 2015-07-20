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

- (id)initWithDictionary :(NSDictionary *)dictionary;

+ (NSArray *)from:(NSDate *)start to:(NSDate *)end;
-(NSMutableArray *)getMyEvent:(NSDate *)time :(NSInteger)count :(NSInteger)pg :(NSString *)catid;

@end
