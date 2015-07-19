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
+ (NSMutableArray *)select:(NSString *)cmd;

- (void)getDatabase;
- (void)initTabel;
- (void)createTable:(char *)createSql;
- (void)dropTable:(NSString *)tableName;
- (void)closeDatabase;
- (void)insertTempData;
- (void)insertMyEvent:(NSDictionary *)myEvent;
- (void)insertMyTemplete:(NSDictionary *)myTemplete;
- (void)insertTempleteList:(NSDictionary *)templeteList;
- (void)insertTempleteEventList:(NSDictionary *)templeteEventList;

@end
