//
//  EventController.m
//  Famish
//
//  Created by Francisco Flores on 12/16/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#import "EventController.h"

@implementation EventController {
    EKEventStore *eventDB;
    NSString *startEventTitle, *endEventTitle;
}

@synthesize startDate;
@synthesize endDate;
@synthesize reminderDate;

- (id)init
{
    eventDB = [[EKEventStore alloc] init];
    startEventTitle = FASTSTARTTITLE;
    endEventTitle   = FASTENDTITLE;
    return [super init];
}

- (void)save
{
    if ([eventDB respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        [eventDB requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
         {
             if (granted)
             {
                 NSError *startResult = [self addReminderToCalendar:[self mergeTime:startDate Day:reminderDate] Title: startEventTitle];
                 NSError *endResult   = [self addReminderToCalendar:[self mergeTime:endDate Day:reminderDate] Title: endEventTitle];
                 
                 if (startResult && endResult) {
                     UIAlertView *alert = [[UIAlertView alloc]
                                             initWithTitle: @"Error: Reminders Not Saved!"
                                             message: @"There was a problem saving the reminders."
                                             delegate: nil
                                             cancelButtonTitle: @"Okay"
                                             otherButtonTitles: nil];
                     
                    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                                           
                    NSLog(@"Calendar events failed to save! %@ %@", startResult, endResult);
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc]
                                           initWithTitle: @"Reminders Saved"
                                           message: nil
                                           delegate: nil
                                           cancelButtonTitle: @"Okay"
                                           otherButtonTitles: nil];
                     [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                 }
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc]
                                       initWithTitle: @"Oops!"
                                       message: @"You have declined access to your calendar. To save reminders, enable permission in Settings > Privacy > Calendars"
                                       delegate: nil
                                       cancelButtonTitle: @"Okay"
                                       otherButtonTitles: nil];
                 //[alert show];
                 [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
#warning Localize string for iOS versions
             }
         }];
    }
    else
    {
        [self addReminderToCalendar:startDate Title: startEventTitle];
        [self addReminderToCalendar:endDate   Title: endEventTitle];
    }
}

- (NSDate *)mergeTime:(NSDate *)aTimeDate Day:(NSDate *)aDayDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // Extract date components into components1
    NSDateComponents *components1 = [gregorianCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                         fromDate:aDayDate];
    
    // Extract time components into components2
    NSDateComponents *components2 = [gregorianCalendar components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
                                                         fromDate:aTimeDate];
    
    // Combine date and time into components3
    NSDateComponents *components3 = [[NSDateComponents alloc] init];
    
    [components3 setYear:components1.year];
    [components3 setMonth:components1.month];
    [components3 setDay:components1.day];
    
    [components3 setHour:components2.hour];
    [components3 setMinute:components2.minute];
    [components3 setSecond:components2.second];
    [components3 setTimeZone:[NSTimeZone defaultTimeZone]];
    
    // Generate a new NSDate from components3.
    NSDate *combinedDate = [gregorianCalendar dateFromComponents:components3];

    // combinedDate contains both your date and time!
    return combinedDate;
}

- (NSError *)addReminderToCalendar: (NSDate *)aDate Title: (NSString *)aTitle
{
    EKEvent *event  = [EKEvent eventWithEventStore:eventDB];
    event.title     = aTitle;
    event.location  = @"Created via Famish";

    event.startDate = aDate;
    event.endDate   = aDate;
    event.allDay = NO;
    
    // Use default calendar
    [event setCalendar:[eventDB defaultCalendarForNewEvents]];
    
    // Alarm
    NSTimeInterval interval = 0;
    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:interval];
    [event addAlarm:alarm];
    
    NSError *err;
    [eventDB saveEvent: event span:EKSpanThisEvent error:&err];
    return err;
}

@end
