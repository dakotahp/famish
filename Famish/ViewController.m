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
            morningHour,
            timeConversion;

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    timeConversion = [[TimeZones alloc] init];
    timeConversion.hourOfMorning = 8;
    
    morningHour = -8;
    double secondsInHour = 60*60;
    NSInteger destinationTimeZone = ([[NSTimeZone systemTimeZone] secondsFromGMT] / secondsInHour * [arrivalTimeZone.text intValue] );
    
    // Dump all known timezones
    NSArray *timezoneNames = [NSTimeZone knownTimeZoneNames];
	for (NSString *name in
		 [timezoneNames sortedArrayUsingSelector:@selector(compare:)])
	{
		//NSLog(@"%@",name);
	}
    NSArray *abbrev = [NSTimeZone abbreviationDictionary];
	for(NSString *name in abbrev)
	{
		//NSLog(@"%@",name);
	}
    
    /*
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT: destinationTimeZone]];
    NSDate *homeTimeConverted = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:localArrivalTime.date options:0];
     */
    //NSLog(@"CONVERTED %@", homeTimeConverted);
    
    
    localArrivalTime.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Tokyo"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)calculate:(id)sender {

    // Using models
    timeConversion.destinationArrivalTime = localArrivalTime.date;
    timeConversion.destinationTimeZone    = [NSTimeZone timeZoneWithName: arrivalTimeZone.text];
    timeConversion.departureTimeZone      = [NSTimeZone timeZoneWithName: @"PST"];
    
    NSLog(@"Chosen time: %@", timeConversion.destinationArrivalTime);
    NSLog(@"Your time: %@", timeConversion.localizedMorning);
    /////// End model code
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Results"
                                                    message:[NSString stringWithFormat:@"You can begin eating again at %@", timeConversion.localizedMorning]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    

    
//    NSInteger hoursBetweenArrivalAndMorning = [self hoursBetweenArrival: localArrivalTime.date
//                                                 andMorningWithTimeZone: arrivalTimeZone.text];
    //NSLog(@"Hours before morning: %d", hoursBetweenArrivalAndMorning);

//    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
//    [offsetComponents setHour: -hoursBetweenArrivalAndMorning];
//    NSDate *morning = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents
//                                                                             toDate: localArrivalTime.date
//                                                                            options:0];
//
//    
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setTimeZone:[NSTimeZone localTimeZone]];
//    [df setDefaultDate: morning];
//    
//    NSDateFormatter *df_local = [[NSDateFormatter alloc] init];
//    [df_local setTimeZone:[NSTimeZone timeZoneWithName:@"PST"]];
//    [df_local setDateFormat:@"hh:mm zzz"];
    


    
    
    
    // Get time from arrival time
    //NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    //[outputFormatter setDateFormat:@"h:mm a"];
    //[outputFormatter stringFromDate: localArrivalTime.date];

    
    // Get hour and minute in 24hr clock
    //NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"HH"];
//    NSString *hour = [NSString stringWithFormat:@"%@",
//                   [df stringFromDate: localArrivalTime.date ]];
//    
//    [df setDateFormat:@"mm"];
//    NSString *minute = [NSString stringWithFormat:@"%@",
//                     [df stringFromDate: localArrivalTime.date ]];
//    // Build new time in proper timezone
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    [comps setHour: [hour intValue]];
//    [comps setMinute: [minute intValue]];
//    [comps setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Tokyo"]];
//    NSDate *ts = [[NSCalendar currentCalendar] dateFromComponents:comps];
//    //NSLog(@"Created date %@", ts);
//    
    

    
    
//    NSDate* ts_utc = localArrivalTime.date;
//    
//    NSDateFormatter* df_utc = [[NSDateFormatter alloc] init];
//    [df_utc setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
//    [df_utc setDateFormat:@"yyyy.MM.dd 'at' HH:mm:ss zzz"];
//    
////    NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
////    [df_local setTimeZone:[NSTimeZone timeZoneWithName:@"PST"]];
////    [df_local setDateFormat:@"yyyy.MM.dd 'at' HH:mm:ss zzz"];
//
//    NSDateFormatter* df_est = [[NSDateFormatter alloc] init];
//    [df_est setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
//    [df_est setDateFormat:@"yyyy.MM.dd 'at' HH:mm:ss zzz"];
//
//
//    NSString* ts_est_string = [df_est stringFromDate:ts_utc];
//    NSString* ts_utc_string = [df_utc stringFromDate:ts_utc];
////    NSString* ts_local_string = [df_local stringFromDate:ts_utc];
//    
//    
////    NSLog(@"GMT: %@", ts_utc_string);
////    NSLog(@"PST: %@", ts_local_string);
////    NSLog(@"EST: %@", ts_est_string);
}

@end
