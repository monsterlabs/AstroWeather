//
//  MainViewController.h
//  AstroWeather
//
//  Created by Juan Germán Castañeda Echevarría on 10/10/10.
//  Copyright (c) 2010 UNAM. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate,UIWebViewDelegate> {
    UIWebView *webView;
    UILabel *placeNameLabel;
    UIActivityIndicatorView *loadingIndicator;
}

@property (readwrite, nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UILabel *placeNameLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicator;

- (IBAction)showInfo:(id)sender;

@end
