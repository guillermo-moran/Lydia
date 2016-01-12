//
//  LDAAppDelegate.m
//  Lydia
//
//  Created by Guillermo Moran on 4/16/14.
//  Copyright (c) 2014 Fr0st Development. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "LDAAppDelegate.h"

#import "EASpeaker.h"
#import "EAGoogleConnect.h"
#import "EAServerReach.h"

#import "LDAResponseParser.h"

@implementation LDAAppDelegate



-(void)animateProgressView:(BOOL)animate {
    if (animate) {
        [spinner setColor:[NSColor lightGrayColor]];
        [spinner setHidden:NO];
        [spinner startAnimation:self];
        [waveView setHidden:YES];
        return;
    }
    [spinner stopAnimation:self];
    [spinner setHidden:YES];
    [waveView setHidden:NO];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
 
    [self loadAudioSession];
    
    //NSColor* backgroundColor = [NSColor colorWithRed:0/255.0f green:4/255.0f blue:44/255.0f alpha:1.0f];
    //self.window.backgroundColor = backgroundColor;
    //table.backgroundColor = backgroundColor;
    
    //responses = [[NSMutableArray alloc] init];
    //[responses addObject:@"\"Hello, Guillermo.\""];
    //[table reloadData];
     
    
    questionField.stringValue = @"Ask me anything";
    
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

-(void)addResponseToTable:(NSString *)response {
    
    /*
    isQuery = NO;
    [responses addObject:[NSString stringWithFormat:@"\"%@\"",response]];
    
    NSIndexSet *indexes = [[NSIndexSet alloc] initWithIndex:[responses count]];
    [table insertRowsAtIndexes:indexes withAnimation:NSTableViewAnimationSlideLeft];
    
    NSInteger numberOfRows = [responses count];
    
    if (numberOfRows > 0)
        [table scrollRowToVisible:numberOfRows - 1];
    */
    
    answerField.stringValue = response;
    
    [EASpeaker speak:response];
    
    [self animateProgressView:NO];
    
}

-(void)addQueryToTable:(NSString *)query {
    
    /*
    isQuery = YES;
    [responses addObject:query];
    
    NSIndexSet *indexes = [[NSIndexSet alloc] initWithIndex:[responses count]];
    [table insertRowsAtIndexes:indexes withAnimation:NSTableViewAnimationSlideRight];
    */
    
    questionField.stringValue = query;
    
    //Query The Server Right After
    
    NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
    [myQueue addOperationWithBlock:^{
        
        
        EAServerReach* serverConnect = [[EAServerReach alloc] init];
        LDAResponseParser* parser = [[LDAResponseParser alloc] init];
        
        NSString* serverResponse = [serverConnect responseFromQuery:query];
        NSString* parsedResponse = [parser parsedResponseFromString:serverResponse];
        
       
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            //NSInteger numberOfRows = [responses count];
            
            //if (numberOfRows > 0)
                //[table scrollRowToVisible:numberOfRows - 1];
             [self addResponseToTable:parsedResponse];
            
        }];
    }];
    
    
}

//Recorder

-(void)loadAudioSession {
    
    NSError *error;
    
    //Load Audio Session
    //audioSession = [[AVAudioSession sharedInstance] retain];
    //[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
    //[audioSession setActive:YES error:&error];
    
    
    //Load Recorder
    NSURL *soundFileURL = [NSURL fileURLWithPath:@"/tmp/ESRA-Temp.wav"];
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    
    recorder = [[AVAudioRecorder alloc]
                initWithURL:soundFileURL
                settings:recordSetting
                error:&error];
    
    recorder.meteringEnabled = YES;
    
    [recorder setDelegate:self];
    [recorder prepareToRecord];
    
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
        
    }
    
}

