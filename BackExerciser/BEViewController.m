//
//  BEViewController.m
//  BackExerciser
//
//  Created by Maarten Schumacher on 9/13/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "BEViewController.h"
#import "BENotification.h"
#import "BELaunchAtLogin.h"

@interface BEViewController ()
@property (weak) IBOutlet NSTextField *nextLabel;
@property (weak) IBOutlet NSButton *startStopButton;
@property (weak) IBOutlet NSPopUpButton *popUpButton;
@property BENotification *instance;
@end

@implementation BEViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        self.instance = [BENotification getInstance];
        [self.instance addObserver:self
                        forKeyPath:@"nextDelivery"
                           options:NSKeyValueObservingOptionNew
                           context:NULL];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"nextDelivery"]) {
        NSString *string = [object valueForKeyPath:keyPath];
        [self.nextLabel setStringValue:string];
    }
}

-(void)configureView {
    NSArray *menu = @[@"2 hours",@"1.5 hours",@"1 hour",@"0.5 hours"];
    [self.popUpButton removeAllItems];
    [self.popUpButton addItemsWithTitles:menu];
    [self.popUpButton selectItemAtIndex:1];
}

-(void)readData {
    NSDictionary *dictMenu = @{@120:@"2 hours", @90:@"1.5 hours", @60:@"1 hour", @30:@"0.5 hours"};
    NSArray *bs = [dictMenu allKeysForObject:[self.popUpButton titleOfSelectedItem]];
    self.instance.recurrence = [bs[0] intValue];
}
- (IBAction)testNotification:(id)sender {
    [self.instance testNotification];
    NSLog(@"testing");
}

- (IBAction)startStop:(id)sender {
    if ([self.startStopButton.title isEqualToString:@"Stop"]) {
        [self.instance stopNotifications];
    }
    if ([self.startStopButton.title isEqualToString:@"Start"]) {
        [self launchNotifications];
    }
}

- (IBAction)updateButton:(id)sender {
    [self readData];
    [self.instance scheduleNotifications];
}

-(void)launchNotifications {
    // check user input and fire up notifications
    [self readData];
    
    [self.instance scheduleNotifications];
}

@end
