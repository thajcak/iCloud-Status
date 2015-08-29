//
//  SIKSettingsViewController.m
//  iCloud Status
//
//  Created by Thomas Hajcak on 12/27/12.
//  Copyright (c) 2012 Simple Ink. All rights reserved.
//

#import "SIKSettingsViewController.h"

//#import "UAPush.h"

@interface SIKSettingsViewController ()
{
    NSMutableArray *_settingsMenuArray;
}

@end

@implementation SIKSettingsViewController

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
    
    [_versionNumber setText:[NSString stringWithFormat:@"%@ %@ (%@)", NSLocalizedString(@"Version", @"version"), [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![USER_DEFAULTS valueForKey:@"PUSH OPTION SET"]) {
        [USER_DEFAULTS setBool:YES forKey:@"PUSH OPTION SET"];
        [USER_DEFAULTS synchronize];
//        [[UAPush shared] setPushEnabled:NO];
    }
    
    [self updateTableDataSource];
    [_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateTableDataSource
{
    _settingsMenuArray = [NSMutableArray array];
    
    [_settingsMenuArray addObject:@"SupportCell"];
    
    [_settingsMenuArray addObject:@"ReportBugsCell"];
    
//    [_settingsMenuArray addObject:@"SupportPushCell"];
    
    if ([USER_DEFAULTS boolForKey:@"appUpdateAvailable"]) {
        [_settingsMenuArray addObject:@"UpdateCell"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_settingsMenuArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [_settingsMenuArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if ([cellIdentifier isEqualToString:@"ProcessingCell"]) {
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell viewWithTag:2];
        [activityIndicator startAnimating];
    }
    else if ([cellIdentifier isEqualToString:@"SupportPushCell"]) {
        UISwitch *pushSwitch = (UISwitch *)[cell viewWithTag:1];
//        if ([[UAPush shared] pushEnabled]) {
//            [pushSwitch setOn:YES];
//        } else {
//            [pushSwitch setOn:NO];
//        }
    }
    else if ([cellIdentifier isEqualToString:@"SupportCell"]) {
        UIImageView *alert = (UIImageView *)[cell viewWithTag:2];
        
        if ([USER_DEFAULTS boolForKey:@"HAS SUPPORT PUSH"]) {
            [alert setAlpha:1.0f];
        } else {
            [alert setAlpha:0.0f];
        }
    }
    else if ([cellIdentifier isEqualToString:@"UpdateCell"]) {
        UILabel *versionLabel = (UILabel *)[cell viewWithTag:2];
        [versionLabel setText:[USER_DEFAULTS valueForKey:@"appStoreVersion"]];
    }
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [[tableView cellForRowAtIndexPath:indexPath] reuseIdentifier];
    
    if ([cellIdentifier isEqualToString:@"UpdateCell"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[USER_DEFAULTS valueForKey:@"appUpdateUrl"]]];
    } else if ([cellIdentifier isEqualToString:@"SupportCell"]) {
        [USER_DEFAULTS setBool:NO forKey:@"HAS SUPPORT PUSH"];
        [USER_DEFAULTS synchronize];
//        [[Helpshift sharedInstance] showSupport:self];
    } else if ([cellIdentifier isEqualToString:@"ReportBugsCell"]) {
//        [[Helpshift sharedInstance] reportIssue:self];
    }
}

#pragma mark - Mail Compose Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
        case MFMailComposeResultFailed:
        case MFMailComposeResultSaved:
        case MFMailComposeResultSent:
            [controller dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Actions

- (IBAction)closeSettings:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)togglePushNotifications:(id)sender
{
    UISwitch *notificationsSwitch = (UISwitch *)sender;
    
    if (notificationsSwitch.isOn) {
//        [[UAPush shared] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//        [[UAPush shared] setPushEnabled:YES];
    } else {
//        [[UAPush shared] setPushEnabled:NO];
    }
}

@end
