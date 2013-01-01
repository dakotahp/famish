//
//  ViewController.m
//  Famish
//
//  Created by Francisco Flores on 11/27/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#import "RootViewController.h"
#import "TimezonePickerViewController.h"
#import "TimePickerViewController.h"
#import "PrettyKit.h"
#import <StoreKit/StoreKit.h>
#import "FamishInAppPurchaseHelper.h"
#import "UIAlertView+Callback.h"
#import <MBProgressHUD/MBProgressHUD.h>


@interface RootViewController ()
@end

@implementation RootViewController {
    NSNumberFormatter *_priceFormatter;
    NSArray *_products;
}

@synthesize timeConversion,
            destinationTimeZone,
            departureTimeZone,
            destinationTime,
            timeZonePicker,
            timePicker,
            fastStart,
            fastEnd,
            actionSheetCalendarTitle,
            eventController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create instance of Time Zone Picker
    timeZonePicker = [[TimezonePickerViewController alloc] init];
    timeZonePicker = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeZonePicker"];
    
    // Create instance of Time Picker
    timePicker = [[TimePickerViewController alloc] init];
    timePicker = [self.storyboard instantiateViewControllerWithIdentifier:@"TimePicker"];
    timePicker.destinationTime.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Tokyo"];
    
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
    
    // Dump all known timezones
//    NSArray *timezoneNames = [NSTimeZone knownTimeZoneNames];
//	for (NSString *name in
//		 [timezoneNames sortedArrayUsingSelector:@selector(compare:)])
//	{
//		//NSLog(@"%@",name);
//	}
//    NSArray *abbrev = [NSTimeZone abbreviationDictionary];
//	for(NSString *name in abbrev)
//	{
//		//NSLog(@"%@",name);
//	}
    
    
    // Retrieve in-app purchase
    [[FamishInAppPurchaseHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            // Hide any HUD that may be modal
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            // Send notification
            [[NSNotificationCenter defaultCenter] postNotificationName:@"InAppPurchasesLoaded" object:nil];
        }
    }];
    
    [self recalculate];
}

-(void)_prepProducts {
    // Set price formatter
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    SKProduct *product = (SKProduct *) _products[0];
    [_priceFormatter setLocale: product.priceLocale];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)recalculate
{    
    // Set cell labels with human readable format
    //departureTimeZone.detailTextLabel.text = [timeConversion timezoneToLocation: timeConversion.departureTimeZone];
    //destinationTimeZone.detailTextLabel.text = [timeConversion timezoneToLocation: timeConversion.destinationTimeZone];
    departureTimeZone.detailTextLabel.text = timeConversion.departureTimeZoneLabel;
    destinationTimeZone.detailTextLabel.text = timeConversion.destinationTimeZoneLabel;
    
    // Set fast schedule labels
    fastStart.detailTextLabel.text = timeConversion.fastStartString;
    fastEnd.detailTextLabel.text   = timeConversion.fastEndString;
}

#pragma mark - Action Sheet Methods

- (IBAction)showActionSheet:(id)sender
{
    // Skirt slow network issue and just check user defaults if product purchased
    BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:@"com.adr.enal.in.famish.pro"];
    
    // Check if purchased via NSUserDefaults
    if (productPurchased)
    {
        [self showReminderActionSheet];
        return;
    }
    // Check if products not loaded via viewLoad request
    else if (_products == nil || _products[0] == nil)
    {
        // Products haven't loaded yet so add listener to notification and show HUD
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivePurchasesLoadedNotifications:)
                                                     name:@"InAppPurchasesLoaded"
                                                   object:nil];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading In-App Purchase";
        return;
    }
    // Products HAVE loaded, let's check officially
    else {
        SKProduct *product = _products[0];
        
        // If upgrade purchased
        if ([[FamishInAppPurchaseHelper sharedInstance] productPurchased:product.productIdentifier])
        {
            [self showReminderActionSheet];
        }
        // Not purchased, let's ask them
        else
        {
            NSLog(@"Buying %@...", product.productIdentifier);
            
            // Alert user that the reminder feature is for pro users
            [[[UIAlertView alloc]
              initWithTitle:@"Upgrade Required"
              message:@"Adding reminders to your calendar requires upgrading."
              completionBlock:^(NSUInteger buttonIndex, UIAlertView *alertView)
              {
                  
                  // Run [[FamishInAppPurchaseHelper sharedInstance] buyProduct:product] on main thread
                  [[FamishInAppPurchaseHelper sharedInstance] performSelectorOnMainThread:@selector(buyProduct:) withObject:product waitUntilDone:YES];
              }
              cancelButtonTitle:@"Okay"
              otherButtonTitles:nil]
             show
             ];
        }
    }
}

