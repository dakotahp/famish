//
//  TimeZones.m
//  Famish
//
//  Created by dakotah on 12/4/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#import "TimeZones.h"

@implementation TimeZones

@synthesize destinationArrivalTime, destinationMorning, departureMorning, fastStart, fastEnd;

-(NSString *)fastStartString {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    // Subtract difference between morning time and 12 hours prior
    int newHour = -(self.hoursBetweenArrivalAndMorning + 12);
    [offsetComponents setHour: newHour];
    
    // Create a new date object of fasting start
    NSDate *morning = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents
                                                                    toDate: self.destinationArrivalTime
                                                                   options:0];

    // Create date formatter for converting fasting time to local time
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone: self.departureTimeZone];
    [df setDefaultDate: morning];
    [df setDateFormat:@"hh:mm a"];

    // Save date object
    fastStart = [df defaultDate];
    
    return [df stringFromDate: [df defaultDate]];
}

-(NSString *)fastEndString {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    // Subtract difference between arrival time and morning time there
    [offsetComponents setHour: -self.hoursBetweenArrivalAndMorning];
    
    // Create a new date object of destination morning time
    NSDate *morning = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents
                                                                    toDate: self.destinationArrivalTime
                                                                   options:0];
    
    // Create date formatter for converting morning time to local time
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone: self.departureTimeZone];
    [df setDefaultDate: morning];
    [df setDateFormat:@"hh:mm a"];
    
    // Save date object
    fastEnd = [df defaultDate];
    
    return [df stringFromDate: [df defaultDate]];
}

-(NSString *)arrivalTimeFormatted {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:    self.destinationTimeZone];
    [df setDefaultDate: self.destinationArrivalTime];
    [df setDateFormat:  @"h:mm a"];
    return [df stringFromDate: [df defaultDate]];
}

- (NSString *)timezoneToLocation: (NSTimeZone *)timeZone {
    NSString *tzString = [timeZone name];
    NSArray *timezoneChunks = [tzString componentsSeparatedByString: @"/"];
    NSString *timezoneParsed = [timezoneChunks objectAtIndex: timezoneChunks.count - 1];
    return [timezoneParsed stringByReplacingOccurrencesOfString:@"_" withString:@" "];
}

-(NSInteger)hoursBetweenArrivalAndMorning
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    // Format it so it only returns hour
    [dateFormatter setDateFormat:@"hh"];
    
    // Set timezone from user choice
    [dateFormatter setTimeZone: self.destinationTimeZone];
    
    // Create hour string with timezone formatted
    NSString *arrivalTimeHour = [dateFormatter stringFromDate: self.destinationArrivalTime];
    
    // Subtract hour chosen for morning
    return [arrivalTimeHour intValue] - self.hourOfMorning;
}

@end
