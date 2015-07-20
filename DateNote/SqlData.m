//
//  SqlData.m
//  DateNote
//
//  Created by Jackal Wang on 2015/7/13.
//  Copyright (c) 2015年 EC. All rights reserved.
//

#import "SqlData.h"
#import <sqlite3.h>


@interface SqlData ()

@property (nonatomic, assign) sqlite3 *dataBase;
@end

@implementation SqlData

- (void)getDatabase{
    
    self.documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.databaseFilePath = [[self.documentsPath objectAtIndex:0] stringByAppendingPathComponent:@"db.sql"];
    
    sqlite3 *database = nil;
    
    if (sqlite3_open([self.databaseFilePath UTF8String], &database)==SQLITE_OK) {
        NSLog(@"open sqlite db ok.");
        //這裡寫入要對資料庫操作的程式碼
        
    }else{
        NSLog( @"can not open sqlite db " );
        
        //使用完畢後關閉資料庫聯繫
        sqlite3_close(database);
    }
    
    self.dataBase = database;
}

- (void)initTabel{
    char *createMyEventSql = "create table if not exists myEvent (me_id INTEGER PRIMARY KEY, mt_id INTEGER, e_title TEXT, e_detail_url TEXT, e_time TEXT, r_id TEXT, desc TEXT, img_url TEXT)";
    char *createMyTemplateSql = "create table if not exists myTemplate (mt_id INTEGER PRIMARY KEY, template_id INTEGER, t_name TEXT, color TEXT)";
    char *createTemplateListSql = "create table if not exists templateList (template_id INTEGER PRIMARY KEY, t_name TEXT)";
    char *createTemplateEventListSql = "create table if not exists templateEventList (event_id INTEGER PRIMARY KEY, template_id INTEGER, recycle TEXT, e_title TEXT, desc TEXT, e_detail_url TEXT, unit TEXT, period INTEGER, img_url TEXT)";
    
    char *createMyEventViewSql = "create view myEventView as select a.*,b.t_name,b.color from myEvent a,myTemplate b where a.mt_id = b.mt_id";
    
    
    [self createTable:createMyEventSql];
    [self createTable:createMyTemplateSql];
    [self createTable:createTemplateListSql];
    [self createTable:createTemplateEventListSql];
    
    [self createTable:createMyEventViewSql];
    
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
        
    NSMutableArray *result = [self getData:sqlString];
    
    return result;
}

-(NSMutableArray *)getMyEvent:(NSString *)time :(NSInteger)count :(NSInteger)pg :(NSString *)mt_id{
    //建立 Sqlite 語法
    NSString *sqlString = [NSString stringWithFormat:@"select * from myEventView where e_time >='%@' and mt_id=%@   order by e_time asc limit %ld,%ld", time, mt_id, (long)pg*(long)count, (long)count];
    
    NSMutableArray *result = [self getData:sqlString];
    
    return result;
}

-(NSMutableArray *)getMyPastEvent:(NSString *)time :(NSInteger)count :(NSInteger)pg :(NSString *)mt_id{
    //建立 Sqlite 語法
    NSString *sqlString = [NSString stringWithFormat:@"select * from myEventView where e_time <='%@' and mt_id=%@   order by e_time desc limit %ld,%ld", time, mt_id, (long)pg*(long)count, (long)count];
    
    NSMutableArray *result = [self getData:sqlString];
    
    return result;
}

-(NSMutableArray *)getMyEventByDay:(NSString *)startTime :(NSString *)endTime{
    //建立 Sqlite 語法
    NSString *sqlString = [NSString stringWithFormat:@"select * from myEventView where e_time >='%@' and e_time <='%@'   order by e_time asc",startTime, endTime];
    
    NSMutableArray *result = [self getData:sqlString];
    
    return result;
}

-(NSMutableArray *)getMyEventByPeriod:(NSString *)startTime :(NSString *)endTime{
    //建立 Sqlite 語法
    NSString *sqlString = [NSString stringWithFormat:@"select * from myEventView where e_time >='%@' and e_time <='%@' order by e_time asc",startTime, endTime];
    
    NSMutableArray *result = [self getData:sqlString];
    
    return result;
    
}


- (NSMutableArray *) getData:(NSString *) sqlString{
    NSLog(@"sql query = %@",sqlString);
    const char *sql = [sqlString UTF8String];
    
    //stm將存放查詢結果
    sqlite3_stmt *statement =nil;
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    if (sqlite3_prepare_v2(self.dataBase, sql, -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSString *keyName, *value;
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            int column_count = sqlite3_column_count(statement);
//            NSLog(@"count = %d",column_count);
            for (int i=0; i<column_count; i++) {
                int column_type = sqlite3_column_type(statement,i);
                keyName = [NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)];
                if (column_type == SQLITE_INTEGER) {
//                    NSLog(@"%@",keyName);
                    value = [NSString stringWithFormat:@"%d",(int)sqlite3_column_int(statement, i)];
                }else{
                    value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, i)];
                }
                
//                NSLog(@"keyname = %@ , value = %@", keyName, value);
                [data setObject:value forKey:keyName];
            }
            [result addObject:data];
        }
        
        //使用完畢後將statement清空
        sqlite3_finalize(statement);
    }
    
    return result;
}

