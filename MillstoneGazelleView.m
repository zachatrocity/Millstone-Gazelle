//
//  MillstoneGazelleView.m
//  Millstone
//
//  Created by Zach Russell on 04/14/2016.
//  Copyright (c) Zach Russell. All rights reserved.
//

#import <Gazelle/Gazelle.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "MillstoneGazelleView.h"

@implementation MillstoneGazelleView

- (UIColor *)presentationBackgroundColor {
	return [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.2];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
    	self.millstoneViewController = [[UIViewController alloc] init];
    	[self.millstoneViewController setView: self];

        RSDFDatePickerView *datePickerView = [[RSDFDatePickerView alloc] initWithFrame:self.bounds];
	    datePickerView.delegate = self;
	    datePickerView.dataSource = self;
	    [self addSubview:datePickerView];

	    //add button
	    self.addEventButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.addEventButton addTarget:self 
		           action:@selector(addEventButtonPressed:)
		 forControlEvents:UIControlEventTouchUpInside];
		[self.addEventButton setTitle:@"+" forState:UIControlStateNormal];
		self.addEventButton.frame = CGRectMake(10.0, frame.size.height - 40.0, 30.0, 30.0);
		self.addEventButton.layer.cornerRadius = 15;
		self.addEventButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.70 blue:0.18 alpha:1.0].CGColor;
		[self addSubview:self.addEventButton];
    }

    return self;
}

-(void)addEventButtonPressed:(id)sender{
	[Gazelle tearDownAnimated:YES];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"calshow://"]];
}

- (void)handleActionForIconTap  {
	/**
	* Decide what happens when the user taps on the icon view
	* Perhaps remove the presented view?
	*/
	[Gazelle tearDownAnimated:YES];

	/**
	* Or perhaps open the application?
	*/
	[Gazelle openApplicationForBundleIdentifier:@"com.apple.mobilecal"];
}

// Returns YES if the date should be highlighted or NO if it should not.
- (BOOL)datePickerView:(RSDFDatePickerView *)view shouldHighlightDate:(NSDate *)date
{
    return YES;
}

// Returns YES if the date should be selected or NO if it should not.
- (BOOL)datePickerView:(RSDFDatePickerView *)view shouldSelectDate:(NSDate *)date
{
    return YES;
}

// Prints out the selected date.
- (void)datePickerView:(RSDFDatePickerView *)view didSelectDate:(NSDate *)date
{
    EKEventStore *store = [[EKEventStore alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDate *startDate = [calendar dateBySettingHour:0  minute:0  second:0  ofDate:date options:0];
	NSDate *endDate   = [calendar dateBySettingHour:23 minute:59 second:59 ofDate:date options:0];

	NSPredicate *predicate = [store predicateForEventsWithStartDate:startDate
	                                                        endDate:endDate
	                                                      calendars:nil];

	NSArray *events = [store eventsMatchingPredicate:predicate];
	CGFloat start = 20;

	//remove currently displayed events
	for (int i = 0; i < [self.labelArray count]; ++i)
	{
		UILabel *oldLbl = self.labelArray[i];
		[oldLbl removeFromSuperview];
	}

	self.labelArray = [[NSMutableArray alloc] init];

	self.lastTouchedDate = date;

	for (int i = 0; i < [events count]; ++i)
	{
		NSString * str = @"";
		EKEvent * evnt = events[i];
		CBAutoScrollLabel *lbl = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(0,start,self.frame.size.width, 20)];
		lbl.textColor = [UIColor whiteColor];
		lbl.labelSpacing = 35; // distance between start and end labels
		lbl.pauseInterval = 1.0; // seconds of pause before scrolling starts again
		lbl.scrollSpeed = 30; // pixels per second
		lbl.textAlignment = NSTextAlignmentCenter; // centers text when no auto-scrolling is applied
		lbl.fadeLength = 12.f; // length of the left and right edge fade, 0 to disable

	    //format the output
	    NSDate *date = evnt.startDate;
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterNoStyle];
		[formatter setTimeStyle:NSDateFormatterShortStyle];

	    str = [str stringByAppendingString: [formatter stringFromDate:date]];
	    str = [str stringByAppendingString:@" - "];
	    str = [str stringByAppendingString:evnt.title];
		lbl.text = str;
		lbl.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.6];
		start += 20;
		[self addSubview: lbl];
		[self.labelArray addObject: lbl];
	}
}

// Returns YES if the date should be marked or NO if it should not.
- (BOOL)datePickerView:(RSDFDatePickerView *)view shouldMarkDate:(NSDate *)date
{
	EKEventStore *store = [[EKEventStore alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDate *startDate = [calendar dateBySettingHour:0  minute:0  second:0  ofDate:date options:0];
	NSDate *endDate   = [calendar dateBySettingHour:23 minute:59 second:59 ofDate:date options:0];

	NSPredicate *predicate = [store predicateForEventsWithStartDate:startDate
	                                                        endDate:endDate
	                                                      calendars:nil];

	NSArray *events = [store eventsMatchingPredicate:predicate];
	if(events == nil || [events count] == 0){
		return NO;
	} else {
		return YES;
	}
}

// Returns the color of the default mark image for the specified date.
- (UIColor *)datePickerView:(RSDFDatePickerView *)view markImageColorForDate:(NSDate *)date
{
    if (arc4random() % 2 == 0) {
        return [UIColor grayColor];
    } else {
        return [UIColor greenColor];
    }
}

// Returns the mark image for the specified date.
- (UIImage *)datePickerView:(RSDFDatePickerView *)view markImageForDate:(NSDate *)date
{
    if (arc4random() % 2 == 0) {
        return [UIImage imageNamed:@"img_gray_mark"];
    } else {
        return [UIImage imageNamed:@"img_green_mark"];
    }
}

@end
