//
//  FlipsideViewController.m
//  AstroWeather
//
//  Created by Juan Germán Castañeda Echevarría on 10/10/10.
//  Copyright (c) 2010 UNAM. All rights reserved.
//

#import "FlipsideViewController.h"
#import "AstroWeatherAppDelegate.h"

#define appDelegate (AstroWeatherAppDelegate *) [[UIApplication sharedApplication] delegate]

@implementation FlipsideViewController

@synthesize delegate;
@synthesize placesPicker;
@synthesize deleteButton, editButton;
@synthesize places;


- (void)viewDidLoad {
    NSDictionary *resourceDict = [NSDictionary dictionary];
    [[NSUserDefaults standardUserDefaults] registerDefaults:resourceDict];
    
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Place" inManagedObjectContext:[appDelegate managedObjectContext]];
    [request setEntity:entity];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[[appDelegate managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // Handle the error.
    }
    [self setPlaces:mutableFetchResults];
    int selected = [[NSUserDefaults standardUserDefaults] integerForKey:@"Selected"];
    if (selected >= 0 && [places count] > selected) {
        [placesPicker selectRow:selected inComponent:0 animated:true];
    } else {
        [editButton setEnabled:NO];
        [deleteButton setEnabled:NO];
    }
    [mutableFetchResults release];
    [request release];
}


- (IBAction)done:(id)sender {
    NSInteger selectedIdx = [placesPicker selectedRowInComponent:0];
    Place *place = nil;
    if (selectedIdx >= 0 && [places count] > 0) {
        place = [places objectAtIndex:selectedIdx];
        [[NSUserDefaults standardUserDefaults] setInteger:selectedIdx forKey:@"Selected"];
    }
    [self.delegate flipsideViewControllerDidFinish:self withPlace:place];	
}

- (IBAction)delete:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != 0) {
        return;
    }
    // Proceed to delete
    NSUInteger selectedIdx = [placesPicker selectedRowInComponent:0];
    NSManagedObject *placeToDelete = [places objectAtIndex:selectedIdx];
    [[appDelegate managedObjectContext] deleteObject:placeToDelete];
    
    [places removeObjectAtIndex:selectedIdx];
    
    [placesPicker reloadAllComponents];
    
    NSError *error;
    if (![[appDelegate managedObjectContext] save:&error]) {
        // Handle the error.
    } else {
        if ([places count] == 0){
            [editButton setEnabled:NO];
            [deleteButton setEnabled:NO];
        }
        selectedIdx = [placesPicker selectedRowInComponent:0];
        [[NSUserDefaults standardUserDefaults] setInteger:selectedIdx forKey:@"Selected"];
    }
}

- (IBAction)edit:(id)sender {
    MapViewController *controller = [[MapViewController alloc] initWithNibName:@"MapView" bundle:nil];
	controller.delegate = self;
    
    NSUInteger selectedIdx = [placesPicker selectedRowInComponent:0];
    Place *placeToEdit = [places objectAtIndex:selectedIdx];
    PlaceAnnotation *annotation = [[PlaceAnnotation alloc] initWithPlace:placeToEdit];
    
    [controller setPlace: annotation];
    [annotation release];
    controller.editMode = YES;
	
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (IBAction)showMap:(id)sender {
    MapViewController *controller = [[MapViewController alloc] initWithNibName:@"MapView" bundle:nil];
	controller.delegate = self;
    [controller setPlace:nil];
	
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (void)mapViewControllerDidFinish:(MapViewController *)controller withPlace:(PlaceAnnotation *) placeAnnotation {
	[self dismissModalViewControllerAnimated:YES];
    if (placeAnnotation != nil) {
        Place *place = (Place *)[NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:[appDelegate managedObjectContext]];
        
        CLLocationCoordinate2D coordinate = [placeAnnotation coordinate];
        [place setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
        [place setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
        [place setTitle:[placeAnnotation title]];
        
        NSError *error;
        if (![[appDelegate managedObjectContext] save:&error]) {
            // Handle the error.
        } else {
            [editButton setEnabled:YES];
            [deleteButton setEnabled:YES];
            [places addObject:place];
            [placesPicker reloadAllComponents];
        }
    }
}

- (void)mapViewControllerDidFinishEditing:(MapViewController *)controller place:(PlaceAnnotation *) placeAnnotation {
	[self dismissModalViewControllerAnimated:YES];
    if (placeAnnotation != nil) {
        NSUInteger selectedIdx = [placesPicker selectedRowInComponent:0];
        Place *placeToEdit = [places objectAtIndex:selectedIdx];
        
        //Place *place = (Place *)[NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:[appDelegate managedObjectContext]];
        
        CLLocationCoordinate2D coordinate = [placeAnnotation coordinate];
        [placeToEdit setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
        [placeToEdit setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
        [placeToEdit setTitle:[placeAnnotation title]];
        
        NSError *error;
        if (![[appDelegate managedObjectContext] save:&error]) {
            // Handle the error.
        } else {
            [editButton setEnabled:YES];
            [deleteButton setEnabled:YES];
            [placesPicker reloadAllComponents];
        }
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[places objectAtIndex:row] Title];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [places count];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)dealloc {
    [super dealloc];
}


@end