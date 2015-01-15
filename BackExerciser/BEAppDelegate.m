//
//  BEAppDelegate.m
//  BackExerciser
//
//  Created by Maarten Schumacher on 9/13/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "BEAppDelegate.h"
#include "BEViewController.h"
#import "BENotification.h"

@interface BEAppDelegate ()

@property (nonatomic, strong) IBOutlet BEViewController *viewController;

@end

@implementation BEAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.viewController = [[BEViewController alloc]initWithNibName:@"BEViewController" bundle:nil];
    [self.window.contentView addSubview:self.viewController.view];
    self.viewController.view.frame = ((NSView *)self.window.contentView).bounds;
    [self.viewController configureView];
    [self.viewController launchNotifications];
}

-(void)applicationWillTerminate:(NSNotification *)notification {
    BENotification *instance = [BENotification getInstance];
    [instance savePrefs];
}



@end
