//
//  SIKViewController.m
//  iCloud Status
//
//  Created by Thomas Hajcak on 12/24/12.
//  Copyright (c) 2012 Simple Ink. All rights reserved.
//

#import "SIKViewController.h"
#import "SIKAppleEngine.h"
#import "UIImage+BBlock.h"

@interface SIKViewController ()
{
    SIKAppleEngine *_appleEngine;
    NSDictionary *_currentStatus;
    
    UIRefreshControl *_refreshControl;
    
    NSMutableArray *_openedViews;
    
    NSString *_alertMessage;
}
@end

@implementation SIKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _appleEngine = [[SIKAppleEngine alloc] initWithHostName:@"www.apple.com"];
    
    [_containerView.layer setCornerRadius:3.0f];
    [_containerView.layer setMasksToBounds:YES];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(updateStatus) forControlEvents:UIControlEventValueChanged];
    [_collectionView addSubview:_refreshControl];
    
    [_toggleFlipsideButton setTitle:[NSString stringWithFormat:@" %@", NSLocalizedString(@"Button - Detailed Timeline", @"View Detailed Timeline")] forState:UIControlStateNormal];
    
    [_flipsideView removeFromSuperview];
    
    _openedViews = [NSMutableArray array];
    
    [_supportAlertLabel.layer setCornerRadius:9.0f];
    [_supportAlertLabel.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_supportAlertLabel.layer setBorderWidth:3.0f];
    [_supportAlertLabel.layer setMasksToBounds:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateSupportFeedbackBadgeAnimated:NO];
}


#pragma mark - Private Methods

