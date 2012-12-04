//
//  ViewController.h
//  Famish
//
//  Created by Francisco Flores on 11/27/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#import "TimeZones.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *departureTimeZone;
@property (strong, nonatomic) IBOutlet UITextField *arrivalTimeZone;
@property (strong, nonatomic) IBOutlet UIDatePicker *localArrivalTime;

@property (strong, nonatomic) IBOutlet UIButton *depatureTimeZoneButton;
@property (strong, nonatomic) IBOutlet UIButton *destinationTimeZoneButton;

@property (strong, nonatomic) TimeZones *timeConversion;

@property (nonatomic) NSInteger morningHour;

-(IBAction)showTimeZonePicker:(id)sender;

-(IBAction)calculate: (id)sender;

@end
