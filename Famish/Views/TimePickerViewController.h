//
//  TimePickerViewController.h
//  Famish
//
//  Created by dakotah on 12/4/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

@interface TimePickerViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIDatePicker *destinationTime;
@property (nonatomic, strong) IBOutlet UIButton *closeButton;

-(IBAction)setTime:(id)sender;

@end
