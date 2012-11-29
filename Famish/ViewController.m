//
//  ViewController.m
//  Famish
//
//  Created by Francisco Flores on 11/27/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize departureTimeZone,
            arrivalTimeZone,
            departureTime,
            arrivalTime,
            localArrivalTime,
            morningHour;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    morningHour = -8;
    double secondsInHour = 60*60;
    NSInteger destinationTimeZone = ([[NSTimeZone systemTimeZone] secondsFromGMT] / secondsInHour * [arrivalTimeZone.text intValue] );
    
    /*
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT: destinationTimeZone]];
    NSDate *homeTimeConverted = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:localArrivalTime.date options:0];
     */
    //NSLog(@"CONVERTED %@", homeTimeConverted);

    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:2010];
    [comps setMonth:8];
    [comps setDay:24];
    [comps setHour:17];
    [comps setMinute:5];
    //[comps setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Tokyo"]];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Tokyo"]];
    NSDate *referenceTime = [cal dateByAddingComponents:comps toDate:localArrivalTime.date options:0];
    NSLog(@"Converted time %@", referenceTime);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)   hoursBetweenArrival: (NSDate *)arrivalDate
           andMorningWithTimeZone: (NSInteger)timeZone
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh"];
    NSString *arrivalTimeHour = [dateFormatter stringFromDate:arrivalDate];
    
    return [arrivalTimeHour intValue] + morningHour;
}

-(NSDate *)getMorningTime: (NSDate *)arrivalDate MorningOffset: (NSInteger)morningOffset {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setHour: morningOffset];
    
    NSDate *localTime = [gregorian dateByAddingComponents:offsetComponents
                                                       toDate:arrivalDate
                                                      options:0];
    
    NSLog(@"Morning in destination  %@", localTime);
    
    [offsetComponents setHour: -8];
    
    NSDate *homeTime = [gregorian dateByAddingComponents:offsetComponents
                                                   toDate:localTime
                                                  options:0];
    
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setTimeZone: [NSTimeZone localTimeZone]];
    NSDate *homeTimeConverted = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:homeTime options:0];

    //NSLog(@"Morning converted %@", homeTimeConverted);
    
    return [NSDate date];
}

-(NSDate *)createLocalizedDateFromArrivalDate: (NSDate *)arrivalDate {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"h:mm a"];
    [outputFormatter stringFromDate: arrivalDate];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setHour:8];
    [comps setMinute:0];
    [comps setSecond:0];
    [comps setDay:10];
    [comps setMonth:10];
    [comps setYear:2010];
    [comps setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Tokyo"]];
    NSDate *timestamp = [[NSCalendar currentCalendar] dateFromComponents:comps];
    //NSLog(@"LOCALIZED DATE %@", timestamp);

    return [NSDate date];
}

-(IBAction)calculate:(id)sender {
    
    // Get time from arrival time
    //NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    //[outputFormatter setDateFormat:@"h:mm a"];
    //[outputFormatter stringFromDate: localArrivalTime.date];
    
    /*
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setHour: [arrivalTimeZone.text intValue]];
    NSLog(@"arrival zone %d",[arrivalTimeZone.text intValue]);
    NSDate *endOfWorldWar3 = [gregorian dateByAddingComponents:offsetComponents
                                                        toDate:localArrivalTime.date options:0];
     */
    
    // Get hour and minute in 24hr clock
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH"];
    NSString *hour = [NSString stringWithFormat:@"%@",
                   [df stringFromDate: localArrivalTime.date ]];
    
    [df setDateFormat:@"mm"];
    NSString *minute = [NSString stringWithFormat:@"%@",
                     [df stringFromDate: localArrivalTime.date ]];
    // Build new time in proper timezone
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setHour: [hour intValue]];
    [comps setMinute: [minute intValue]];
    [comps setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Tokyo"]];
    NSDate *ts = [[NSCalendar currentCalendar] dateFromComponents:comps];
    NSLog(@"Created date %@", ts);
    
    
    //NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setHour:8];
    [comps setMinute:0];
    [comps setSecond:0];
    [comps setDay:10];
    [comps setMonth:10];
    [comps setYear:2010];
    [comps setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Tokyo"]];
    NSDate *timestamp = [[NSCalendar currentCalendar] dateFromComponents:comps];
    //NSLog(@"DATE %@", timestamp);
    
    NSInteger hourBeforeMorning = [self hoursBetweenArrival:localArrivalTime.date
                                     andMorningWithTimeZone: [arrivalTimeZone.text intValue]];
    
    [self getMorningTime:localArrivalTime.date MorningOffset:hourBeforeMorning];
    

    //NSLog(@"%@", [outputFormatter stringFromDate:localArrivalTime.date]);
    //NSLog(@"%@", endOfWorldWar3);
    
    // Calculate departure time in GMT
    //NSTimeInterval diffClockInOutToLunch = [outToLunch timeIntervalSinceDate:clockIn];
    //[]departureTime
    
    
    // Rip apart chosen time
    // make new time specifying hour and minute
    // set timezone
    
    NSDate* ts_utc = localArrivalTime.date;
    
    NSDateFormatter* df_utc = [[NSDateFormatter alloc] init];
    [df_utc setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [df_utc setDateFormat:@"yyyy.MM.dd 'at' HH:mm:ss zzz"];
    
    NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
    [df_local setTimeZone:[NSTimeZone timeZoneWithName:@"PST"]];
    [df_local setDateFormat:@"yyyy.MM.dd 'at' HH:mm:ss zzz"];

    NSDateFormatter* df_jp = [[NSDateFormatter alloc] init];
    [df_jp setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Tokyo"]];
    [df_jp setDateFormat:@"yyyy.MM.dd 'at' HH:mm:ss zzz"];


    NSString* ts_jp_string = [df_utc stringFromDate:ts_utc];
    NSString* ts_utc_string = [df_utc stringFromDate:ts_utc];
    NSString* ts_local_string = [df_local stringFromDate:ts_utc];
    
    //NSLog(@"Tokyo time: %@", ts_jp_string);
    //NSLog(@"GMT: %@", ts_utc_string);
    //NSLog(@"PST: %@", ts_local_string);
}

@end