- (void)updateStatus
{
    [_refreshButton setEnabled:NO];
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [_refreshButton setAlpha:0.0f];
                     }
                     completion:nil];
    [_appleEngine
     currentStatus:^(NSDictionary *response)
     {
         _currentStatus = response;
         [_collectionView reloadData];
         [_tableView reloadData];
         
         [_lastUpdateLabel setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Updated", @"Updated"), [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]]];
         
         [_refreshControl endRefreshing];
         
         [UIView animateWithDuration:0.4
                          animations:^{
                              [_toggleFlipsideButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
                              [_toggleFlipsideButton setContentEdgeInsets:UIEdgeInsetsMake(4.0f, 0.0f, 0.0f, 0.0f)];
                          }];
     }
     onError:^(NSError *error)
     {
         [_refreshControl endRefreshing];

         [YRDropdownView showDropdownInView:_containerView
                                      title:[error localizedDescription]
                                     detail:nil
                                   animated:YES];
         
         _alertMessage = [error localizedDescription];
         
         [_refreshButton setEnabled:YES];
         [UIView animateWithDuration:0.4
                               delay:0.0
                             options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                          animations:^{
                              [_refreshButton setAlpha:1.0f];
                          }
                          completion:nil];
     }];
}

- (NSDictionary *)dictionaryForSection:(NSInteger)section
{
    return [[_currentStatus valueForKey:@"dashboard"] valueForKey:[[[_currentStatus valueForKey:@"dashboard"] allKeys] objectAtIndex:section]];
}

- (NSDictionary *)timelineDictionaryForRow:(NSInteger)row
{
    return [[_currentStatus valueForKey:@"detailedTimeline"] objectAtIndex:row];
}

- (NSArray *)dailyTimelineItemsForSection:(NSInteger)section
{
    NSDate *date;
    switch (section) {
        case 0:
            date = [NSDate date];
            break;
        case 1:
            date = [[NSDate date] dateByAddingDays:-1];
            break;
        case 2:
            date = [[NSDate date] dateByAddingDays:-2];
            break;
    }
    
    NSMutableArray *timelineItems = [NSMutableArray array];
    
    for (NSDictionary *timelineItem in [_currentStatus valueForKey:@"detailedTimeline"]) {
        NSDate *itemDate = [NSDate dateWithTimeIntervalSince1970:[[timelineItem valueForKey:@"epochStartDate"] doubleValue]/1000];
        if ([itemDate day] == [date day]) {
            [timelineItems addObject:timelineItem];
        }
    }
    
    return timelineItems;
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[self dictionaryForSection:section] allKeys] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[[_currentStatus valueForKey:@"dashboard"] allKeys] count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"GroupStatusHeaderCell" forIndexPath:indexPath];
    
    UILabel *headerLabel = (UILabel *)[headerView viewWithTag:1];
    [headerLabel setText:[[[_currentStatus valueForKey:@"dashboard"] allKeys] objectAtIndex:indexPath.section]];
    
    return headerView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupStatusCell" forIndexPath:indexPath];
    
    // Reset all data in the cell
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    UILabel *alert = (UILabel *)[cell viewWithTag:2];
    UIImageView *statusImageView = (UIImageView *)[cell viewWithTag:3];
    [label setText:nil];
    [alert setText:NSLocalizedString(@"System Status - No Issues", @"No Issues Reported")];
    
    NSDictionary *sectionDictionary = [self dictionaryForSection:indexPath.section];
    NSArray *dictionaryKeys = [[sectionDictionary allKeys] sortedArray];
    NSDictionary *thisSectionItem = [sectionDictionary valueForKey:[dictionaryKeys objectAtIndex:indexPath.row]];
    
    NSString *statusType = ([[thisSectionItem valueForKey:@"statusType"] count] == 0 ? @"" : [[thisSectionItem valueForKey:@"statusType"] objectAtIndex:0]);
    UIImage *statusImage = [self imageForServiceWithIdentifier:statusType];
    [statusImageView setImage:statusImage];
    
    [alert setBackgroundColor:[self colorForServiceWithIdentifier:statusType]];
    
    if ([thisSectionItem count] > 0) {
        [alert setText:[NSString stringWithFormat:@"%@: %@",
                        [[thisSectionItem valueForKey:@"statusType"] objectAtIndex:0],
                        ([[thisSectionItem valueForKey:@"usersAffected"] objectAtIndex:0] == [NSNull null] ? @"Number of Users Affected Unknown" : [[thisSectionItem valueForKey:@"usersAffected"] objectAtIndex:0])]];
    }
    
    if ([_openedViews containsObject:indexPath]) {
        [label setText:@"➧"];
        [label setTextAlignment:NSTextAlignmentRight];
        [label setRight:14.0f];
        [statusImageView setLeft:17.0f];
        [alert setLeft:statusImageView.left+2.0f];
    } else {
        [label setText:[dictionaryKeys objectAtIndex:indexPath.row]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setLeft:2.0f];
        [statusImageView setLeft:135.0f];
        [alert setLeft:statusImageView.right];
    }
    
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *textLabel = (UILabel *)[[collectionView cellForItemAtIndexPath:indexPath] viewWithTag:1];
    UILabel *alertLabel = (UILabel *)[[collectionView cellForItemAtIndexPath:indexPath] viewWithTag:2];
    UIImageView *statusImage = (UIImageView *)[[collectionView cellForItemAtIndexPath:indexPath] viewWithTag:3];
    BOOL isOpening = [_openedViews containsObject:indexPath] ? NO : YES;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:(UIViewAnimationCurveEaseInOut)
                     animations:^{
                         if (isOpening) {
                             [textLabel setRight:0.0f];
                             [statusImage setLeft:17.0f];
                             [alertLabel setLeft:statusImage.left+2.0f];
                         }
                         
                         for (NSIndexPath *openedView in [_openedViews copy]) {
                             UILabel *openedLabel = (UILabel *)[[collectionView cellForItemAtIndexPath:openedView] viewWithTag:1];
                             UILabel *openedAlert = (UILabel *)[[collectionView cellForItemAtIndexPath:openedView] viewWithTag:2];
                             UIImageView *openedStatusImage = (UIImageView *)[[collectionView cellForItemAtIndexPath:openedView] viewWithTag:3];
                             [_openedViews removeObject:openedView];
                             
                             [UIView animateWithDuration:0.1
                                                   delay:0.0
                                                 options:(UIViewAnimationCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                                              animations:^{
                                                  [openedLabel setRight:0.0f];
                                              }
                                              completion:^(BOOL isFinished){
                                                  [openedLabel setText:[[[[self dictionaryForSection:openedView.section] allKeys] sortedArray] objectAtIndex:openedView.row]];
                                                  [openedLabel setTextAlignment:NSTextAlignmentCenter];
                                                  [UIView animateWithDuration:0.3
                                                                        delay:0.0
                                                                      options:(UIViewAnimationCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                                                                   animations:^{
                                                                       [openedLabel setLeft:2.0f];
                                                                       [openedStatusImage setLeft:135.0f];
                                                                       [openedAlert setLeft:150.0f];
                                                                   }
                                                                   completion:^(BOOL isFinished){
                                                                       
                                                                   }];
                                              }];
                         }
                     }
                     completion:^(BOOL isFinished) {
                         if (isOpening) {
                             [textLabel setText:@"➧"];
                             [textLabel setTextAlignment:NSTextAlignmentRight];
                             [_openedViews addObject:indexPath];
                             [UIView animateWithDuration:0.1
                                                   delay:0.0
                                                 options:UIViewAnimationCurveEaseOut
                                              animations:^{
                                                  [textLabel setRight:14.0f];
                                              }
                                              completion:^(BOOL isFinished){
                                              }];
                         }
                     }];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_currentStatus == nil) {
        return 0;
    }
    
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 22.0f)];
    [headerLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [headerLabel setBackgroundColor:[UIColor lightGrayColor]];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setTextColor:[UIColor whiteColor]];
    [headerLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:16.0f]];
    
    switch (section) {
        case 0:
            [headerLabel setText:[NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle]];
            break;
        case 1:
            [headerLabel setText:[NSDateFormatter localizedStringFromDate:[[NSDate date] dateByAddingDays:-1] dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle]];
            break;
        case 2:
            [headerLabel setText:[NSDateFormatter localizedStringFromDate:[[NSDate date] dateByAddingDays:-2] dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle]];
            break;
    }
    
    return headerLabel;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    return footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX([[self dailyTimelineItemsForSection:section] count], 1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *thisItemMessage;
    
    if ([[self dailyTimelineItemsForSection:indexPath.section] count] > 0) {
        NSDictionary *historyItem = [[self dailyTimelineItemsForSection:indexPath.section] objectAtIndex:indexPath.row];
        thisItemMessage = [self messageForHistoryItem:historyItem];
    } else {
        thisItemMessage = NSLocalizedString(@"System Status - No Issues", @"No Issues Reported");
    }
    
    UIFont *detailsFont = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:14.0f];
    CGSize constraint = CGSizeMake(_tableView.width-38.0f, 400.0f);
    CGSize size = [thisItemMessage sizeWithFont:detailsFont constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(size.height+24.0f, 20.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Detailed Timeline Item"];
    
    UITextView *textView = (UITextView *)[cell viewWithTag:1];
    [textView setText:nil];
    
    NSString *cellText;
    if ([[self dailyTimelineItemsForSection:indexPath.section] count] > 0) {
        NSDictionary *historyItem = [[self dailyTimelineItemsForSection:indexPath.section] objectAtIndex:indexPath.row];
        cellText = [self messageForHistoryItem:historyItem];
    } else {
        if (indexPath.section == 0) {
            cellText = NSLocalizedString(@"Detailed Timeline - No Issues Today", @"No Issues Reported Today");
        } else {
            cellText = NSLocalizedString(@"Detailed Timeline - No Issues Past", @"No Issues Reported");
        }
    }
    [textView setText:cellText];
    
    return cell;
}

- (NSString *)messageForHistoryItem:(NSDictionary *)historyItem
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm zzz"];
    
    NSDate *startDate = nil;
    NSDate *endDate = nil;
    NSString *startDateString = nil;
    NSString *endDateString = nil;
    
    if (![[historyItem valueForKey:@"startDate"] isEqual:[NSNull null]]) {
        startDate = [dateFormatter dateFromString:[historyItem valueForKey:@"startDate"]];
    }
    if (![[historyItem valueForKey:@"endDate"] isEqual:[NSNull null]]) {
        endDate = [dateFormatter dateFromString:[historyItem valueForKey:@"endDate"]];
    }
    
    if (startDate != nil || endDate != nil) {
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        if (startDate != nil) {
             startDateString = [dateFormatter stringFromDate:startDate];
        }
        if (endDate != nil) {
            endDateString = [dateFormatter stringFromDate:endDate];
        }
    }
    
    NSString *thisItemMessage = [NSString stringWithFormat:@"%@%@%@\n%@%@%@",
                                 ([[historyItem valueForKey:@"messageTitle"] isEqual:[NSNull null]] ? @"" : [NSString stringWithFormat:@"%@\n", [historyItem valueForKey:@"messageTitle"]]),
                                 ([[historyItem valueForKey:@"statusType"] isEqual:[NSNull null]] ? @"" : [NSString stringWithFormat:@"%@: ", [historyItem valueForKey:@"statusType"]]),
                                 [historyItem valueForKey:@"message"],
                                 ([historyItem valueForKey:@"usersAffected"] == [NSNull null] ? @"" : [NSString stringWithFormat:@"\n%@", [historyItem valueForKey:@"usersAffected"]]),
                                 (startDateString == nil ? @"" : [NSString stringWithFormat:@"\n%@: %@", NSLocalizedString(@"Detailed Timeline - Start", @"Start"), startDateString]),
                                 (endDateString == nil ? @"" : [NSString stringWithFormat:@"\n%@: %@", NSLocalizedString(@"Detailed Timeline - End", @"End") , endDateString])];
    return thisItemMessage;
}

