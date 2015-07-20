//
//  myEvent.m
//  DateNote
//
//  Created by Brian Huang on 7/19/15.
//  Copyright (c) 2015 EC. All rights reserved.
//

#import "myEvent.h"
#import "SqlClient.h"

@implementation myEvent

- (id)initWithDictionary :(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.me_id = [dictionary[@"me_id"] integerValue];
        self.mt_id = [dictionary[@"me_id"] integerValue];
        self.e_title = dictionary[@"e_title"];
        self.e_detail_url = dictionary[@"e_detail_url"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSDate *e_time = [formatter dateFromString:dictionary[@"e_time"]];
        self.e_time = e_time;
        
        self.r_id = dictionary[@"r_id"];
        self.desc = dictionary[@"desc"];
        self.img_url = dictionary[@"img_url"];
    }
    
    return self;
}

+ (NSArray *)from:(NSDate *)start to:(NSDate *)end {
    NSArray *events = [SqlClient getMyEventFrom:start to:end];
    
    events = [myEvent myEventsWithArray:events];
    
    return events;
}

+ (NSArray *)from:(NSDate *)time pg:(NSInteger)pg mt_id:(NSString *)mt_id {
    NSArray *events = [SqlClient getMyEventFrom:time count:20 pg:pg mt_id:mt_id];
    
    events = [myEvent myEventsWithArray:events];
    
    return events;
}

+ (NSArray *)from:(NSDate *)time pg:(NSInteger)pg {
    NSArray *events = [SqlClient getMyEventFrom:time count:20 pg:pg];
    
    events = [myEvent myEventsWithArray:events];
    
    return events;
}

+ (NSArray *)myEventsWithArray:(NSArray *)array {
    NSMutableArray *events = [NSMutableArray array];
    
    for (NSDictionary *dictionay in array) {
        [events addObject:[[myEvent alloc] initWithDictionary:dictionay]];
    }

    return events;
}

@end
