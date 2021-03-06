//
//  templateList.m
//  DateNote
//
//  Created by Brian Huang on 7/21/15.
//  Copyright (c) 2015 EC. All rights reserved.
//

#import "templateList.h"
#import "myEvent.h"
#import "myTemplate.h"
#import "SqlClient.h"

@implementation templateList

- (NSDictionary *)commentTemplateName:(NSString *)name date:(NSDate *)startTime templateId:(NSInteger)templateId{
    //NSLog(@"%ld",templateId);
    SqlClient *sqlClient = [[SqlClient alloc] init];
    NSString *color = [sqlClient getTemplateColor];
    
    NSMutableArray *template_arr = [sqlClient getTemplateListByID:[NSString stringWithFormat:@"%ld",templateId]];
    NSMutableDictionary *template = [[NSMutableDictionary alloc] initWithDictionary:template_arr[0]];
    [template setValue:@"" forKey:@"mt_id"];
    [template setValue:name forKey:@"t_name"];
    [template setValue:@"" forKey:@"color"];
    myTemplate *mt = [[myTemplate  alloc] initWithDictionary:template];
    
    NSMutableArray *myEvents = [[NSMutableArray alloc]init];
    NSMutableArray *templateEvent_arr = [sqlClient getTemplateEventListByTID:[NSString stringWithFormat:@"%ld",templateId]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd 10:00:00"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSString *tempDate = [formatter stringFromDate:startTime];
//    NSLog(@"dddddd= %@",tempDate);
    NSDateFormatter *formatters = [[NSDateFormatter alloc]init];
    [formatters setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatters setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *newStartTime = [formatters dateFromString:tempDate];
//    NSLog(@"aaaa = %@",newStartTime);
    
    for (int i=0; i<templateEvent_arr.count; i++) {
        NSMutableDictionary *inputDic = [[NSMutableDictionary alloc] initWithDictionary:templateEvent_arr[i]];
        
        [inputDic setValue:@"" forKey:@"me_id"];
        [inputDic setValue:@"" forKey:@"mt_id"];
        
        NSString *unit = inputDic[@"unit"];
        NSString *period = inputDic[@"period"];
        
        if ([unit isEqualToString:@"day"]) {
            NSString *date = [sqlClient getNewDateWith:newStartTime day:[period intValue] month:0 year:0];
            [inputDic setValue:date forKey:@"e_time"];
        }
        
        if ([unit isEqualToString:@"month"]) {
            NSString *date = [sqlClient getNewDateWith:newStartTime day:0 month:[period intValue] year:0];
            [inputDic setValue:date forKey:@"e_time"];
        }
        
        if ([unit isEqualToString:@"year"]) {
            NSString *date = [sqlClient getNewDateWith:newStartTime day:0 month:0 year:[period intValue]];
            [inputDic setValue:date forKey:@"e_time"];
        }
        
        [inputDic setValue:@"0" forKey:@"r_id"];
        [inputDic setValue:color forKey:@"color"];
        [inputDic setValue:name forKey:@"t_name"];
        
        myEvent *me = [[myEvent alloc] initWithDictionary:[NSDictionary dictionaryWithDictionary:inputDic]];
        [myEvents addObject:me];
        
    }
    
    NSDictionary *disc = @{@"myTemplate": mt , @"myEvents": myEvents};
    
    return disc;
}

@end
