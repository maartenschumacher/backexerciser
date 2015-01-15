//
//  BENotification.h
//  BackExerciser
//
//  Created by Maarten Schumacher on 9/13/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BENotification : NSObject <NSUserNotificationCenterDelegate>

@property NSUserNotificationCenter *notificationCenter;
@property int recurrence;
@property int startTime;
@property int endTime;
@property NSInteger currentTime;
@property NSString *nextDelivery;
@property int launchState;

+(id)getInstance;
-(void)scheduleNotifications;
-(void)stopNotifications;
-(void)testNotification;
-(void)savePrefs;

@end