#pragma mark - Google AdMob Banner Delegate

//- (void)adViewDidReceiveAd:(GADBannerView *)view
//{
//    
//    if ([MKStoreManager isFeaturePurchased:@"remove_ads"]) {
//        [self hideBannerAd];
//        [_bannerView removeFromSuperview];
//    } else {
//        float newMainViewHeight = _mainView.height + _bannerHeight - view.height;
//        _bannerHeight = view.height;
//
//        [UIView animateWithDuration:0.4
//                              delay:0.0
//                            options:UIViewAnimationOptionAllowUserInteraction
//                         animations:^{
//                             [_mainView setHeight:newMainViewHeight];
//                             [view setTop:newMainViewHeight];
//                         }
//                         completion:^(BOOL isFinished){
//                             
//                         }];
//    }
//}
//
//- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
//{
//    float newMainViewHeight = _mainView.height + _bannerHeight - view.height;
//    _bannerHeight = view.height;
//    
//    [UIView animateWithDuration:0.4
//                          delay:0.0
//                        options:UIViewAnimationOptionAllowUserInteraction
//                     animations:^{
//                         [_mainView setHeight:newMainViewHeight];
//                         [view setTop:newMainViewHeight];
//                     }
//                     completion:^(BOOL isFinished){
//                         
//                     }];
//}
//
//- (void)adViewWillLeaveApplication:(GADBannerView *)adView
//{
//    [self hideBannerAd];
//}

