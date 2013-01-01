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
@property (nonatomic, copy)   NSDate *destinationArrivalTime;
@property (nonatomic, retain) NSDate *destinationMorning;
@property (nonatomic, retain) NSTimeZone *destinationTimeZone;
@property (nonatomic, retain) NSString *destinationTimeZoneLabel;

// Departure objects
@property (nonatomic, retain) NSDate *departureMorning;
@property (nonatomic, retain) NSTimeZone *departureTimeZone;
@property (nonatomic, retain) NSString *departureTimeZoneLabel;

// Result objects
@property (nonatomic, retain) NSDate *fastStart;
@property (nonatomic, retain) NSDate *fastEnd;

-(NSString *)fastStartString;
-(NSString *)fastEndString;
-(NSString *)arrivalTimeFormatted;
//-(NSString *)timezoneToLocation: (NSTimeZone *)timeZone;

// Getters
-(NSString *)departureTimeZoneLabel;
-(NSString *)destinationTimeZoneLabel;

@end
