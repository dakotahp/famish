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

@synthesize startDate, endDate;

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
                 [self addReminderToCalendar:startDate Title: startEventTitle];
                 [self addReminderToCalendar:endDate   Title: endEventTitle];
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc]
                                       initWithTitle: @"Oops!"
                                       message: @"You have declined access to your calendar. To use save reminders in the future you will need to turn this permission on in Settings > Privacy > Calendars"
                                       delegate: nil
                                       cancelButtonTitle: @"Okay"
                                       otherButtonTitles: nil];
                 [alert show];
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

- (void)addReminderToCalendar: (NSDate *)aDate Title: (NSString *)aTitle
{
    EKEvent *event  = [EKEvent eventWithEventStore:eventDB];
    event.title     = aTitle;

    event.startDate = aDate;
    event.endDate   = aDate;
    event.allDay = NO;
    
    // Use default calendar
    [event setCalendar:[eventDB defaultCalendarForNewEvents]];
    
    // Alarm
    NSTimeInterval interval = 60* -5;
    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:interval];
    [event addAlarm:alarm];
    
    NSError *err;
    [eventDB saveEvent: event span:EKSpanThisEvent error:&err];
    
    if (!err)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Reminders Saved"
                              message: nil
                              delegate: nil
                              cancelButtonTitle: @"Okay"
                              otherButtonTitles: nil];
        //[alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Error: Reminders Not Saved!"
                              message: @"There was a problem saving the reminders."
                              delegate: nil
                              cancelButtonTitle: @"Okay"
                              otherButtonTitles: nil];
        //[alert show];
        
        NSLog(@"Calendar events failed to save! %@", err);
    }
}

@end
