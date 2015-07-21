//
//  myTemplate.h
//  DateNote
//
//  Created by Brian Huang on 7/20/15.
//  Copyright (c) 2015 EC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myTemplate : NSObject

@property (nonatomic, strong) NSString *mt_id;
@property (nonatomic, strong) NSString *template_id;
@property (nonatomic, strong) NSString *t_name;
@property (nonatomic, strong) NSString *color;

- (id)initWithDictionary :(NSDictionary *)dictionary;

+ (NSArray *)getTemplates;
+ (NSArray *)myTemplateWithArray:(NSArray *)array;

@end