- (NSMutableArray *) getTemplateListByID:(NSString *) t_id{
    //建立 Sqlite 語法
    NSString *sqlString = [NSString stringWithFormat:@"%@%@", @"select * from templateList where template_id =", t_id];
    
    NSMutableArray *result = [self getData:sqlString];
    
    return result;
}

-(NSMutableArray *)getTemplateEventListByTID:(NSString *)t_id{
    //建立 Sqlite 語法
    NSString *sqlString = [NSString stringWithFormat:@"%@%@", @"select * from templateEventList where template_id =", t_id];
    
    NSMutableArray *result = [self getData:sqlString];
    
    return result;
}

- (void)selectTemplateWithId{
    
}



- (void)insertTempData{
    //插入資料
    char *insertErrorMsg;
    
    //建立 Sqlite 語法
    const char *insertSql="insert into templateList (t_name)values('小孩出生')";
    if (sqlite3_exec(self.dataBase, insertSql, NULL, NULL, &insertErrorMsg)==SQLITE_OK) {
        NSLog(@"INSERT OK");
    }
    
}

- (void)insertMyEvent:(NSMutableDictionary *)myEvent{
    NSString *mt_id = [myEvent valueForKey:@"mt_id"];
    NSString *e_title = [myEvent objectForKey:@"e_title"];
    NSString *e_detail_url = [myEvent objectForKey:@"e_detail_url"];
    NSString *e_time = [myEvent objectForKey:@"e_time"];
    NSString *r_id = [myEvent objectForKey:@"r_id"];
    NSString *desc = [myEvent objectForKey:@"desc"];
    NSString *img_url = [myEvent objectForKey:@"img_url"];
    
    NSString *sqlFormat = @"insert into myEvent (mt_id,e_title,e_detail_url,e_time,r_id,desc,img_url)values(%@,'%@','%@','%@','%@','%@','%@')";
    
    NSString *sqlString = [NSString stringWithFormat:sqlFormat, mt_id, e_title, e_detail_url, e_time, r_id, desc, img_url];
    NSLog(@"sql = %@",sqlString);
    
    const char *sql = [sqlString UTF8String];
    
    [self insertData:sql];
    
}

- (void)insertMyTemplate:(NSMutableDictionary *)myTemplate{
    NSString *template_id = [myTemplate objectForKey:@"template_id"];
    NSString *t_name = [myTemplate objectForKey:@"t_name"];
    NSString *color = [myTemplate objectForKey:@"color"];
    
    NSString *sqlFormat = @"insert into myTemplate (template_id,t_name,color)values(%@,'%@','%@')";
    
    NSString *sqlString = [NSString stringWithFormat:sqlFormat, template_id, t_name, color];
    
    const char *sql = [sqlString UTF8String];
    
    [self insertData:sql];
}

- (void)insertTemplateList:(NSMutableDictionary *)templateList{
    NSString *t_name = [templateList objectForKey:@"t_name"];
    
    NSString *sqlFormat = @"insert into templateList (t_name)values('%@')";
    
    NSString *sqlString = [NSString stringWithFormat:sqlFormat, t_name];
    
    const char *sql = [sqlString UTF8String];
    
    [self insertData:sql];
}

- (void)insertTemplateEventList:(NSMutableDictionary *)templateEventList{
    NSString *template_id = [templateEventList objectForKey:@"template_id"];
    NSString *recycle = [templateEventList objectForKey:@"recycle"];
    NSString *e_title = [templateEventList objectForKey:@"e_title"];
    NSString *desc = [templateEventList objectForKey:@"desc"];
    NSString *e_detail_url = [templateEventList objectForKey:@"e_detail_url"];
    NSString *unit = [templateEventList objectForKey:@"unit"];
    NSString *period = [templateEventList objectForKey:@"period"];
    NSString *img_url = [templateEventList objectForKey:@"img_url"];
    
    NSString *sqlFormat = @"insert into templateEventList (template_id,recycle,e_title,desc,e_detail_url,unit,period,img_url)values(%@,'%@','%@','%@','%@','%@',%@,'%@')";
    
    NSString *sqlString = [NSString stringWithFormat:sqlFormat, template_id, recycle, e_title, desc, e_detail_url, unit, period, img_url];
    
    const char *sql = [sqlString UTF8String];
    
    [self insertData:sql];
}

- (void)insertData:(const char *)sql{
    char *insertErrorMsg;

    if (sqlite3_exec(self.dataBase, sql, NULL, NULL, &insertErrorMsg)==SQLITE_OK) {
        NSLog(@"INSERT OK");
    }else{
        NSLog(@"insertData -- error = %s",insertErrorMsg);
    }
    NSLog(@"sqlite3_last_insert_rowid = %lld", sqlite3_last_insert_rowid(self.dataBase));
}

- (NSInteger)getLastInsertRowID{
    return sqlite3_last_insert_rowid(self.dataBase);
}


- (void)createTableIndex{
    const char *sql = "create index film_title_index on film(title);";
}





@end
