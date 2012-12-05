//
//  ViewController.h
//  Famish
//
//  Created by Francisco Flores on 11/27/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#define DEFAULTMORNINGHOUR 8;

#import "TimeZones.h"

@class TimezonePickerViewController,
       TimePickerViewController;

@interface RootViewController : UITableViewController <UITableViewDelegate>

//@property (strong, nonatomic) IBOutlet UITextField *departureTimeZone;
//@property (strong, nonatomic) IBOutlet UITextField *arrivalTimeZone;
@property (strong, nonatomic) IBOutlet UIDatePicker *localArrivalTime;

@property (strong, nonatomic) IBOutlet UITableViewCell *departureTimeZone;
@property (strong, nonatomic) IBOutlet UITableViewCell *destinationTimeZone;

@property (strong, nonatomic) TimeZones *timeConversion;

// Views
@property (strong, nonatomic) TimezonePickerViewController *timeZonePicker;
@property (strong, nonatomic) TimePickerViewController *timePicker;

-(IBAction)showTimeZonePicker:(id)sender;
-(IBAction)calculate: (id)sender;

@end
