//
//  LDAResponseParser.m
//  Lydia
//
//  Created by Guillermo Moran on 4/18/14.
//  Copyright (c) 2014 Fr0st Development. All rights reserved.
//

#import "LDAResponseParser.h"

@implementation LDAResponseParser

-(NSString*)parsedResponseFromString:(NSString*)query {
    
    if ([query hasPrefix:@"<Get_Date>"]) {
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/YY"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        
        return [NSString stringWithFormat:@"Today it is %@", dateString];
    }
    if ([query hasPrefix:@"<Get_Time>"]) {
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"hh:mm"];
        NSString *timeString = [dateFormatter stringFromDate:currDate];
        
        return [NSString stringWithFormat:@"It is %@", timeString];
    }
    
    return query;
}

@end