#pragma mark - Actions

- (IBAction)toggleFlipside:(id)sender
{
    [_toggleFlipsideButton setEnabled:NO];
    BOOL isShowingMainView = NO;
    NSString *buttonLabel;
    UIImage *buttonImage;
    if ([_flipsideView superview] == nil) {
        buttonLabel = [NSString stringWithFormat:@" %@", NSLocalizedString(@"Button - System Status", @"View System Status")];
        buttonImage = [UIImage imageNamed:@"globe_2.png"];
        [_flipsideView setFrame:_collectionView.frame];
        [self.view insertSubview:_flipsideView belowSubview:_collectionView];
        isShowingMainView = YES;
    } else {
        buttonLabel = [NSString stringWithFormat:@" %@", NSLocalizedString(@"Button - Detailed Timeline", @"View Detailed Timeline")];
        buttonImage = [UIImage imageNamed:@"calendar_2.png"];
        [_collectionView setFrame:_flipsideView.frame];
        [self.view insertSubview:_collectionView belowSubview:_flipsideView];
    }
    
    [_toggleFlipsideButton setTitle:buttonLabel forState:UIControlStateNormal];
    [_toggleFlipsideButton setImage:buttonImage forState:UIControlStateNormal];
    
    [UIView transitionFromView:(isShowingMainView ? _collectionView : _flipsideView)
                        toView:(isShowingMainView ? _flipsideView : _collectionView)
                      duration:0.5
                       options:(isShowingMainView ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight)
                    completion:^(BOOL isFinished){
                        if (isShowingMainView) {
                            [_collectionView removeFromSuperview];
                            [_tableView addSubview:_refreshControl];
                        } else {
                            [_tableView setContentOffset:CGPointMake(0.0f, 0.0f)];
                            [_flipsideView removeFromSuperview];
                            [_collectionView addSubview:_refreshControl];
                            [self updateStatus];
                        }
                        [_toggleFlipsideButton setEnabled:YES];
                    }];
}

