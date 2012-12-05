//
//  TimePickerViewController.m
//  Famish
//
//  Created by dakotah on 12/4/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#import "TimePickerViewController.h"

@implementation TimePickerViewController

@synthesize destinationTime, closeButton, timeZoneLabel;

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
    self.destinationTime.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Tokyo"];
    timeZoneLabel.text = [destinationTime.timeZone name];
}

-(IBAction)setTime:(id)sender
{
    // Post notification with date chosen
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DestinationTimeChosen" object:destinationTime.date];
}

@end
