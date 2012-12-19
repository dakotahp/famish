//
//  ViewController.h
//  Famish
//
//  Created by Francisco Flores on 11/27/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#define DEFAULTMORNINGHOUR 8;

#import "TimeZones.h"
#import "EventController.h"
#import "PrettyKit/PrettyKit.h"

@class TimezonePickerViewController,
       TimePickerViewController;

@interface RootViewController : UITableViewController <UITableViewDelegate, UIActionSheetDelegate>

// Inputs
@property (strong, nonatomic) IBOutlet UITableViewCell *departureTimeZone;
@property (strong, nonatomic) IBOutlet UITableViewCell *destinationTimeZone;
@property (strong, nonatomic) IBOutlet UITableViewCell *destinationTime;

// Results
@property (strong, nonatomic) IBOutlet UITableViewCell *fastStart;
@property (strong, nonatomic) IBOutlet UITableViewCell *fastEnd;

// Models
@property (strong, nonatomic) TimeZones *timeConversion;

// Views
@property (strong, nonatomic) TimezonePickerViewController *timeZonePicker;
@property (strong, nonatomic) TimePickerViewController *timePicker;

-(void)recalculate;

// Action sheet
@property (nonatomic, retain) EventController *eventController;
@property NSString *actionSheetCalendarTitle;
- (IBAction)showActionSheet:(id)sender;

@end
