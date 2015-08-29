//
//  SIKViewController.h
//  iCloud Status
//
//  Created by Thomas Hajcak on 12/24/12.
//  Copyright (c) 2012 Simple Ink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIKViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *flipsideView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIButton *toggleFlipsideButton;
@property (strong, nonatomic) IBOutlet UILabel *lastUpdateLabel;

@property (strong, nonatomic) IBOutlet UIButton *refreshButton;
@property (strong, nonatomic) IBOutlet UILabel *supportAlertLabel;


- (void)updateStatus;

- (IBAction)toggleFlipside:(id)sender;
- (IBAction)refreshStatus:(id)sender;
- (void)updateSupportFeedbackBadgeAnimated:(BOOL)animated;

@end