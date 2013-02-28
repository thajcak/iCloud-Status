//
//  SIKSettingsViewController.m
//  iCloud Status
//
//  Created by Thomas Hajcak on 12/27/12.
//  Copyright (c) 2012 Simple Ink. All rights reserved.
//

#import "SIKSettingsViewController.h"
#import "HSLUpdateChecker.h"
#import "Helpshift.h"

@interface SIKSettingsViewController ()
{
    NSMutableArray *_settingsMenuArray;
    
    BOOL _isPurchasing;
    BOOL _isRestoring;
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
    
    _isPurchasing = [USER_DEFAULTS boolForKey:@"isMakingPurchase"];
    _isRestoring = [USER_DEFAULTS boolForKey:@"isRestoringPurchase"];
    
    [self updateTableDataSource];
    [_tableView reloadData];
    
    if ([MKStoreManager isFeaturePurchased:@"remove_ads"]) {
        [_restoreAdRemovalButton removeFromSuperview];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:_tableView
                                             selector:@selector(reloadData)
                                                 name:kProductFetchedNotification
                                               object:nil];
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
    
    [_settingsMenuArray addObject:@"RateCell"];
    
    [_settingsMenuArray addObject:@"SupportCell"];
    
    [_settingsMenuArray addObject:@"ReportBugsCell"];
    
    if ([USER_DEFAULTS boolForKey:@"appUpdateAvailable"]) {
        [_settingsMenuArray addObject:@"UpdateCell"];
    }
    
    if (_isPurchasing) {
        [_settingsMenuArray addObject:@"ProcessingCell"];
    } else if ([MKStoreManager isFeaturePurchased:@"remove_ads"]) {
        [_settingsMenuArray addObject:@"DonateCell"];
    } else {
        [_settingsMenuArray addObject:@"RemoveAdsCell"];
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

    if ([cellIdentifier isEqualToString:@"RemoveAdsCell"]) {
        if ([[[MKStoreManager sharedManager] pricesDictionary] valueForKey:@"remove_ads"] != nil) {
            UILabel *priceLabel = (UILabel *)[cell viewWithTag:2];
            [priceLabel setText:[[[MKStoreManager sharedManager] pricesDictionary] valueForKey:@"remove_ads"]];
        }
    } else if ([cellIdentifier isEqualToString:@"ProcessingCell"]) {
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell viewWithTag:2];
        [activityIndicator startAnimating];
    }
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [[tableView cellForRowAtIndexPath:indexPath] reuseIdentifier];
    
