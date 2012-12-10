//
//  ViewController.m
//  Famish
//
//  Created by Francisco Flores on 11/27/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#import "RootViewController.h"
#import "TimezonePickerViewController.h"
#import "TimePickerViewController.h"


@interface RootViewController ()
@end

@implementation RootViewController

@synthesize timeConversion,
            destinationTimeZone,
            departureTimeZone,
            destinationTime,
            timeZonePicker,
            timePicker,
            fastStart,
            fastEnd;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create instance of Time Zone Picker
    timeZonePicker = [[TimezonePickerViewController alloc] init];
    timeZonePicker = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeZonePicker"];
    
    // Create instance of Time Picker
    timePicker = [[TimePickerViewController alloc] init];
    timePicker = [self.storyboard instantiateViewControllerWithIdentifier:@"TimePicker"];
    timePicker.destinationTime.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Tokyo"];
    
    // Retrieve user defaults

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger userMorningHour = [defaults integerForKey:@"morningHour"];

    // Make sure using isn't trolling and setting 0
    if (userMorningHour == 0) {
        userMorningHour = DEFAULTMORNINGHOUR;
    }
    [defaults setInteger:userMorningHour forKey:@"morningHour"];
    [defaults synchronize];
    
    // Set up defaults
    timeConversion = [[TimeZones alloc] init];
    timeConversion.hourOfMorning = userMorningHour;
    timeConversion.departureTimeZone = [NSTimeZone localTimeZone];
    timeConversion.destinationTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Tokyo"];
    timeConversion.destinationArrivalTime = [[NSDate alloc] init];
        
    // Subscribe to time zone and time picked notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTimeZoneChosenNotifications:)
                                                 name:@"DepartureTimeZoneChosen"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTimeZoneChosenNotifications:)
                                                 name:@"DestinationTimeZoneChosen"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTimeChosenNotification:)
                                                 name:@"DestinationTimeChosen"
                                               object:nil];
    
    // Dump all known timezones
//    NSArray *timezoneNames = [NSTimeZone knownTimeZoneNames];
//	for (NSString *name in
//		 [timezoneNames sortedArrayUsingSelector:@selector(compare:)])
//	{
//		//NSLog(@"%@",name);
//	}
//    NSArray *abbrev = [NSTimeZone abbreviationDictionary];
//	for(NSString *name in abbrev)
//	{
//		//NSLog(@"%@",name);
//	}
    
    [self recalculate];
}

-(void)viewDidAppear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)recalculate {
    //timeConversion.destinationArrivalTime = localArrivalTime.date;
    
    // Set cell labels with human readable format
    departureTimeZone.detailTextLabel.text = [timeConversion timezoneToLocation: timeConversion.departureTimeZone];
    destinationTimeZone.detailTextLabel.text = [timeConversion timezoneToLocation: timeConversion.destinationTimeZone];
    
    // Set destination time label
    //destinationTime.detailTextLabel.text = timeConversion.destinationArrivalTime;
    
    // Set fast schedule labels
    fastStart.detailTextLabel.text = timeConversion.fastStart;
    fastEnd.detailTextLabel.text   = timeConversion.fastEnd;

}

#pragma mark - Table View Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [[tableView cellForRowAtIndexPath:indexPath] reuseIdentifier];
 
    // Departure time zone cell - Show time zone picker view
    if( [identifier isEqualToString: @"DepartureTimeZone"] )
    {
        timeZonePicker.whoCalled = @"DepartureTimeZoneChosen";
        timeZonePicker.destinationTimeZone = timeConversion.departureTimeZone;
        [self presentViewController:timeZonePicker animated:YES completion:nil];
    }
    
    // Destination time zone cell - Show time zone picker view
    if( [identifier isEqualToString: @"DestinationTimeZone"] )
    {
        timeZonePicker.whoCalled = @"DestinationTimeZoneChosen";
        timeZonePicker.destinationTimeZone = timeConversion.destinationTimeZone;
        [self presentViewController:timeZonePicker animated:YES completion:nil];
    }
    
    // Destination time cell - Show time picker view
    if( [identifier isEqualToString: @"DestinationTime"] )
    {
        timePicker.destinationTimeZone = timeConversion.destinationTimeZone;
        [self presentViewController:timePicker animated:YES completion:nil];
    }
}

#pragma mark - Event Notifications
- (void) receiveTimeZoneChosenNotifications:(NSNotification *) notification
{
    // Set text of label
    if ([notification name] == @"DepartureTimeZoneChosen") {
        departureTimeZone.detailTextLabel.text = [[notification object] name];
        [timeZonePicker dismissViewControllerAnimated:YES completion:nil];
        timeConversion.departureTimeZone = [notification object];
    }
    if ([notification name] == @"DestinationTimeZoneChosen") {
        destinationTimeZone.detailTextLabel.text = [[notification object] name];
        [timeZonePicker dismissViewControllerAnimated:YES completion:nil];
        timeConversion.destinationTimeZone = [notification object];
    }
    [self recalculate];
}

- (void) receiveTimeChosenNotification:(NSNotification *) notification
{
    timeConversion.destinationArrivalTime = [notification object];
    // Set cell label for arrival time
    destinationTime.detailTextLabel.text = timeConversion.arrivalTimeFormatted;
    // Close view
    [timePicker dismissViewControllerAnimated:YES completion:nil];
    // Receive date object from notification
    timeConversion.destinationArrivalTime = [notification object];
    // Recalculate
    [self recalculate];
}

@end
