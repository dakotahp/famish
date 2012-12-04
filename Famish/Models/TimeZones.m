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

-(NSString *)localizedMorning {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    // Subtract difference between arrival time and morning time there
    [offsetComponents setHour: -[self hoursBetweenArrivalAndMorning]];
    
    // Create a new date object of destination morning time
    NSDate *morning = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents
                                                                    toDate: self.destinationArrivalTime
                                                                   options:0];
    
    // Create date formatter for converting morning time to local time
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone: self.departureTimeZone];
    [df setDefaultDate: morning];
    [df setDateFormat:@"hh:mm zzz"];
    
    // Create another
//    NSDateFormatter *df_local = [[NSDateFormatter alloc] init];
//    [df_local setTimeZone:[NSTimeZone timeZoneWithName:@"PST"]];
//    [df_local setDateFormat:@"hh:mm zzz"];
    
    return [df stringFromDate: [df defaultDate]];
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
    
    // Add hour chosen for morning
    return [arrivalTimeHour intValue] + self.hourOfMorning;
}

@end
