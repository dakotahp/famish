//
//  TimezonePickerViewController.h
//  Famish
//
//  Created by dakotah on 12/4/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#import "RootViewController.h"

@interface TimezonePickerViewController : UITableViewController <UISearchBarDelegate>

@property (nonatomic, strong) NSArray *timeZones;
@property (nonatomic, strong) NSMutableArray *timeZonesSearched;

@end
