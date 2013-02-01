//
//  EventController.h
//  Famish
//
//  Created by Francisco Flores on 12/16/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

// Event Titles
#define FASTSTARTTITLE @"Stop Eating";
#define FASTENDTITLE @"Time to eat!";

#import <EventKit/EventKit.h>

@interface EventController : NSObject

@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) NSDate *reminderDate;

- (void)save;

@end
