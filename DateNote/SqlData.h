//
//  SqlData.h
//  DateNote
//
//  Created by Jackal Wang on 2015/7/13.
//  Copyright (c) 2015年 EC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SqlData : NSObject

@property (nonatomic, strong) NSArray *documentsPath;
@property (nonatomic, strong) NSString *databaseFilePath;

- (void)getDatabase;
- (void)initTabel;
- (void)createTable:(char *)createSql;
- (void)dropTable:(NSString *)tableName;
- (void)closeDatabase;
- (NSInteger)getLastInsertRowID;

- (NSMutableArray *)select:(NSString *)tableName;
- (NSMutableArray *)getTemplateListByID:(NSString *)t_id;

//templateEventList
-(NSMutableArray *)getTemplateEventListByTID:(NSString *)t_id;

//myEvent
-(NSMutableArray *)getMyEvent:(NSString *)time :(NSInteger)count :(NSInteger)pg :(NSString *)mt_id;
-(NSMutableArray *)getMyPastEvent:(NSString *)time :(NSInteger)count :(NSInteger)pg :(NSString *)mt_id;
-(NSMutableArray *)getMyEventByDay:(NSString *)startTime :(NSString *)endTime;
-(NSMutableArray *)getMyEventByPeriod:(NSString *)startTime :(NSString *)endTime;

- (void)insertTempData;
- (void)insertMyEvent:(NSMutableDictionary *)myEvent;
- (void)insertMyTemplate:(NSMutableDictionary *)myTemplate;
- (void)insertTemplateList:(NSMutableDictionary *)templateList;
- (void)insertTemplateEventList:(NSMutableDictionary *)templateEventList;

@end
