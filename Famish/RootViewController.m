//
//  ViewController.m
//  Famish
//
//  Created by Francisco Flores on 11/27/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#import "RootViewController.h"
#import "TimezonePickerViewController.h"
#import "UIAlertView+Callback.h"
#import <Crashlytics/Crashlytics.h>


@interface RootViewController ()
@end

@implementation RootViewController

@synthesize timeConversion,
            destinationTimeZone,
            departureTimeZone,
            destinationTime,
            timeZonePicker,
            fastStart,
            fastEnd,
            actionSheetCalendarTitle,
            eventController;
@synthesize actionSheetPicker;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Create instance of Time Zone Picker
    timeZonePicker = [[TimezonePickerViewController alloc] init];
    timeZonePicker = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeZonePicker"];

    // Create instance of EventController
    eventController = [[EventController alloc] init];

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

    // Localize elements
    [self localizeViewElements];

    [self recalculate];
}

- (void)localizeViewElements
{
    departureTimeZone.textLabel.text = NSLocalizedString(@"DEPARTURE", nil);
    destinationTimeZone.textLabel.text = NSLocalizedString(@"DESTINATION", nil);
    destinationTime.textLabel.text = NSLocalizedString(@"TIME", nil);
    fastStart.textLabel.text = NSLocalizedString(@"FASTSTART", nil);
    fastEnd.textLabel.text = NSLocalizedString(@"FASTEND", nil);
}

-(void)viewWillAppear:(BOOL)animated
{
}

- (void)viewWillDisappear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)recalculate
{
    departureTimeZone.detailTextLabel.text = timeConversion.departureTimeZoneLabel;
    destinationTimeZone.detailTextLabel.text = timeConversion.destinationTimeZoneLabel;

    // Set fast schedule labels
    fastStart.detailTextLabel.text = timeConversion.fastStartString;
    fastEnd.detailTextLabel.text   = timeConversion.fastEndString;
}

#pragma mark - Action Sheet Methods

- (IBAction)showActionSheet:(id)sender
{
    [self showReminderActionSheet];
}

// Canonical method for rendering action sheet for reminders
- (void)showReminderActionSheet
{
    NSString *actionSheetTitle = NSLocalizedString(@"SAVEFASTINGTOCALENDAR", nil);
    actionSheetCalendarTitle = NSLocalizedString(@"ADDREMINDERS", nil);
    NSString *cancelTitle = NSLocalizedString(@"CANCEL", nil);

    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:actionSheetCalendarTitle, nil];
    [actionSheet showInView:self.view];
}

// Delegate method for alert - required because category block extension requires it
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString: actionSheetCalendarTitle])
    {
        actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:NSLocalizedString(@"ARRIVALDATE", nil)
                                                          datePickerMode:  UIDatePickerModeDate
                                                            selectedDate:[NSDate date]
                                                                  target:self
                                                                  action:@selector(saveReminderEvent:)
                                                                  origin: self.view
                                                                timeZone: [NSTimeZone defaultTimeZone]];
        self.actionSheetPicker.hideCancel = NO;
        [self.actionSheetPicker showActionSheetPicker];
    }
}

- (void)saveReminderEvent:(NSDate *)aDate
{
    eventController.startDate    = timeConversion.fastStart;
    eventController.endDate      = timeConversion.fastEnd;
    eventController.reminderDate = aDate;
    [eventController save];
}

- (IBAction)showDepartureTzPicker:(id)sender {
    timeZonePicker.whoCalled = @"DepartureTimeZoneChosen";
    timeZonePicker.destinationTimeZone = timeConversion.departureTimeZone;
    [self presentViewController:timeZonePicker animated:YES completion:nil];
}

- (IBAction)showArrivalTzPicker:(id)sender {
    timeZonePicker.whoCalled = @"DestinationTimeZoneChosen";
    timeZonePicker.destinationTimeZone = timeConversion.destinationTimeZone;
    [self presentViewController:timeZonePicker animated:YES completion:nil];
}

- (IBAction)showArrivalTimePicker:(id)sender {
    actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:NSLocalizedString(@"ARRIVALTIME", nil)
                                                      datePickerMode:  UIDatePickerModeTime
                                                        selectedDate:[NSDate date]
                                                              target:self
                                                              action:@selector(receiveTimeChosen:)
                                                              origin: self.view
                                                            timeZone: timeConversion.destinationTimeZone];
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
}

#pragma mark - Event Notifications
- (void) receiveTimeZoneChosenNotifications:(NSNotification *) notification
{
    if ([[notification name] isEqual: @"DepartureTimeZoneChosen"])
    {
        NSDictionary *payload = [notification object];

        timeConversion.departureTimeZone = [payload objectForKey:@"timezone"];
        timeConversion.destinationTimeZoneLabel = [payload objectForKey:@"label"];
        [timeZonePicker dismissViewControllerAnimated:YES completion:nil];

    }
    if ([[notification name] isEqual: @"DestinationTimeZoneChosen"])
    {
        NSDictionary *payload = [notification object];

        [timeZonePicker dismissViewControllerAnimated:YES completion:nil];
        timeConversion.destinationTimeZone = [payload objectForKey:@"timezone"];
        timeConversion.destinationTimeZoneLabel = [payload objectForKey:@"label"];
    }
    [self recalculate];
}

- (void) receiveTimeChosen:(NSDate *)aDate
{
    timeConversion.destinationArrivalTime = aDate;
    // Set cell label for arrival time
    destinationTime.detailTextLabel.text = timeConversion.arrivalTimeFormatted;
    // Receive date object from notification
    timeConversion.destinationArrivalTime = aDate;
    // Recalculate
    [self recalculate];
}

- (void)dealloc {}

@end
