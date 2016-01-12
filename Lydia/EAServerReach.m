//
//  EAServerReach.m
//  ESRA
//
//  Created by Guillermo Moran on 8/31/12.
//
//

#import "EAServerReach.h"

#define NICKNAME @"YOUR_NICKNAME_HERE"

@implementation EAServerReach


-(NSString*)responseFromQuery:(NSString*)query {
    
    NSString* url;
    
    url = @"http://gmoran.me/api/Lydia/Lydia-EN.php";
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    NSData *requestBody = [[NSString stringWithFormat:@"query=%@&name=%@", query, NICKNAME] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:requestBody];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    result = [result stringByReplacingOccurrencesOfString:@"\n\n\n\n\n\n" withString:@""]; //WolframAlpha Fix
    
    NSLog(@"ESRA Server Response: %@", result);
    
    return result;
}


@end
