//
//  MapViewController.m
//  AstroWeather
//
//  Created by Juan Germán Castañeda Echevarría on 10/8/10.
//  Copyright (c) 2010 UNAM. All rights reserved.
//

#import "MapViewController.h"


@implementation MapViewController

@synthesize delegate;
@synthesize mapView;
@synthesize place;
@synthesize editMode;
@synthesize textField;

- (void)viewDidLoad {
    [super viewDidLoad];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPressGesture:)];
    
    [[self mapView] addGestureRecognizer:longPressGesture];
    [longPressGesture release];
    if (place != nil) {
        [textField setText:[place title]];
        [[self mapView] addAnnotation:place];
        [[self mapView] setCenterCoordinate:[place coordinate]];
    } else {
        //[textField setEnabled:NO];
        CLLocationCoordinate2D center;
        center.latitude = 0;
        center.longitude = 0;
        [[self mapView] setCenterCoordinate:center];
    }

}


- (IBAction)done:(id)sender {
    if (editMode) {
        [self.delegate mapViewControllerDidFinishEditing:self place:[place autorelease]];
        place.title = [textField text];
    } else {
        if (place == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Place Missing"
                                                            message:@"Please select a place in the map before saving."
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];   
            [alert release];
            return;
        }
        if ([[textField text] length] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name Missing"
                                                            message:@"Please provide a name for the place before saving." 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];   
            [alert release];
            return;
        }
        place.title = [textField text];        
        [self.delegate mapViewControllerDidFinish:self withPlace:[place autorelease]];
    }
}

- (IBAction)cancel:(id)sender {
    [self.delegate mapViewControllerDidFinish:self withPlace:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    if (place != nil) {
        place.title = [theTextField text];
    }
    return YES;
}

- (IBAction)handleLongPressGesture:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint pressPoint = [sender locationInView:mapView];
        CLLocationCoordinate2D coordinate = [mapView convertPoint:pressPoint toCoordinateFromView:mapView];
        
        if (place != nil) {
            [[self mapView] removeAnnotation:place];
        }
        
        place = [[PlaceAnnotation alloc] initWithCoordinate:coordinate title:@"Name"];
        
        [[self mapView] addAnnotation:place];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)amapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *AnnotationViewID = @"placeAnnotationViewID";
    
    MKPinAnnotationView *annotationView = 
        (MKPinAnnotationView *)[amapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID] autorelease];
    }
    
    annotationView.annotation = annotation;
    annotationView.draggable = YES;
    
    return annotationView;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
