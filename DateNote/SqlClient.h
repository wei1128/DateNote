//
//  SqlClient.h
//  DateNote
//
//  Created by Jackal Wang on 2015/7/15.
//  Copyright (c) 2015年 EC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SqlClient : NSObject

-(void)insertOneDayEvent:(NSString *)startTime :(NSString *)title :(NSString *)description;

-(NSMutableArray *)getMyEvent;

@end