- (IBAction)refreshStatus:(id)sender {
    [self updateStatus];
}

//- (void)hideBannerAd
//{
//    float newMainViewHeight = _mainView.height + _bannerHeight;
//    _bannerHeight = 0.0f;
//    
//    [UIView animateWithDuration:0.4
//                          delay:0.0
//                        options:UIViewAnimationOptionAllowUserInteraction
//                     animations:^{
//                         [_mainView setHeight:newMainViewHeight];
//                         [_bannerView setTop:newMainViewHeight];
//                     }
//                     completion:^(BOOL isFinished){
//                         
//                     }];
//}
//
//- (void)startBannerAd
//{
//    [_bannerView loadRequest:[GADRequest request]];
//}

#pragma mark - Image Creation

- (UIColor *)colorForServiceWithIdentifier:(NSString *)identifier
{
    UIColor *statusColor;
    
    if ([identifier isEqualToString:@"Maintenance"]) {
        statusColor = [UIColor colorWithRed: 0 green: 0.609 blue: 0.808 alpha: 1];
    }
    else if ([identifier isEqualToString:@"Issue"]) {
        statusColor = [UIColor colorWithRed: 0.806 green: 0.726 blue: 0 alpha: 1];
    }
    else {
        statusColor = [UIColor colorWithRed: 0.063 green: 0.751 blue: 0.442 alpha: 1];
    }
    
    return statusColor;
}

- (UIImage *)imageForServiceWithIdentifier:(NSString *)identifier
{
    UIColor *statusColor = [self colorForServiceWithIdentifier:identifier];
    NSString *drawingIdendifier;
    
    if ([identifier isEqualToString:@"Maintenance"]) {
        drawingIdendifier = @"serviceStatusMaintenance";
    }
    else if ([identifier isEqualToString:@"Issue"]) {
        drawingIdendifier = @"serviceStatusWarning";
    }
    else {
        drawingIdendifier = @"serviceStatusOkay";
    }
    
    return [UIImage imageWithIdentifier:drawingIdendifier
                                forSize:CGSizeMake(15.0f, 40.0f)
                        andDrawingBlock:^{
                            //// General Declarations
                            CGContextRef context = UIGraphicsGetCurrentContext();
                            
                            //// Color Declarations
//                            UIColor* statusColor = statusColor;
                            
                            //// Shadow Declarations
                            UIColor* shadow = [UIColor blackColor];
                            CGSize shadowOffset = CGSizeMake(1.1, -0.1);
                            CGFloat shadowBlurRadius = 1.5;
                            
                            //// Rectangle Drawing
                            UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, -1.5, 16, 43)];
                            [statusColor setFill];
                            [rectanglePath fill];
                            
                            ////// Rectangle Inner Shadow
                            CGRect rectangleBorderRect = CGRectInset([rectanglePath bounds], -shadowBlurRadius, -shadowBlurRadius);
                            rectangleBorderRect = CGRectOffset(rectangleBorderRect, -shadowOffset.width, -shadowOffset.height);
                            rectangleBorderRect = CGRectInset(CGRectUnion(rectangleBorderRect, [rectanglePath bounds]), -1, -1);
                            
                            UIBezierPath* rectangleNegativePath = [UIBezierPath bezierPathWithRect: rectangleBorderRect];
                            [rectangleNegativePath appendPath: rectanglePath];
                            rectangleNegativePath.usesEvenOddFillRule = YES;
                            
                            CGContextSaveGState(context);
                            {
                                CGFloat xOffset = shadowOffset.width + round(rectangleBorderRect.size.width);
                                CGFloat yOffset = shadowOffset.height;
                                CGContextSetShadowWithColor(context,
                                                            CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                                            shadowBlurRadius,
                                                            shadow.CGColor);
                                
                                [rectanglePath addClip];
                                CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(rectangleBorderRect.size.width), 0);
                                [rectangleNegativePath applyTransform: transform];
                                [[UIColor grayColor] setFill];
                                [rectangleNegativePath fill];
                            }
                            CGContextRestoreGState(context);
                            
                            [[UIColor darkGrayColor] setStroke];
                            rectanglePath.lineWidth = 0.5;
                            [rectanglePath stroke];
                        }];
}

