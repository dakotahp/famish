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

@synthesize timeZones, timeZonesSearched;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    timeZones = [NSTimeZone knownTimeZoneNames];
    timeZonesSearched = (NSMutableArray *)timeZones;
    
	//for (NSString *name in [timeZones sortedArrayUsingSelector:@selector(compare:)])
	//{
		//NSLog(@"%@",name);
	//}
    //searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [timeZones count];
}

- (NSString *)timezoneToLocation: (NSString *)timeZone {
    NSArray *timezoneChunks = [timeZone componentsSeparatedByString: @"/"];
    NSString *timezoneParsed = [timezoneChunks objectAtIndex: timezoneChunks.count - 1];
    return [timezoneParsed stringByReplacingOccurrencesOfString:@"_" withString:@" "];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"TimeZoneCell"];
    
    cell.textLabel.text = [self timezoneToLocation:[timeZones objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text = [[NSTimeZone timeZoneWithName: [timeZones objectAtIndex:indexPath.row]] abbreviation];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]);
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DepartureTimeZoneChosen" object:[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {

}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
    //Remove all objects first.
    //[timeZonesSearched removeAllObjects];
    
    if([searchText length] > 0) {
        //searching = YES;
        //letUserSelectRow = YES;
        //self.tableView.scrollEnabled = YES;
        [self searchTableView: theSearchBar];
    }
//    else
//    {
//        searching = NO;
//        letUserSelectRow = NO;
//        self.tableView.scrollEnabled = NO;
//    }
    
    [self.tableView reloadData];
}

- (void) searchTableView: (UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in timeZones)
    {
        //NSArray *array = [dictionary objectForKey:@"Countries"];
        //[searchArray addObjectsFromArray:array];
        NSLog(@"%@", dictionary);
    }
    
    for (NSString *sTemp in searchArray)
    {
        NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (titleResultsRange.length > 0)
            [timeZonesSearched addObject:sTemp];
    }
    
    searchArray = nil;
}


@end
