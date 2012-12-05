//
//  TimePickerViewController.m
//  Famish
//
//  Created by dakotah on 12/4/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#import "TimePickerViewController.h"

@implementation TimePickerViewController

@synthesize destinationTime, closeButton;

-(IBAction)setTime:(id)sender
{
    // Post notification with date chosen
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DestinationTimeChosen" object:destinationTime.date];
}

@end
