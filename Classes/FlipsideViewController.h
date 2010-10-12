//
//  FlipsideViewController.h
//  AstroWeather
//
//  Created by Juan Germán Castañeda Echevarría on 10/10/10.
//  Copyright (c) 2010 UNAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "Place.h"
@class AstroWeatherAppDelegate;

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController <MapViewControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource>{
	id <FlipsideViewControllerDelegate> delegate;
    UIPickerView *placesPicker;
    NSMutableArray *places;
}
@property (nonatomic, retain) NSMutableArray *places;
@property (nonatomic, retain) IBOutlet UIPickerView *placesPicker;
@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
- (IBAction)done:(id)sender;
- (IBAction)edit:(id)sender;
- (IBAction)delete:(id)sender;
- (IBAction)showMap:(id)sender;


@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller withPlace:(Place *)place;
@end
