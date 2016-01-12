//
//  EAGoogleConnect.m
//  ESRA
//
//  Created by Guillermo Moran on 9/14/12.
//
//

#import "EAGoogleConnect.h"

#import "LDAAppDelegate.h"

#define GOOGLE_API_KEY @"YOUR_GOOGLE_API_KEY_HERE"


@implementation EAGoogleConnect

- (id)init {
    self = [super init];
    
    if (self) {
        // initialize instance variables here
    }
    
    return self;
}

-(void)convertToFlac {
    NSString* ffmpegPath = [[NSBundle mainBundle] pathForResource:@"ffmpeg" ofType:@""];
    NSString* path = @"/tmp/ESRA-Temp.wav";
    
    NSTask *task = [[NSTask alloc] init];
    NSArray *arguments = [NSArray arrayWithObjects: @"-i", path, @"-vn", @"-ac", @"1", @"-ar", @"16000", @"-acodec", @"flac", @"/tmp/ESRA-Temp.flac", nil];
    NSPipe *pipe = [NSPipe pipe];
    //NSFileHandle * read = [pipe fileHandleForReading];
    
    [task setLaunchPath: ffmpegPath];
    [task setArguments: arguments];
    [task setStandardOutput: pipe];
    [task launch];
    [task waitUntilExit];
    
    //NSData* data = [read readDataToEndOfFile];
    //NSString* stringOutput = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    
    //NSLog(@"%@", stringOutput);
    //NSLog(@"%i", [task terminationStatus]);
    //NSLog(@"DONE");
    //[task release];
}


-(NSString*)recognizedSpeech {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    
    [fm removeItemAtPath:@"/tmp/ESRA-Temp.flac" error:nil];
    
    [self convertToFlac];
    
    NSString *recDir = @"/tmp";
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/ESRA-Temp.flac", recDir]];
    
    NSData *flacFile = [NSData dataWithContentsOfURL:url];
    //NSString *audio = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/recordTest.flac", recDir]];
    
    NSString* countryID;
    
    
    countryID = @"en-US";
    
    
    
    //NSString* googleSpeechURL = [NSString stringWithFormat:@"https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=%@",countryID];
    
    NSString* googleSpeechURL = [NSString stringWithFormat:@"https://www.google.com/speech-api/v2/recognize?xjerr=1&client=chromium&lang=%@&key=%@", GOOGLE_API_KEY, countryID];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:googleSpeechURL]];
    
    [request setHTTPMethod:@"POST"];
    
    //set headers
    
    //[request addValue:@"Content-Type" forHTTPHeaderField:@"audio/x-flac; rate=16000"];
    
    [request addValue:@"audio/x-flac; rate=16000" forHTTPHeaderField:@"Content-Type"];
    
    //NSString *requestBody = [[NSString alloc] initWithFormat:@"Content=%@", flacFile];
    
    //[request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:flacFile];
    
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[flacFile length]] forHTTPHeaderField:@"Content-length"];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", result);
    
    
    
    
    @try {
        NSRange range = [result rangeOfString:@"{\"transcript\":\""];
        NSString* gspeechhalf = [result substringFromIndex:range.location+14];
        //[result release];
        NSRange range2 = [gspeechhalf rangeOfString:@"\",\"confidence"];
        NSString* gspeech = [gspeechhalf substringToIndex:range2.location];
        
        _recognizedSpeech = gspeech;
        
        //[mainController analyzeText:gspeech];
        
    }
    @catch (NSException *exception) {
        
        _recognizedSpeech = result;
    }
   
    
    
   

    
    [fm removeItemAtPath:@"/tmp/ESRA-Temp.flac" error:nil];
    
    _recognizedSpeech = [_recognizedSpeech stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    _recognizedSpeech = [_recognizedSpeech stringByReplacingOccurrencesOfString:@"plus" withString:@"+"];
    _recognizedSpeech = [_recognizedSpeech stringByReplacingOccurrencesOfString:@"minus" withString:@"-"];
    _recognizedSpeech = [_recognizedSpeech stringByReplacingOccurrencesOfString:@"times" withString:@"*"];
    _recognizedSpeech = [_recognizedSpeech stringByReplacingOccurrencesOfString:@"divided by" withString:@"/"];
    
    return _recognizedSpeech;

}


@end
