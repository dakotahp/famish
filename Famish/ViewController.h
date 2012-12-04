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

@property (strong, nonatomic) IBOutlet UIButton *thereTimeZone;

@property (strong, nonatomic) NSDate *departureTime;
@property (strong, nonatomic) NSDate *arrivalTime;

@property (strong, nonatomic) TimeZones *timeConversion;

@property (nonatomic) NSInteger morningHour;

-(IBAction)calculate: (id)sender;

@end
