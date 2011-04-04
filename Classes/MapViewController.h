//
//  MapViewController.h
//  AstroWeather
//
//  Created by Juan Germán Castañeda Echevarría on 10/8/10.
//  Copyright (c) 2010 UNAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PlaceAnnotation.h"
#import <CoreLocation/CLLocation.h>

@protocol MapViewControllerDelegate;

@interface MapViewController : UIViewController <UITextFieldDelegate,MKMapViewDelegate> {
    id <MapViewControllerDelegate> delegate;
    MKMapView *mapView;
    PlaceAnnotation *place;
    bool editMode;
    UITextField *textField;
}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) PlaceAnnotation  *place;
@property (nonatomic, assign) id <MapViewControllerDelegate> delegate;
@property (nonatomic, assign) bool editMode;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end


@protocol MapViewControllerDelegate
- (void)mapViewControllerDidFinish:(MapViewController *)controller withPlace:(PlaceAnnotation *) place;
- (void)mapViewControllerDidFinishEditing:(MapViewController *)controller place:(PlaceAnnotation *) place;
@end