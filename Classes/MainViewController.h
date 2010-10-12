//
//  MainViewController.h
//  AstroWeather
//
//  Created by Juan Germán Castañeda Echevarría on 10/12/10.
//  Copyright 2010 UNAM. All rights reserved.
//

#import "FlipsideViewController.h"
#import <CoreData/CoreData.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
    NSManagedObjectContext *managedObjectContext;	    
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction)showInfo:(id)sender;

@end
