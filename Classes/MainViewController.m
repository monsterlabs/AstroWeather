//
//  MainViewController.m
//  AstroWeather
//
//  Created by Juan Germán Castañeda Echevarría on 10/10/10.
//  Copyright (c) 2010 UNAM. All rights reserved.
//

#import "MainViewController.h"

#import "AstroWeatherAppDelegate.h"

#define appDelegate (AstroWeatherAppDelegate *) [[UIApplication sharedApplication] delegate]

@interface MainViewController () //note the empty category name
- (NSUInteger)placesCount;
- (NSArray*)places;
- (void)setupView;
- (void)setupPlaceInfo:(Place *)place;
@end

@implementation MainViewController

@synthesize webView;
@synthesize loadingIndicator;
@synthesize placeNameLabel;
@synthesize closeHelpButton;
@synthesize helpImage;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [webView setDelegate:self];
    [self setupView];
}


- (IBAction)showInfo:(id)sender {
    int total = [self placesCount];
    if (total > 0) {
        FlipsideViewController *controller;
        controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
        controller.delegate = self;
        
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:controller animated:YES];
        
        [controller release];
    } else {
        MapViewController *controller;
        controller = [[MapViewController alloc] initWithNibName:@"MapView" bundle:nil];
        [controller setPlace:nil];
        controller.delegate = self;
        
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:controller animated:YES];
        
        [controller release];
    }
}


- (IBAction)showHelp:(id)sender {
    [UIView animateWithDuration:1.0 animations:^{
        helpImage.alpha = 1.0;
        closeHelpButton.alpha = 1.0;
    }];
}

- (IBAction)closeHelp:(id)sender {
    [UIView animateWithDuration:1.5 animations:^{
        helpImage.alpha = 0.0;
        closeHelpButton.alpha = 0.0;
    }];
}

#pragma mark FlipsideViewDelegate

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller withPlace:(Place *) place {
    
    [self dismissModalViewControllerAnimated:YES];
    if (place != nil) {
        [self setupPlaceInfo:place];
    }
    [self setupView];
}

#pragma mark WebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [loadingIndicator stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [loadingIndicator startAnimating];
}


#pragma mark MapViewDelegate


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
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"Selected"];
            [self setupPlaceInfo:place];
        }
    }
    [self setupView];
}

- (void)mapViewControllerDidFinishEditing:(MapViewController *)controller place:(PlaceAnnotation *) placeAnnotation {
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark ViewController


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
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

#pragma mark Private

- (void)setupView {
    NSArray *fetchResults = [self places];
    int total = [fetchResults count];
    int selected = [[NSUserDefaults standardUserDefaults] integerForKey:@"Selected"];
    if (selected >= total) {
        // Data corruption
        selected = 0;
        [[NSUserDefaults standardUserDefaults] setInteger:selected forKey:@"Selected"];
    }
    if (selected >= 0 && total > 0) {
        Place *place = [fetchResults objectAtIndex:selected];
        [self setupPlaceInfo:place];
    } else {
        [placeNameLabel setText:@"You should add and select a location first"];
        [webView loadHTMLString:@"<html><body></body></html>" baseURL:nil];
    }
}

- (NSArray*)places {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Place" inManagedObjectContext:[appDelegate managedObjectContext]];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *fetchedResults = [[appDelegate managedObjectContext] executeFetchRequest:request error:&error];
    [request release];
    return fetchedResults;
}

- (NSUInteger)placesCount {
    return [[self places] count];
}

- (void)setupPlaceInfo:(Place *) place {
    NSNumber *latitude = [place Latitude];
    NSNumber *longitude = [place Longitude];
    NSString *url = [NSString stringWithFormat:@"http://7timer.com/exe/apanel.php?lon=%@&lat=%@&en&", longitude,latitude];
    [webView loadRequest:[NSURLRequest
                          requestWithURL:[NSURL
                                          URLWithString:url]]];
    [placeNameLabel setText:[place Title]];
}

@end