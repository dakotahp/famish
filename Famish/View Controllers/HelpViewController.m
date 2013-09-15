//
//  HelpViewController.m
//  Famish
//
//  Created by Francisco Flores on 9/15/13.
//  Copyright (c) 2013 adr.enal.in Groupe. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

#pragma mark - Table view delegate

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [[tableView cellForRowAtIndexPath:indexPath] reuseIdentifier];
    
    // Launch website
    if( [identifier isEqualToString: @"website"] )
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://famishapp.com"]];
    }
    // Follow on twitter
    else if ([identifier isEqualToString:@"twitter_follow"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/intent/user?user_id=1471332109"]];
    }
    // Tweet
    else if( [identifier isEqualToString:@"tweet"] )
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/intent/tweet?text=%40FamishApp"]];
    }
    // Email
    else if ([identifier isEqualToString:@"email"])
    {
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
            [composeViewController setMailComposeDelegate:self];
            // TODO: move email into plist
            [composeViewController setToRecipients:@[@"dakotah@viscera.la"]];
            [composeViewController setSubject:@"Famish Support Request"];
            [self presentViewController:composeViewController animated:YES completion:nil];
        }
    }
    // Launch app store
    else if( [identifier isEqualToString:@"review"] ) {
        #if TARGET_IPHONE_SIMULATOR
            NSLog(@"iTunes App Store is not supported on the iOS simulator. Unable to open App Store page.");
        #else
            NSString *templateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID";
            NSString *templateReviewURLiOS7 = @"itms-apps://itunes.apple.com/LANGUAGE/app/idAPP_ID";
        
            NSString *reviewURL = [templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", appId]];
        
            // iOS 7 needs a different templateReviewURL @see https://github.com/arashpayan/appirater/issues/131
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                reviewURL = [templateReviewURLiOS7 stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", appId]];
                reviewURL = [reviewURL stringByReplacingOccurrencesOfString:@"LANGUAGE" withString:[NSString stringWithFormat:@"%@", [[NSLocale preferredLanguages] objectAtIndex:0]]];
            }
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: reviewURL]];
            NSLog(@"launch store");
        #endif
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Mail Delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
