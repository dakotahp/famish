//
//  ViewController.h
//  Famish
//
//  Created by Francisco Flores on 11/27/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#define DEFAULTMORNINGHOUR 8;

#import "TimeZones.h"

@class TimezonePickerViewController;

@interface RootViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *departureTimeZone;
@property (strong, nonatomic) IBOutlet UITextField *arrivalTimeZone;
@property (strong, nonatomic) IBOutlet UIDatePicker *localArrivalTime;

@property (strong, nonatomic) IBOutlet UIButton *depatureTimeZoneButton;
@property (strong, nonatomic) IBOutlet UIButton *destinationTimeZoneButton;

@property (strong, nonatomic) TimeZones *timeConversion;

// View
@property (nonatomic) TimezonePickerViewController *timeZonePicker;


-(IBAction)showTimeZonePicker:(id)sender;
-(IBAction)calculate: (id)sender;

@end
