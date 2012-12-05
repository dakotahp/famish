//
//  TimeZones.h
//  Famish
//
//  Created by dakotah on 12/4/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

@interface TimeZones : NSData

// Config
@property (nonatomic) NSInteger hourOfMorning;


// Destination objects
@property (nonatomic, copy) NSDate *destinationArrivalTime;
@property (nonatomic, retain) NSDate *destinationMorning;
@property (nonatomic, retain) NSTimeZone *destinationTimeZone;

// Departure objects
@property (nonatomic, retain) NSDate *departureMorning;
@property (nonatomic, retain) NSTimeZone *departureTimeZone;

-(NSString *)fastStart;
-(NSString *)fastEnd;
-(NSString *)arrivalTimeFormatted;
-(NSString *)timezoneToLocation: (NSTimeZone *)timeZone;

@end
