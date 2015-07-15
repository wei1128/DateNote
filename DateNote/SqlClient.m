//
//  SqlClient.m
//  DateNote
//
//  Created by Jackal Wang on 2015/7/15.
//  Copyright (c) 2015年 EC. All rights reserved.
//

#import "SqlClient.h"
#import "SqlData.h"

@interface SqlClient ()

@end

@implementation SqlClient

-(void)insertOneDayEvent:(NSString *)startTime :(NSString *)title :(NSString *)description{
    NSDictionary *tempDic = @{@"my_templete_id": @"0",@"recycle_id": @"0",@"title": @"title",@"time": @"time",@"detail_url": @"detail_url",@"desc": @"desc",@"img_url": @"img_url"};
    NSMutableDictionary *inputDic = [[NSMutableDictionary alloc] initWithDictionary:tempDic];
    
    [inputDic setObject:startTime forKey:@"time"];
    [inputDic setObject:title forKey:@"title"];
    [inputDic setObject:description forKey:@"desc"];
    
    SqlData *sqlData = [[SqlData alloc] init];
    [sqlData getDatabase];
    [sqlData insertMyEvent:inputDic];
    [sqlData closeDatabase];
}

-(NSMutableArray *)getMyEvent{
    SqlData *sqlData = [[SqlData alloc] init];
    [sqlData getDatabase];
    NSMutableArray *result = [sqlData select:@"myEvent"];
    [sqlData closeDatabase];
    
    return result;
}
@end