-(IBAction)toggleListening:(id)sender {
    
        NSError* error;
        if (recorder.recording)
        {
            
            /*
            NSString* recorderSound = [[NSBundle mainBundle] pathForResource:@"stop-rec" ofType:@"mp3"];
            NSURL *soundURL = [[NSURL alloc] initFileURLWithPath: recorderSound];
            AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
            [player setDelegate:self];
            [player prepareToPlay];
            [player play];
             */
            
            CFBundleRef mainBundle= CFBundleGetMainBundle();
            CFURLRef soundFileURLRef;
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle,(CFStringRef) @"stop-rec", CFSTR ("mp3"), NULL);
            UInt32 soundID;
            AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
            AudioServicesPlaySystemSound(soundID);
            
            
            [recorder stop];
            
            if (error) {
                NSLog(@"An Error Occurred: %@",[error localizedDescription]);
                
            }
            
        }
        else {
            /*
            NSString* recorderSound = [[NSBundle mainBundle] pathForResource:@"start-rec" ofType:@"mp3"];
            NSURL *soundURL = [[NSURL alloc] initFileURLWithPath: recorderSound];
            AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
            [player setDelegate:self];
            [player prepareToPlay];
            [player play];
             */
            
            CFBundleRef mainBundle= CFBundleGetMainBundle();
            CFURLRef soundFileURLRef;
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle,(CFStringRef) @"start-rec", CFSTR ("mp3"), NULL);
            UInt32 soundID;
            AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
            AudioServicesPlaySystemSound(soundID);
            
            [recorder record];
            
            if (error) {
                
                NSLog(@"An Error Occurred: %@",[error localizedDescription]);
                
            }
        }
}
    
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag {
        if (flag) {
            
            //Handle Queries and add them to the table
            
            NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
            [myQueue addOperationWithBlock:^{
                
                EAGoogleConnect* gConnect = [[EAGoogleConnect alloc] init];
                
                [self animateProgressView:YES];
                
                [self addQueryToTable:[gConnect recognizedSpeech]];
                NSLog(@"RECOGNIZED SPEECH: %@", [gConnect recognizedSpeech]);
                NSLog(@"Successfully recorded audio");
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Main thread work (UI usually)
                }];
            }];
            
        }
        else {
            [self addResponseToTable:@"Sorry, I didn't catch that. Try again?"];
        }
    }


//TableView Shits

#define FONT_SIZE 26.0f
#define CELL_CONTENT_WIDTH 342.0f
#define CELL_CONTENT_MARGIN 20.0f

/*
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    
    
    NSString * cellText = [responses objectAtIndex:row];
    
    // set a font size
    NSFont *cellFont = [NSFont fontWithName:@"HelveticaNeue-Light" size:FONT_SIZE];
    
    // get a constraint size - not sure how it works
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    
    // calculate a label size - takes parameters including the font, a constraint and a specification for line mode
    
    NSDictionary *attributes = @{NSFontAttributeName: cellFont};
    
    CGSize labelSize = [cellText sizeWithAttributes:attributes];
    
    
    // give it a little extra height
    return labelSize.height + 20;
}
 */
 

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    // Get a new ViewCell
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    // Since this is a single-column table view, this would not be necessary.
    // But it's a good practice to do it in order by remember it when a table is multicolumn.
    if([tableColumn.identifier isEqualToString:@"Responses"])
    {
        //cellView.textField.stringValue = [responses objectAtIndex:row];
        
        NSRect frame = NSMakeRect(0, 0, 342, MAXFLOAT);
        
        cellView.textField.frame = frame;
        [cellView.textField setAttributedStringValue:[responses objectAtIndex:row]];
        //[cellView.textField setHorizontallyResizable:NO];
        [cellView.textField sizeToFit];
        
        if (!isQuery) {
            cellView.textField.font = [NSFont fontWithName:@"HelveticaNeue" size:26];
        }
        
        
    }
    return cellView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [responses count];
}

/*
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)rowIndex {
    //NSLog(@"%li tapped!", (long)rowIndex);
    return YES;
}
 */


@end
