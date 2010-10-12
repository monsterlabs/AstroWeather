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

@implementation MainViewController
@synthesize webView;
@synthesize loadingIndicator;
@synthesize placeNameLabel;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [webView setDelegate:self];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Place" inManagedObjectContext:[appDelegate managedObjectContext]];
    [request setEntity:entity];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[[appDelegate managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // Handle the error.
    }
    int selected = [[NSUserDefaults standardUserDefaults] integerForKey:@"Selected"];
    
    if (selected >= 0 && [mutableFetchResults count] > 0) {
        Place *place = [mutableFetchResults objectAtIndex:selected];
        NSNumber *latitude = [place Latitude];
        NSNumber *longitude = [place Longitude];
        NSString *url = [NSString stringWithFormat:@"http://7timer.y234.cn/V3/exe/apanel.php?lon=%@&lat=%@&en&sfc", longitude,latitude];
        [webView loadRequest:[NSURLRequest
                              requestWithURL:[NSURL
                                              URLWithString:url]]];
        [placeNameLabel setText:[place Title]];
    } else {
        [placeNameLabel setText:@"You should add some locations first"];
    }
}


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller withPlace:(Place *) place {
    
    [self dismissModalViewControllerAnimated:YES];
    if (place != nil) {
        NSNumber *latitude = [place Latitude];
        NSNumber *longitude = [place Longitude];
        NSString *url = [NSString stringWithFormat:@"http://7timer.y234.cn/V3/exe/apanel.php?lon=%@&lat=%@&en&sfc", longitude,latitude];
        [webView loadRequest:[NSURLRequest
                              requestWithURL:[NSURL
                                              URLWithString:url]]];
        [placeNameLabel setText:[place Title]];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [loadingIndicator stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [loadingIndicator startAnimating];
}



- (IBAction)showInfo:(id)sender {
    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
    controller.delegate = self;
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    
    [controller release];
}


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

@end