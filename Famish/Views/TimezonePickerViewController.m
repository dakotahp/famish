//
//  TimezonePickerViewController.m
//  Famish
//
//  Created by dakotah on 12/4/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#import "TimezonePickerViewController.h"

@interface TimezonePickerViewController ()

@end

@implementation TimezonePickerViewController

@synthesize timeZones,
            timeZonesFiltered,
            whoCalled,
            timezoneSearchBar,
            destinationTimeZone;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    timeZones = [NSTimeZone knownTimeZoneNames];
    timeZonesFiltered = [[NSTimeZone knownTimeZoneNames] mutableCopy];
    
	//for (NSString *name in [timeZones sortedArrayUsingSelector:@selector(compare:)])
	//{
		//NSLog(@"%@",name);
	//}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [timeZonesFiltered count];
    } else {
        return [timeZones count];
    }
}

- (NSString *)timezoneToLocation: (NSString *)timeZone {
    NSArray *timezoneChunks = [timeZone componentsSeparatedByString: @"/"];
    NSString *timezoneParsed = [timezoneChunks objectAtIndex: timezoneChunks.count - 1];
    return [timezoneParsed stringByReplacingOccurrencesOfString:@"_" withString:@" "];
}

#pragma mark - Table Delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeZoneCell"];

    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TimeZoneCell"];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [timeZonesFiltered objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [[NSTimeZone timeZoneWithName: [timeZonesFiltered objectAtIndex:indexPath.row]] abbreviation];
    } else {
        cell.textLabel.text = [timeZones objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [[NSTimeZone timeZoneWithName: [timeZones objectAtIndex:indexPath.row]] abbreviation];
    }
    
    // Set checkmark if matches previously chosen TZ
    if ( [cell.textLabel.text isEqualToString: destinationTimeZone.name]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create timezone from cell text and post notification
    NSTimeZone *tz = [NSTimeZone timeZoneWithName: [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]];
    // Set checkmark accessory
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:self.whoCalled object: tz];
}

#pragma mark - Table Search Delegates
- (void)searchBarSearchButtonClicked:(UISearchBar *)search
{
    [search resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText: [searchString stringByReplacingOccurrencesOfString:@" " withString:@"_"] // replace space with _
                               scope: [[self.searchDisplayController.searchBar scopeButtonTitles]
                       objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]
    ];
    return YES;
}

#pragma mark Content Filtering

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.timeZonesFiltered removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
    timeZonesFiltered = [NSMutableArray arrayWithArray: [timeZones filteredArrayUsingPredicate:predicate]];
}

@end
