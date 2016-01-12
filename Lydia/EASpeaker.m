//
//  EASpeaker.m
//  ESRA
//
//  Created by Guillermo Moran on 3/24/12.
//  Copyright (c) 2012 Fr0st Development. All rights reserved.
//

#import "EASpeaker.h"

@implementation EASpeaker


+(void)speak:(NSString *)messageToSpeak {
    
    NSSpeechSynthesizer* speaker = [[NSSpeechSynthesizer alloc] initWithVoice:@"com.apple.speech.synthesis.voice.samantha.premium"];
    
    [speaker startSpeakingString:messageToSpeak];
}

//BROKEN
/*
+(void)speak:(NSString *)messageToSpeak {
    NSString* userAgent = @"Mozilla/5.0";
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"http:/www.translate.google.com/translate_tts?tl=en&q=%@",messageToSpeak]
                                       stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
    
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    
    NSURLResponse* gresponse = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&gresponse
                                                     error:&error];
    
    
    
    [data writeToFile:@"/tmp/ESRA-Response.mp3" atomically:YES];
    
    
    AVAudioPlayer *ttsPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:@"/tmp/ESRA-Response.mp3"] error:nil];
    
    [ttsPlayer prepareToPlay];
    [ttsPlayer setVolume: 1.0];
    //[ttsPlayer setDelegate: self];
    [ttsPlayer play];
    //[ttsPlayer release];
    
    NSError* err = nil;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    
    [fm removeItemAtPath:@"/tmp/ESRA/ESRA-Response.mp3" error:nil];
    
    if(err) {
        NSLog(@"File Manager: %@ %ld %@", [err domain], [err code], [[err userInfo] description]);
        
        UIAlertView* errorAlert = [[UIAlertView alloc]initWithTitle:@"An Error Occurred" message:[NSString stringWithFormat:@"File Manager: %@ %ld %@", [err domain], [err code], [[err userInfo] description]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [errorAlert show];
        [errorAlert release];
    }
    else {
        NSLog(@"Deleted temp response file successfully!");
    }

}
 */
 
@end