// Canonical method for rendering action sheet for reminders
- (void)showReminderActionSheet
{
    NSString *actionSheetTitle = @"Save Fasting Schedule To Calendar";
    actionSheetCalendarTitle = @"Add Reminders";
    NSString *cancelTitle = @"Cancel";
    
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
    if ([buttonTitle isEqualToString: actionSheetCalendarTitle]) {
        eventController.startDate = timeConversion.fastStart;
        eventController.endDate   = timeConversion.fastEnd;
        [eventController save];
    }
}

#pragma mark - Table View Delegates

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [[tableView cellForRowAtIndexPath:indexPath] reuseIdentifier];
 
    // Departure time zone cell - Show time zone picker view
    if( [identifier isEqualToString: @"DepartureTimeZone"] )
    {
        timeZonePicker.whoCalled = @"DepartureTimeZoneChosen";
        timeZonePicker.destinationTimeZone = timeConversion.departureTimeZone;
        [self presentViewController:timeZonePicker animated:YES completion:nil];
    }
    
    // Destination time zone cell - Show time zone picker view
    if( [identifier isEqualToString: @"DestinationTimeZone"] )
    {
        timeZonePicker.whoCalled = @"DestinationTimeZoneChosen";
        timeZonePicker.destinationTimeZone = timeConversion.destinationTimeZone;
        [self presentViewController:timeZonePicker animated:YES completion:nil];
    }
    
    // Destination time cell - Show time picker view
    if( [identifier isEqualToString: @"DestinationTime"] )
    {
        timePicker.destinationTimeZone = timeConversion.destinationTimeZone;
        timePicker.destinationTimeZoneLabel = timeConversion.destinationTimeZoneLabel;
        [self presentViewController:timePicker animated:YES completion:nil];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Event Notifications
- (void) receiveTimeZoneChosenNotifications:(NSNotification *) notification
{
    if ([notification name] == @"DepartureTimeZoneChosen")
    {
        NSDictionary *payload = [notification object];

        timeConversion.departureTimeZone = [payload objectForKey:@"timezone"];
        timeConversion.destinationTimeZoneLabel = [payload objectForKey:@"label"];
        [timeZonePicker dismissViewControllerAnimated:YES completion:nil];
        
    }
    if ([notification name] == @"DestinationTimeZoneChosen")
    {
        NSDictionary *payload = [notification object];

        [timeZonePicker dismissViewControllerAnimated:YES completion:nil];
        timeConversion.destinationTimeZone = [payload objectForKey:@"timezone"];
        timeConversion.destinationTimeZoneLabel = [payload objectForKey:@"label"];
    }
    [self recalculate];
}

- (void) receiveTimeChosenNotification:(NSNotification *) notification
{
    timeConversion.destinationArrivalTime = [notification object];
    // Set cell label for arrival time
    destinationTime.detailTextLabel.text = timeConversion.arrivalTimeFormatted;
    // Close view
    [timePicker dismissViewControllerAnimated:YES completion:nil];
    // Receive date object from notification
    timeConversion.destinationArrivalTime = [notification object];
    // Recalculate
    [self recalculate];
}

- (void)productPurchased:(NSNotification *)notification
{
    NSString *productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            *stop = YES;
        }
    }];
    
    eventController.startDate = timeConversion.fastStart;
    eventController.endDate   = timeConversion.fastEnd;
    [eventController save];
}

- (void)receivePurchasesLoadedNotifications: (NSNotification *)aNotification
{
    [self showReminderActionSheet];
}

- (void)dealloc {
    
}

@end
