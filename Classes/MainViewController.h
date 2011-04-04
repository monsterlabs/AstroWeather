//
//  MainViewController.h
//  AstroWeather
//
//  Created by Juan Germán Castañeda Echevarría on 10/10/10.
//  Copyright (c) 2010 UNAM. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate,UIWebViewDelegate, MapViewControllerDelegate> {
    UIWebView *webView;
    UILabel *placeNameLabel;
    UIActivityIndicatorView *loadingIndicator;
    UIButton *closeHelpButton;
    UIImageView *helpImage;
}

@property (readwrite, nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UILabel *placeNameLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, retain) IBOutlet UIButton *closeHelpButton;
@property (nonatomic, retain) IBOutlet UIImageView *helpImage;

- (IBAction)showInfo:(id)sender;
- (IBAction)showHelp:(id)sender;
- (IBAction)closeHelp:(id)sender;

@end
