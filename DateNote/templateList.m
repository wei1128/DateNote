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

@implementation templateList

- (NSDictionary *)newChildTemplateName:(NSString *)name date:(NSDate *)birthday {
    myTemplate *mt = [[myTemplate  alloc]init];
    NSArray *myEvents = [[NSArray alloc]init];
    
    NSDictionary *disc = @{@"myTemplate": mt , @"myEvents": myEvents};
    
    return disc;
}

@end
