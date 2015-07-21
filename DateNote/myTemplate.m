//
//  myTemplate.m
//  DateNote
//
//  Created by Brian Huang on 7/20/15.
//  Copyright (c) 2015 EC. All rights reserved.
//

#import "myTemplate.h"
#import "SqlClient.h"

@implementation myTemplate

- (id)initWithDictionary :(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.mt_id = dictionary[@"mt_id"];
        self.template_id = dictionary[@"template_id"];
        self.t_name = dictionary[@"t_name"];
        self.color = dictionary[@"color"];
    }
    
    return self;
}

+ (NSArray *)getTemplates {
    NSArray *templates = [SqlClient getMyTemplate];
    
    templates = [myTemplate myTemplateWithArray:templates];
    
    return templates;
}

+ (NSArray *)myTemplateWithArray:(NSArray *)array {
    NSMutableArray *templates = [NSMutableArray array];
    
    for (NSDictionary *dictionay in array) {
        [templates addObject:[[myTemplate alloc] initWithDictionary:dictionay]];
    }
    
    return templates;
}


@end
