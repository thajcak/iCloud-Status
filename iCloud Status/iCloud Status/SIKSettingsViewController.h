//
//  SIKSettingsViewController.h
//  iCloud Status
//
//  Created by Thomas Hajcak on 12/27/12.
//  Copyright (c) 2012 Simple Ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SIKSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *versionNumber;

- (IBAction)closeSettings:(id)sender;

- (IBAction)togglePushNotifications:(id)sender;
@end
