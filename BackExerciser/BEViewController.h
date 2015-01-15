//
//  BEViewController.h
//  BackExerciser
//
//  Created by Maarten Schumacher on 9/13/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BEViewController : NSViewController <NSUserNotificationCenterDelegate>

//@property int start;
//@property int end;

-(void)configureView;
-(void)launchNotifications;

@end
