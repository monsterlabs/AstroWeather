//
//  Place.h
//  AstroWeather
//
//  Created by Juan Germán Castañeda Echevarría on 10/10/10.
//  Copyright 2010 UNAM. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Place :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * Latitude;
@property (nonatomic, retain) NSString * Title;
@property (nonatomic, retain) NSNumber * Longitude;

@end