- (UIImage *)imageForGlobalServiceWithColor:(UIColor *)color andIdentifier:(NSString *)identifer
{
    return [UIImage imageWithIdentifier:identifer
                                forSize:CGSizeMake(22.0f, 22.0f)
                        andDrawingBlock:^{
                            //// General Declarations
                            CGContextRef context = UIGraphicsGetCurrentContext();
                            
                            //// Shadow Declarations
                            UIColor* shadow = [UIColor blackColor];
                            CGSize shadowOffset = CGSizeMake(0.1, -0.1);
                            CGFloat shadowBlurRadius = 2.5;
                            
                            //// Oval Drawing
                            UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(4, 4, 14, 14)];
                            [color setFill];
                            [ovalPath fill];
                            
                            ////// Oval Inner Shadow
                            CGRect ovalBorderRect = CGRectInset([ovalPath bounds], -shadowBlurRadius, -shadowBlurRadius);
                            ovalBorderRect = CGRectOffset(ovalBorderRect, -shadowOffset.width, -shadowOffset.height);
                            ovalBorderRect = CGRectInset(CGRectUnion(ovalBorderRect, [ovalPath bounds]), -1, -1);
                            
                            UIBezierPath* ovalNegativePath = [UIBezierPath bezierPathWithRect: ovalBorderRect];
                            [ovalNegativePath appendPath: ovalPath];
                            ovalNegativePath.usesEvenOddFillRule = YES;
                            
                            CGContextSaveGState(context);
                            {
                                CGFloat xOffset = shadowOffset.width + round(ovalBorderRect.size.width);
                                CGFloat yOffset = shadowOffset.height;
                                CGContextSetShadowWithColor(context,
                                                            CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                                            shadowBlurRadius,
                                                            shadow.CGColor);
                                
                                [ovalPath addClip];
                                CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(ovalBorderRect.size.width), 0);
                                [ovalNegativePath applyTransform: transform];
                                [[UIColor grayColor] setFill];
                                [ovalNegativePath fill];
                            }
                            CGContextRestoreGState(context);
                            
                            [[UIColor blackColor] setStroke];
                            ovalPath.lineWidth = 1;
                            [ovalPath stroke];
                        }];
}

- (void)updateSupportFeedbackBadgeAnimated:(BOOL)animated
{
    NSInteger duration;
    if (animated) {
        duration = 0.4;
    } else {
        duration = 0.0;
    }
    
    if ([USER_DEFAULTS boolForKey:@"HAS SUPPORT PUSH"]) {
        [UIView animateWithDuration:duration
                         animations:^{
                             [_supportAlertLabel setAlpha:1.0f];
                         }];
    } else {
        [UIView animateWithDuration:duration
                         animations:^{
                             [_supportAlertLabel setAlpha:0.0f];
                         }];
    }
}

@end