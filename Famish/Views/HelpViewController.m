//
//  HelpViewController.m
//  Famish
//
//  Created by Francisco Flores on 2/24/13.
//  Copyright (c) 2013 adr.enal.in Groupe. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

@synthesize headerLabel;
@synthesize descriptionLabel;

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
    
    // Localize
    self.title = NSLocalizedString(@"HELP", nil);
    headerLabel.text = NSLocalizedString(@"HOWDOESITWORK", nil);
    descriptionLabel.text = NSLocalizedString(@"HOWDOESITWORKDESCRIPTION", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