    if ([cellIdentifier isEqualToString:@"RemoveAdsCell"]) {
        [self purchaseRemoveAds:indexPath];
    } else if ([cellIdentifier isEqualToString:@"DonateCell"]) {
        [self makeDonation:indexPath];
    } else if ([cellIdentifier isEqualToString:@"UpdateCell"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[USER_DEFAULTS valueForKey:@"updateUrl"]]];
    } else if ([cellIdentifier isEqualToString:@"RateCell"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Simple+Ink&id=590244968"]];
    } else if ([cellIdentifier isEqualToString:@"SupportCell"]) {
        [[Helpshift sharedInstance] showSupport:self];
    } else if ([cellIdentifier isEqualToString:@"ReportBugsCell"]) {
        [[Helpshift sharedInstance] reportIssue:self];
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

#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:actionSheet.tag inSection:0];
    
    if ((buttonIndex+1) != [actionSheet numberOfButtons]) {
        if (!_isPurchasing) {
            _isPurchasing = YES;
            [USER_DEFAULTS setBool:_isPurchasing forKey:@"isMakingPurchase"];
            [USER_DEFAULTS synchronize];
            
            [self updateTableDataSource];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            NSString *featureId;
            switch (buttonIndex) {
                case 0:
                    featureId = @"donation_tier_1";
                    break;
                case 1:
                    featureId = @"donation_tier_2";
                    break;
            }
            
            [[MKStoreManager sharedManager] buyFeature:featureId
                                            onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) {
                                                _isPurchasing = NO;
                                                [USER_DEFAULTS setBool:_isPurchasing forKey:@"isMakingPurchase"];
                                                [USER_DEFAULTS synchronize];
                                                [self updateTableDataSource];
                                                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
                                                [YRDropdownView showDropdownInView:self.view
                                                                             title:NSLocalizedString(@"Settings - Donation Received", @"Donation Received")
                                                                            detail:NSLocalizedString(@"Settings - Donation Received Thanks", @"Thank you for your support")
                                                                             image:nil
                                                                   backgroundImage:[UIImage imageNamed:@"bg-gray.png"]
                                                                          animated:YES
                                                                         hideAfter:4.0f];
                                            }
                                           onCancelled:^{
                                               _isPurchasing = NO;
                                               [USER_DEFAULTS setBool:_isPurchasing forKey:@"isMakingPurchase"];
                                               [USER_DEFAULTS synchronize];
                                               [self updateTableDataSource];
                                               [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
                                           }];
        }
    } else {
        [self updateTableDataSource];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

#pragma mark - Actions

- (IBAction)closeSettings:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)restoreAdRemoval:(id)sender
{
    if (!_isPurchasing && !_isRestoring) {
        _isRestoring = YES;
        [USER_DEFAULTS setBool:_isRestoring forKey:@"isRestoringPurchase"];
        [USER_DEFAULTS synchronize];
        
        [_restoreAdRemovalButton setEnabled:NO];
        
        [[MKStoreManager sharedManager] restorePreviousTransactionsOnComplete:^
         {
             _isRestoring = NO;
             [USER_DEFAULTS setBool:_isRestoring forKey:@"isRestoringPurchase"];
             [USER_DEFAULTS synchronize];
             
             [_restoreAdRemovalButton removeFromSuperview];
             
             [self updateTableDataSource];
             [_tableView reloadData];
             [YRDropdownView showDropdownInView:self.view
                                          title:NSLocalizedString(@"Settings - Ads Removed", @"Ads Removed")
                                         detail:NSLocalizedString(@"Settings - Ads Removed Thanks", @"Thank you for your support")
                                          image:nil
                                backgroundImage:[UIImage imageNamed:@"bg-gray.png"]
                                       animated:YES
                                      hideAfter:4.0f];
         }
                                                                      onError:^(NSError *error)
         {
             _isRestoring = NO;
             [USER_DEFAULTS setBool:_isRestoring forKey:@"isRestoringPurchase"];
             [USER_DEFAULTS synchronize];
             
             [_restoreAdRemovalButton setEnabled:YES];
             
             [YRDropdownView showDropdownInView:self.view
                                          title:[error localizedFailureReason]
                                         detail:[error localizedDescription]
                                          image:nil
                                backgroundImage:[UIImage imageNamed:@"bg-yellow.png"]
                                       animated:YES
                                      hideAfter:4.0f];
         }];
    }
}

- (void)showFeedback:(NSIndexPath *)indexPath
{
    
    if ([MFMailComposeViewController canSendMail]) {
        [_settingsMenuArray replaceObjectAtIndex:indexPath.row withObject:@"EmptyCell"];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
        [mailCompose setMailComposeDelegate:self];
        [mailCompose.navigationBar setBarStyle:UIBarStyleBlack];
        [mailCompose setToRecipients:[NSArray arrayWithObject:@"thomas.hajcak@gmail.com"]];
        [mailCompose setSubject:@"iCloud Status Feedback"];
        [self presentViewController:mailCompose
                           animated:YES
                         completion:nil];
    }
}

- (void)purchaseRemoveAds:(NSIndexPath *)indexPath
{
    if (!_isPurchasing && !_isRestoring && [[[MKStoreManager sharedManager] pricesDictionary] valueForKey:@"remove_ads"] != nil) {
        _isPurchasing = YES;
        [USER_DEFAULTS setBool:_isPurchasing forKey:@"isMakingPurchase"];
        [USER_DEFAULTS synchronize];
        
        [self updateTableDataSource];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [[MKStoreManager sharedManager] buyFeature:@"remove_ads"
                                        onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) {
                                            _isPurchasing = NO;
                                            [USER_DEFAULTS setBool:_isPurchasing forKey:@"isMakingPurchase"];
                                            [USER_DEFAULTS synchronize];
                                            [self updateTableDataSource];
                                            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
                                            [YRDropdownView showDropdownInView:self.view
                                                                         title:NSLocalizedString(@"Settings - Ads Removed", @"Ads Removed")
                                                                        detail:NSLocalizedString(@"Settings - Ads Removed Thanks", @"Thanks for your support")
                                                                         image:nil
                                                               backgroundImage:[UIImage imageNamed:@"bg-gray.png"]
                                                                      animated:YES
                                                                     hideAfter:4.0f];
                                        }
                                       onCancelled:^{
                                           _isPurchasing = NO;
                                           [USER_DEFAULTS setBool:_isPurchasing forKey:@"isMakingPurchase"];
                                           [USER_DEFAULTS synchronize];
                                           [self updateTableDataSource];
                                           [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
                                       }];
    } else {
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [cell setLeft:-100.0f];
                         }
                         completion:^(BOOL isFinished){
                             [UIView animateWithDuration:0.3
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  [cell setLeft:0.0f];
                                              }
                                              completion:^(BOOL isFinished){
                                                  
                                              }];
                         }];
    }
}

- (void)makeDonation:(NSIndexPath *)indexPath
{
    [_settingsMenuArray replaceObjectAtIndex:indexPath.row withObject:@"EmptyCell"];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    UIActionSheet *donationSheet = [[UIActionSheet alloc] initWithTitle:([[[MKStoreManager sharedManager] pricesDictionary] valueForKey:@"donation_tier_1"] == nil ? NSLocalizedString(@"Settings - Donations Not Loaded", @"Donations not yet loaded") : NSLocalizedString(@"Settings - Select Donation Amount", @"Select Donation Amount"))
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:
                                    [[[MKStoreManager sharedManager] pricesDictionary] valueForKey:@"donation_tier_1"],
                                    [[[MKStoreManager sharedManager] pricesDictionary] valueForKey:@"donation_tier_2"],
                                    [[[MKStoreManager sharedManager] pricesDictionary] valueForKey:@"donation_tier_5"],
                                    [[[MKStoreManager sharedManager] pricesDictionary] valueForKey:@"donation_tier_10"],nil];
    [donationSheet setTag:indexPath.row];
    [donationSheet showInView:self.view];
}

@end
