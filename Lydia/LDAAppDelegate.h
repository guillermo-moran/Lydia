//
//  LDAAppDelegate.h
//  Lydia
//
//  Created by Guillermo Moran on 4/16/14.
//  Copyright (c) 2014 Fr0st Development. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

#import "YRKSpinningProgressIndicator.h"

#import "SISinusWaveView.h"

@interface LDAAppDelegate : NSObject <NSApplicationDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate> {
    
    IBOutlet YRKSpinningProgressIndicator *spinner;
    
    IBOutlet NSTableView* table;
    NSMutableArray* responses;
    BOOL isQuery;
    
    IBOutlet SISinusWaveView* waveView;
    BOOL isLoading;
    
    AVAudioRecorder *recorder;
    
    IBOutlet NSTextField* questionField;
    IBOutlet NSTextField* answerField;
    
}

@property (assign) IBOutlet NSWindow *window;


-(void)addResponseToTable:(NSString*)response;

-(void)animateProgressView:(BOOL)animate;

-(IBAction)toggleListening:(id)sender;

@end
