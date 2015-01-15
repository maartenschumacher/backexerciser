//
//  BENotification.m
//  BackExerciser
//
//  Created by Maarten Schumacher on 9/13/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "BENotification.h"



@implementation BENotification

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadPrefs];
    }
    return self;
}

+ (id)getInstance {
    static BENotification *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc]init];
        }
        return instance;
    }
}

-(void)savePrefs {
    NSDictionary *dict = @{@"recurrence":[NSNumber numberWithInt:self.recurrence],
                           @"startTime":[NSNumber numberWithInt:self.startTime],
                           @"endTime":[NSNumber numberWithInt:self.endTime],
                           @"launchState":[NSNumber numberWithInt:self.launchState]};
    
    [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"saveData"];
}

-(void)loadPrefs {
    NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]dictionaryForKey:@"saveData"]];
    if (dict.count > 0) {
        self.recurrence = [[dict objectForKey:@"recurrence"] intValue];
        self.startTime = [[dict objectForKey:@"startTime"] intValue];
        self.endTime = [[dict objectForKey:@"endTime"] intValue];
        self.launchState = [[dict objectForKey:@"launchState"]intValue];
    } else {
        self.recurrence = 90;
        self.startTime = 9;
        self.endTime = 17;
        self.launchState = 1;
    }
    [self updateNextDelivery];
}

- (NSUserNotification *)getNotificationWithDate:(NSDate *)date {
    NSUserNotification *notification = [[NSUserNotification alloc]init];
    notification.title = @"Time to exercise!";
    notification.subtitle = @"BackExerciser";
    notification.deliveryRepeatInterval = nil;
    notification.deliveryTimeZone = [NSTimeZone localTimeZone];
    notification.deliveryDate = date;
    notification.actionButtonTitle = @"More..";
    return notification;
}

//array of notifications to schedule for one day

- (NSMutableArray *)notificationsToSchedule {
    // get starting reference
    NSDate *today = [[NSDate alloc]init];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:today];
    NSInteger startHour = self.startTime;
    if (self.currentTime > self.startTime) {
        startHour = self.currentTime;
        [components setHour:self.currentTime];
    } else {
        [components setHour:self.startTime];
    }
    NSDate *reference = [gregorian dateFromComponents:components];
    
    // get array of notifications
    NSMutableArray *notifications = [[NSMutableArray alloc]init];
    for (NSInteger i = (startHour*60); i < (self.endTime*60); i += self.recurrence) {
        NSTimeInterval seconds = i * 60;
        seconds -= startHour * 60 * 60;
        NSDate *delivery = [NSDate dateWithTimeInterval:seconds sinceDate:reference];
        NSUserNotification *notification = [self getNotificationWithDate:delivery];
        [notifications addObject:notification];
        NSLog(@"%@", [notifications description]);
    }
    [notifications removeObjectAtIndex:0];
    NSLog(@"%@", [notifications description]);
    return notifications;
}

//schedule notifications

-(void)scheduleNotifications {
    NSDate *now = [[NSDate alloc]init];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    self.currentTime = [gregorian component:NSHourCalendarUnit fromDate:now];
    if (self.currentTime < self.endTime) {
        self.notificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
        self.notificationCenter.scheduledNotifications = [self notificationsToSchedule];
        [self updateNextDelivery];
        self.notificationCenter.delegate = self;
    }
}

-(void)updateNextDelivery {
    if (self.notificationCenter.scheduledNotifications.count > 0) {
        NSDate *date = [self.notificationCenter.scheduledNotifications[0] deliveryDate];
        NSString *format = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
        self.nextDelivery = format;
    }
    else {
        self.nextDelivery = @"Nothing found";
    }
}

//stop notifying

-(void)stopNotifications {
    NSArray *empty = [[NSArray alloc]initWithObjects:nil];
    self.notificationCenter.scheduledNotifications = empty;
    [self updateNextDelivery];
}

//test

-(void)testNotification {
    if (self.notificationCenter == nil) {
        self.notificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
        self.notificationCenter.delegate = self;
    }
    NSDate *oneMinuteLater = [[NSDate alloc] initWithTimeIntervalSinceNow:5];
    NSUserNotification *notification = [[NSUserNotification alloc]init];
    notification.title = @"Time to exercise!";
    notification.subtitle = @"BackExerciser";
    notification.deliveryRepeatInterval = nil;
    notification.deliveryDate = oneMinuteLater;
    notification.hasActionButton = YES;
    notification.actionButtonTitle = @"More..";
    [self.notificationCenter scheduleNotification:notification];
    self.nextDelivery = @"In five seconds...";
}

//delegate methods

-(void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    [[NSApplication sharedApplication]activateIgnoringOtherApps:NO];
}

-(void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification {
    [self updateNextDelivery];
}

-(BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

@end
