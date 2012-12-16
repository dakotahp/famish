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
}

@synthesize startDate, endDate;

- (id)init
{
    eventDB = [[EKEventStore alloc] init];
    return [super init];
}

- (void)save
{
    EKEvent *fastStartEvent  = [EKEvent eventWithEventStore:eventDB];
    fastStartEvent.title     = FASTSTARTTITLE;
    fastStartEvent.startDate = [[NSDate alloc] init];
    fastStartEvent.endDate   = [[NSDate alloc] init];
    fastStartEvent.allDay = YES;
    [fastStartEvent setCalendar:[eventDB defaultCalendarForNewEvents]];
    
    NSError *errStart;
    [eventDB saveEvent:fastStartEvent span:EKSpanThisEvent error:&errStart];
    
    EKEvent *fastEndEvent  = [EKEvent eventWithEventStore:eventDB];
    fastEndEvent.title     = FASTENDTITLE;
    fastEndEvent.startDate = [[NSDate alloc] init];
    fastEndEvent.endDate   = [[NSDate alloc] init];
    fastEndEvent.allDay = YES;
    [fastEndEvent setCalendar:[eventDB defaultCalendarForNewEvents]];

    NSError *errEnd;
    [eventDB saveEvent:fastEndEvent span:EKSpanThisEvent error:&errEnd];
    
    if ( !errStart && !errEnd )
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Reminders Saved"
                              message: nil
                              delegate: nil
                              cancelButtonTitle: @"Okay"
                              otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        NSLog(@"Calendar events failed to save!");
    }
}

@end
