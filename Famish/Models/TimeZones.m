//
//  TimeZones.m
//  Famish
//
//  Created by dakotah on 12/4/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#import "TimeZones.h"

@implementation TimeZones

@synthesize destinationArrivalTime, destinationMorning, departureMorning;

-(NSString *)fastStart {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    // Subtract difference between morning time and 12 hours prior
    int newHour = -(self.hoursBetweenArrivalAndMorning + 11);
    //NSLog(@"new hour %d", newHour);
    [offsetComponents setHour: newHour];
    
    // Create a new date object of fasting start
    NSDate *morning = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents
                                                                    toDate: self.destinationArrivalTime
                                                                   options:0];
    NSLog(@"fastStart %@", morning);
    // Create date formatter for converting fasting time to local time
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone: self.departureTimeZone];
    [df setDefaultDate: morning];
    [df setDateFormat:@"hh:mm a"];
    //NSLog(@"Formatted start %@ %@", [df defaultDate], [df stringFromDate: [df defaultDate]]);
    return [df stringFromDate: [df defaultDate]];
}

-(NSString *)fastEnd {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    // Subtract difference between arrival time and morning time there
    [offsetComponents setHour: -self.hoursBetweenArrivalAndMorning];
    NSLog(@"morning offset %d", self.hoursBetweenArrivalAndMorning);
    
    // Create a new date object of destination morning time
    NSDate *morning = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents
                                                                    toDate: self.destinationArrivalTime
                                                                   options:0];
    NSLog(@"fastEnd %@", morning);
    // Create date formatter for converting morning time to local time
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone: self.departureTimeZone];
    [df setDefaultDate: morning];
    [df setDateFormat:@"hh:mm a"];
    
    //NSLog(@"Formatted end %@ %@", [df defaultDate], [df stringFromDate: [df defaultDate]]);
    // Create another
//    NSDateFormatter *df_local = [[NSDateFormatter alloc] init];
//    [df_local setTimeZone:[NSTimeZone timeZoneWithName:@"PST"]];
//    [df_local setDateFormat:@"hh:mm zzz"];
    
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
    [dateFormatter setTimeZone: self.departureTimeZone];
    
    // Create hour string with timezone formatted
    NSString *arrivalTimeHour = [dateFormatter stringFromDate: self.destinationArrivalTime];
    
    // Add hour chosen for morning
    return [arrivalTimeHour intValue] + self.hourOfMorning;
}

@end
