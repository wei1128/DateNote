//
//  SqlData.m
//  DateNote
//
//  Created by Jackal Wang on 2015/7/13.
//  Copyright (c) 2015年 EC. All rights reserved.
//

#import "SqlData.h"
#import <sqlite3.h>

static sqlite3 *database = nil;

@interface SqlData ()

+ (sqlite3 *)database;
+ (void)setDatabase :(sqlite3 *)newDatabase;

@end

@implementation SqlData

+ (void)initializeEdiableCopyOfDatabase {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDictionary = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDictionary stringByAppendingPathComponent:@"datenote.sqlite"];
    NSString *defaultDBPath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"datenote.sqlite"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:writableDBPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:writableDBPath error:nil];
    }
    [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    [self initDatabase :writableDBPath];
}

+ (void)createEdiableCopyOfDatabaseIfNeeded {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDictionary = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDictionary stringByAppendingPathComponent:@"datenote.sqlite"];
    
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (!success) {
        NSString *defaultDBPath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"datenote.sqlite"];
        [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    [self initDatabase :writableDBPath];
}

+ (void)initDatabase :(NSString *)path {
    sqlite3 *database = nil;
    
    if (sqlite3_open([path UTF8String], &database)==SQLITE_OK) {
        NSLog(@"open sqlite db ok.");
        //這裡寫入要對資料庫操作的程式碼
        
    }else{
        NSLog( @"can not open sqlite db " );
        
        //使用完畢後關閉資料庫聯繫
        sqlite3_close(database);
    }
    
    [self setDatabase:database];
}

+ (void)setDatabase :(sqlite3 *)newDatabase {
    database = newDatabase;
}

+ (NSMutableArray *)select:(NSString *)cmd{
    //建立 Sqlite 語法
    const char *sql = [cmd UTF8String];
    
    //stm將存放查詢結果
    sqlite3_stmt *statement =nil;
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSString *keyName, *value;
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            int column_count = sqlite3_column_count(statement);
            NSLog(@"count = %d",column_count);
            for (int i=0; i<column_count; i++) {
                int column_type = sqlite3_column_type(statement,i);
                keyName = [NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)];
                if (column_type == SQLITE_INTEGER) {
                    NSLog(@"%@",keyName);
                    value = [NSString stringWithFormat:@"%d",(int)sqlite3_column_int(statement, i)];
                }else{
                    value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, i)];
                }
                
                NSLog(@"keyname = %@ , value = %@", keyName, value);
                [data setObject:value forKey:keyName];
            }
            [result addObject:data];
        }
        
        //使用完畢後將statement清空
        sqlite3_finalize(statement);
    }
    
    return result;
}


