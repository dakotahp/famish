//
//  HelpViewController.h
//  Famish
//
//  Created by Francisco Flores on 9/15/13.
//  Copyright (c) 2013 adr.enal.in Groupe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

// TODO: move app ID into plist
static NSString *appId = @"590035109";

@interface HelpViewController : UITableViewController <UITableViewDelegate, MFMailComposeViewControllerDelegate>

@end
