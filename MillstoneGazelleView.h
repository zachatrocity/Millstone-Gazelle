//
//  MillstoneGazelleView.h
//  Millstone
//
//  Created by Zach Russell on 04/14/2016.
//  Copyright (c) Zach Russell. All rights reserved.
//
#import "RSDFDatePickerView.h"
#import "CBAutoScrollLabel.h"
#define log(z) NSLog(@"[Millstone] %@", z)

@interface MillstoneGazelleView : UIView <RSDFDatePickerViewDelegate, RSDFDatePickerViewDataSource>
@property NSMutableArray *labelArray;
@property UIButton *addEventButton;
@property NSDate *lastTouchedDate;
@property UIViewController *millstoneViewController;
/**
* If you need to change the background color of the block view
* this is where you would change it
*/
- (UIColor *)presentationBackgroundColor;
-(void)addEventButtonPressed:(id)sender;
/**
* This is called after a user taps on the presented views icon image
* You don't need to do anything except tell it what to do
*/
- (void)handleActionForIconTap;
@end
