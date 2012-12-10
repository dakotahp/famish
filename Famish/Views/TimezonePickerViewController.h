//
//  TimezonePickerViewController.h
//  Famish
//
//  Created by dakotah on 12/4/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#import "RootViewController.h"

@interface TimezonePickerViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSArray *timeZones;
@property (nonatomic, strong) NSMutableArray *timeZonesFiltered;
@property (nonatomic, strong) NSString *whoCalled;
@property (nonatomic, strong) NSTimeZone *destinationTimeZone;

@property (nonatomic, strong) IBOutlet UISearchBar *timezoneSearchBar;

@end
