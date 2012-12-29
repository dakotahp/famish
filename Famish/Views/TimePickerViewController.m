//
//  TimePickerViewController.m
//  Famish
//
//  Created by dakotah on 12/4/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#import "TimePickerViewController.h"
#import "TimeZones.h"

@implementation TimePickerViewController

@synthesize destinationTime, closeButton, timeZoneLabel, destinationTimeZone;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }

    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    TimeZones *tz = [[TimeZones alloc] init];
    destinationTime.timeZone = destinationTimeZone;
    timeZoneLabel.text = [tz timezoneToLocation: destinationTime.timeZone];

}

#pragma mark - Notifications

-(IBAction)setTime:(id)sender
{
    // Post notification with date chosen
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DestinationTimeChosen" object:destinationTime.date];
}

@end
