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

+ (void)initializeEdiableCopyOfDatabase;
+ (void)createEdiableCopyOfDatabaseIfNeeded;
+ (NSMutableArray *)select:(NSString *)tableName;

+ (void)closeDatabase;
+ (NSMutableArray *)getData:(NSString *)cmd;
+ (NSInteger)getLastInsertRowID;
+ (void)insertData:(const char *)sql;
+ (void)deleteData:(NSString *)sqlString;

+ (NSMutableArray *)getTemplateListByID:(NSString *)t_id;

//templateEventList
+(NSMutableArray *)getTemplateEventListByTID:(NSString *)t_id;

//myEvent
+(NSMutableArray *)getMyEventFrom:(NSString *)time count:(NSInteger)count pg:(NSInteger)pg my_id:(NSString *)mt_id;
+(NSMutableArray *)getMyEventFrom:(NSString *)time count:(NSInteger)count pg:(NSInteger)pg;
+(NSMutableArray *)getMyPastEvent:(NSString *)time count:(NSInteger)count pg:(NSInteger)pg mt_id:(NSString *)mt_id;
+(NSMutableArray *)getMyPastEvent:(NSString *)time count:(NSInteger)count pg:(NSInteger)pg;
+(NSMutableArray *)getMyEventByDay:(NSString *)startTime :(NSString *)endTime;
+(NSMutableArray *)getMyEventFrom:(NSString *)startTime to:(NSString *)endTime;
+(void) deleteMyEventByMyEventID:(NSString *)me_id;
+(void) deleteMyEventByMyTemplateID:(NSString *)mt_id;
+(void) deleteMyEventByRecycleID:(NSString *)r_id;

+ (void)insertTempData;
+ (void)insertMyEvent:(NSMutableDictionary *)myEvent;
+ (void)insertMyTemplate:(NSMutableDictionary *)myTemplate;
+ (void)insertTemplateList:(NSMutableDictionary *)templateList;
+ (void)insertTemplateEventList:(NSMutableDictionary *)templateEventList;

@end
