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

@synthesize timeZones;

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
	//for (NSString *name in [timeZones sortedArrayUsingSelector:@selector(compare:)])
	//{
		//NSLog(@"%@",name);
	//}
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

@end
