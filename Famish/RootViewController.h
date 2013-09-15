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
#import "Vendor/ActionSheetPicker/ActionSheetPicker.h"


@class TimezonePickerViewController,
       TimePickerViewController;

@interface RootViewController : UIViewController <UIActionSheetDelegate>

// Buttons
@property (strong, nonatomic) IBOutlet UIButton *departureTzButton;
@property (strong, nonatomic) IBOutlet UIButton *arrivalTzButton;
@property (strong, nonatomic) IBOutlet UIButton *arrivalTime;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *calendarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *airplaneButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *helpButton;


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

@property (nonatomic, retain) AbstractActionSheetPicker *actionSheetPicker;

-(void)recalculate;

// Actions
- (IBAction)showDepartureTzPicker:(id)sender;
- (IBAction)showArrivalTzPicker:(id)sender;
- (IBAction)showArrivalTimePicker:(id)sender;

- (IBAction)backToMainView:(UIStoryboardSegue *)segue;

// Action sheet
@property (nonatomic, retain) EventController *eventController;
@property NSString *actionSheetCalendarTitle;
- (IBAction)showActionSheet:(id)sender;

@end
