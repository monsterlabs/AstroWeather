//
//  PlaceAnnotation.m
//  AstroWeather
//
//  Created by Juan Germán Castañeda Echevarría on 10/9/10.
//  Copyright (c) 2010 UNAM. All rights reserved.
//

#import "PlaceAnnotation.h"
#import "Place.h"
@implementation PlaceAnnotation

@synthesize coordinate;
@synthesize title;

- (id)initWithCoordinate:(CLLocationCoordinate2D)_coordinate title:(NSString *)_title {
    
	if ((self = [super init])) {
		self.coordinate = _coordinate;
        self.title = _title;
	}
	return self;
}

- (id)initWithPlace:(Place *)_place {
    
	if ((self = [super init])) {
        CLLocationCoordinate2D coord;
        coord.latitude = [[_place Latitude] doubleValue];
        coord.longitude = [[_place Longitude] doubleValue];
        
		self.coordinate = coord;
        self.title = [_place Title];
	}
	return self;
}


@end
