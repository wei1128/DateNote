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
    }
    
    return self;
}

+ (NSArray *)from:(NSDate *)start to:(NSDate *)end {
    NSMutableArray *events = [SqlClient getMyEventFrom:start to:end];
    NSLog(@"%@", events);
    return [[NSArray alloc] init];
}

@end
