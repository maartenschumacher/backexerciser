//
//  BEController.m
//  BackExerciser
//
//  Created by Maarten Schumacher on 9/17/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "BEController.h"
#import "BENotification.h"

@interface BEController ()
@property (weak) IBOutlet NSButton *launchBox;
@property (weak) IBOutlet NSStepper *endStep;
@property (weak) IBOutlet NSTextField *endField;
@property (weak) IBOutlet NSTextField *startField;
@property (weak) IBOutlet NSStepper *startStep;
@end


@implementation BEController

- (IBAction)controlDidChange:(id)sender {
    BENotification *instance = [BENotification getInstance];
    if (sender == self.startField || sender == self.startStep) {
        [instance setStartTime:[sender intValue]];
    }
    if (sender == self.endField || sender == self.endStep) {
        [instance setEndTime:[sender intValue]];
    }
    if (sender == self.launchBox) {
        [instance setLaunchState:[sender intValue]];
    }
    [self updateControls];
}

-(void)updateControls {
    BENotification *instance = [BENotification getInstance];
    [self.startStep setIntValue:instance.startTime];
    [self.startField setIntValue:instance.startTime];
    [self.endStep setIntValue:instance.endTime];
    [self.endField setIntValue:instance.endTime];
    [self.launchBox setIntValue:instance.launchState];
}

@end