/*

- (void)initTabel{
    char *createMyEventSql = "create table if not exists myEvent (my_event_id INTEGER PRIMARY KEY, my_templete_id INTEGER, title TEXT, detail_url TEXT, time TEXT, recycle_id TEXT, desc TEXT, img_url TEXT)";
    char *createMyTempleteSql = "create table if not exists myTemplete (my_templete_id INTEGER PRIMARY KEY, templete_id INTEGER, tilte TEXT, color TEXT)";
    char *createTempleteListSql = "create table if not exists templeteList (templete_id INTEGER PRIMARY KEY, title TEXT)";
    char *createTempleteEventListSql = "create table if not exists templeteEventList (event_id INTEGER PRIMARY KEY, templete_id INTEGER, recycle TEXT, title TEXT, desc TEXT, detail_url TEXT, unit TEXT, period INTEGER)";
    
    
    [self createTable:createMyEventSql];
    [self createTable:createMyTempleteSql];
    [self createTable:createTempleteListSql];
    [self createTable:createTempleteEventListSql];
    
}

- (void)createTable:(char *)createSql{
    char *errorMsg;
    
    if (sqlite3_exec(self.dataBase, createSql, NULL, NULL, &errorMsg)==SQLITE_OK) {
        NSLog(@"TABLE OK");
        
    }else{
        //建立失敗時的處理
        NSLog(@"error: %s",errorMsg);
        
        //清空錯誤訊息
        sqlite3_free(errorMsg);
    }
}

- (void)dropTable:(NSString *)tableName{
    char *errorMsg;
    NSString *sqlString = [NSString stringWithFormat:@"%@%@", @"DROP TABLE IF EXISTS ", tableName];
    const char *sql = [sqlString UTF8String];
    
    if (sqlite3_exec(self.dataBase, sql, NULL, NULL, &errorMsg)==SQLITE_OK) {
        NSLog(@"DROP TABLE OK");
        
    }else{
        //建立失敗時的處理
        NSLog(@"error: %s",errorMsg);
        
        //清空錯誤訊息
        sqlite3_free(errorMsg);
    }
    
}

- (void)closeDatabase{
    //使用完畢後關閉資料庫聯繫
    sqlite3_close(self.dataBase);
}

- (NSMutableArray *)select:(NSString *)tableName{
    //建立 Sqlite 語法
    NSString *sqlString = [NSString stringWithFormat:@"%@%@", @"select * from ", tableName];
    const char *sql = [sqlString UTF8String];
    
    //stm將存放查詢結果
    sqlite3_stmt *statement =nil;
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    if (sqlite3_prepare_v2(self.dataBase, sql, -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSString *keyName, *value;
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            int column_count = sqlite3_column_count(statement);
            NSLog(@"count = %d",column_count);
            for (int i=0; i<column_count; i++) {
                int column_type = sqlite3_column_type(statement,i);
                keyName = [NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)];
                if (column_type == SQLITE_INTEGER) {
                    NSLog(@"%@",keyName);
                    value = [NSString stringWithFormat:@"%d",(int)sqlite3_column_int(statement, i)];
                }else{
                    value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, i)];
                }
                
                NSLog(@"keyname = %@ , value = %@", keyName, value);
                [data setObject:value forKey:keyName];
            }
            [result addObject:data];
        }
        
        //使用完畢後將statement清空
        sqlite3_finalize(statement);
    }
    
    return result;

}

- (void)selectTemplateWithId{
    
}



- (void)insertTempData{
    //插入資料
    char *insertErrorMsg;
    
    //建立 Sqlite 語法
    const char *insertSql="insert into templeteList (title)values('小孩出生')";
    if (sqlite3_exec(self.dataBase, insertSql, NULL, NULL, &insertErrorMsg)==SQLITE_OK) {
        NSLog(@"INSERT OK");
    }
    
}

- (void)insertMyEvent:(NSMutableDictionary *)myEvent{
    NSString *my_templete_id = [myEvent valueForKey:@"my_templete_id"];
    NSString *title = [myEvent objectForKey:@"title"];
    NSString *detail_url = [myEvent objectForKey:@"detail_url"];
    NSString *time = [myEvent objectForKey:@"time"];
    NSString *recycle_id = [myEvent objectForKey:@"recycle_id"];
    NSString *desc = [myEvent objectForKey:@"desc"];
    NSString *img_url = [myEvent objectForKey:@"img_url"];
    
    NSString *sqlFormat = @"insert into myEvent (my_templete_id,title,detail_url,time,recycle_id,desc,img_url)values(%@,'%@','%@','%@','%@','%@','%@')";
    
    NSString *sqlString = [NSString stringWithFormat:sqlFormat, my_templete_id, title, detail_url, time, recycle_id, desc, img_url];
    NSLog(@"sql = %@",sqlString);
    
    const char *sql = [sqlString UTF8String];
    
    [self insertData:sql];
    
}

- (void)insertMyTemplete:(NSMutableDictionary *)myTemplete{
    NSString *templete_id = [myTemplete objectForKey:@"templete_id"];
    NSString *title = [myTemplete objectForKey:@"tilte"];
    NSString *color = [myTemplete objectForKey:@"color"];
    
    NSString *sqlFormat = @"insert into myTemplete (templete_id,title,color)values(%@,'%@','%@')";
    
    NSString *sqlString = [NSString stringWithFormat:sqlFormat, templete_id, title, color];
    
    const char *sql = [sqlString UTF8String];
    
    [self insertData:sql];
}

- (void)insertTempleteList:(NSMutableDictionary *)templeteList{
    NSString *title = [templeteList objectForKey:@"tilte"];
    
    NSString *sqlFormat = @"insert into templeteList (title)values('%@')";
    
    NSString *sqlString = [NSString stringWithFormat:sqlFormat, title];
    
    const char *sql = [sqlString UTF8String];
    
    [self insertData:sql];
}

- (void)insertTempleteEventList:(NSMutableDictionary *)templeteEventList{
    NSString *templete_id = [templeteEventList objectForKey:@"templete_id"];
    NSString *recycle = [templeteEventList objectForKey:@"recycle"];
    NSString *title = [templeteEventList objectForKey:@"title"];
    NSString *desc = [templeteEventList objectForKey:@"desc"];
    NSString *detail_url = [templeteEventList objectForKey:@"detail_url"];
    NSString *unit = [templeteEventList objectForKey:@"unit"];
    NSString *period = [templeteEventList objectForKey:@"period"];
    
    NSString *sqlFormat = @"insert into templeteEventList (templete_id,recycle,title,desc,detail_url,unit,period)values(%@,'%@','%@','%@','%@','%@',%@)";
    
    NSString *sqlString = [NSString stringWithFormat:sqlFormat, templete_id, recycle, title, desc, detail_url, unit, period];
    
    const char *sql = [sqlString UTF8String];
    
    [self insertData:sql];
}

- (void)insertData:(const char *)sql{
    char *insertErrorMsg;

    if (sqlite3_exec(self.dataBase, sql, NULL, NULL, &insertErrorMsg)==SQLITE_OK) {
        NSLog(@"INSERT OK");
    }
}


- (void)createTableIndex{
    const char *sql = "create index film_title_index on film(title);";
}

*/



@end
