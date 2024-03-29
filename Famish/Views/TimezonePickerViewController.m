//
//  TimezonePickerViewController.m
//  Famish
//
//  Created by dakotah on 12/4/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#import "TimezonePickerViewController.h"
#import "NSString+Slugs.h"

@interface TimezonePickerViewController () {
}

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

    timeZonesFiltered = timeZones = [[NSMutableArray alloc] init];
    [self loadCustomCities];

    [self search:@"a"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (NSArray *)loadSystemTimeZones
{
    //timeZonesFiltered = [[NSTimeZone knownTimeZoneNames] mutableCopy];
    NSArray *systemTimeZones = [NSTimeZone knownTimeZoneNames];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	for (NSString *name in systemTimeZones) //[timeZones sortedArrayUsingSelector:@selector(compare:)])
	{
        [tempArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: name, @"name", name, @"timezone", nil]];
	}
    return tempArray;
}

- (void)loadCustomCities
{
    // Pull in timezones from JSON file
    NSError *err;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Timezones" ofType:@"json"];
    NSDictionary *timeZonesFromJson = [NSJSONSerialization
                          JSONObjectWithData: [NSData dataWithContentsOfFile:filePath]
                          options:kNilOptions
                          error:&err];

    if (err) {
        NSLog(@"JSON import error! %@", err);
    }
    
    // Sort dictionary by keys
    NSArray *sortedKeys = [[timeZonesFromJson allKeys] sortedArrayUsingSelector: @selector(compare:)];
    // Loop over generated dictionary
    for (NSString *key in sortedKeys) {
        [timeZones addObject: [NSDictionary dictionaryWithObjectsAndKeys: [timeZonesFromJson objectForKey:key], @"timezone", key, @"name", nil]];
    }
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

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
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
    return [timezoneParsed fromSlug];
}

#pragma mark - Table Delegates

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeZoneCell"];

    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TimeZoneCell"];
    }

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSString *tzName = [[timeZonesFiltered objectAtIndex:indexPath.row] objectForKey:@"name"];
        NSString *tzCode = [[timeZonesFiltered objectAtIndex:indexPath.row] objectForKey:@"timezone"];
        cell.textLabel.text = tzName;
        cell.detailTextLabel.text = tzCode; //[[NSTimeZone timeZoneWithName: tzCode] abbreviation];
    } else {
        NSString *tzName = [[timeZones objectAtIndex:indexPath.row] objectForKey:@"name"];
        NSString *tzCode = [[timeZones objectAtIndex:indexPath.row] objectForKey:@"timezone"];
        cell.textLabel.text = tzName;
        cell.detailTextLabel.text = tzCode; //[[NSTimeZone timeZoneWithName: tzCode] abbreviation];
    }
    
    // Set checkmark if matches previously chosen TZ
    if ( [cell.textLabel.text isEqualToString: destinationTimeZone.name]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create timezone from cell text and post notification
    NSTimeZone *tz = [NSTimeZone timeZoneWithName: [[[tableView cellForRowAtIndexPath:indexPath] detailTextLabel] text]];
    // Set checkmark accessory
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    // Send both time AND actual destination text
    NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:
                             tz, @"timezone",
                             [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text], @"label",
                             nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:self.whoCalled object: payload];
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
-(BOOL)  searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText: searchString // replace space with _
                               scope: [[self.searchDisplayController.searchBar scopeButtonTitles]
                       objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]
    ];
    return YES;
}

// Weird timing bug making this secondary function necessary
// Seems related to [self.timeZonesFiltered removeAllObjects] perhaps running asynchonously
- (NSMutableArray *)search: (NSString *)aString
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@", aString];
    timeZonesFiltered = [NSMutableArray arrayWithArray: [timeZones filteredArrayUsingPredicate:predicate]];
    return timeZonesFiltered;
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText
                            scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.timeZonesFiltered removeAllObjects];
    // Filter the array using NSPredicate
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@", searchText];
    //timeZonesFiltered = [NSMutableArray arrayWithArray: [timeZones filteredArrayUsingPredicate:predicate]];
    timeZonesFiltered = [self search:searchText];
}

@end
