//
//  SqlClient.h
//  DateNote
//
//  Created by Jackal Wang on 2015/7/15.
//  Copyright (c) 2015年 EC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SqlClient : NSObject

-(void)initDataBase;
-(void)initTempData;
-(void)resetData;

-(void)insertOneDayEventStartWith:(NSString *)startTime title:(NSString *)title description:(NSString *)description;
-(void)insertDayEventStartWith:(NSString *)startTime title:(NSString *)title description:(NSString *)description r_id:(NSString *)r_id;
-(void)insertWeekEventStartWith:(NSString *)startTime title:(NSString *)title description:(NSString *)description r_id:(NSString *)r_id;
-(void)insertMonthEventStartWith:(NSString *)startTime title:(NSString *)title description:(NSString *)description r_id:(NSString *)r_id;
-(void)insertYearEventStartWith:(NSString *)startTime title:(NSString *)title description:(NSString *)description r_id:(NSString *)r_id;

-(NSMutableArray *)getMyEvent;
//templateList
-(NSMutableArray *)getTemplateList;
-(NSMutableArray *)getTemplateListByID:(NSString *)t_id;

//templateEventList
-(NSMutableArray *)getTemplateEventListByTID:(NSString *)t_id;

//myEvent
-(NSMutableArray *)getMyEvent:(NSString *)time :(NSInteger)count :(NSInteger)pg :(NSString *)mt_id;
-(NSMutableArray *)getMyPastEvent:(NSString *)time :(NSInteger)count :(NSInteger)pg :(NSString *)mt_id;
-(NSMutableArray *)getMyEventByDay:(NSString *)time;
-(NSMutableArray *)getMyEventByPeriod:(NSString *)startTime :(NSString *)endTime;


//myTemplate
-(NSMutableArray *)getMyTemplate;

@end
