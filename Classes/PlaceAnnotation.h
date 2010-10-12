//
//  PlaceAnnotation.h
//  AstroWeather
//
//  Created by Juan Germán Castañeda Echevarría on 10/9/10.
//  Copyright (c) 2010 UNAM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class Place;

@interface PlaceAnnotation : NSObject <MKAnnotation>{
    CLLocationCoordinate2D coordinate;
    
    NSString *title;
}

@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;

- (id)initWithCoordinate:(CLLocationCoordinate2D)_coordinate title:(NSString *)_title;
- (id)initWithPlace:(Place *)_place;

@end
