//
//  templateList.h
//  DateNote
//
//  Created by Brian Huang on 7/21/15.
//  Copyright (c) 2015 EC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface templateList : NSObject

- (NSDictionary *)commentTemplateName:(NSString *)name date:(NSDate *)startTime templateId:(NSInteger)templateId;

@end
