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
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
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
        [textField setEnabled:NO];
        CLLocationCoordinate2D center;
        [[self mapView] setCenterCoordinate:center];
    }

}


- (IBAction)done:(id)sender {
    if (editMode) {
        [self.delegate mapViewControllerDidFinishEditing:self place:[place autorelease]];
    } else {
        [self.delegate mapViewControllerDidFinish:self withPlace:[place autorelease]];	
    }
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
        CGPoint longPressPoint = [sender locationInView:mapView];
        CLLocationCoordinate2D coordinate = [mapView convertPoint:longPressPoint toCoordinateFromView:mapView];
        
        if (place != nil) {
            [[self mapView] removeAnnotation:place];
        }
        
        place = [[PlaceAnnotation alloc] initWithCoordinate:coordinate title:@"Name"];
        [textField setEnabled:YES];
        
        [[self mapView] addAnnotation:place];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
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
