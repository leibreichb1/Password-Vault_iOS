//
//  PVTrackedLocation.h
//  Password Vault
//
//  Created by Brian Leibreich on 11/1/12.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PVTrackedLocation : NSObject <MKAnnotation>{
    NSString *_name;
    NSString *_address;
    CLLocationCoordinate2D _coordinate;
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
-(CLLocationCoordinate2D)cord;

@end
