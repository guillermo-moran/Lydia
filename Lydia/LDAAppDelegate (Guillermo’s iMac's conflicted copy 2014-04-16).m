//
//  LDAAppDelegate.m
//  Lydia
//
//  Created by Guillermo Moran on 4/16/14.
//  Copyright (c) 2014 Fr0st Development. All rights reserved.
//

#import "LDAAppDelegate.h"

#import "EASpeaker.h"

@implementation LDAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    NSColor* backgroundColor = [NSColor colorWithRed:0/255.0f green:4/255.0f blue:44/255.0f alpha:1.0f];
    self.window.backgroundColor = backgroundColor;
    table.backgroundColor = backgroundColor;
    
    responses = [NSMutableArray array];
    [responses addObject:@"Hello, Willie"];
    [EASpeaker speak:@"Hello, Willie."];
    [table reloadData];

}

//TableView Shits

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    // Get a new ViewCell
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    // Since this is a single-column table view, this would not be necessary.
    // But it's a good practice to do it in order by remember it when a table is multicolumn.
    if([tableColumn.identifier isEqualToString:@"Responses"])
    {
        cellView.textField.stringValue = [responses objectAtIndex:row];
        return cellView;
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
