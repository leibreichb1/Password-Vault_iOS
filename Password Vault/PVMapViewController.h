//
//  PVMapViewController.h
//  Password Vault
//
//  Created by Brian Leibreich on 10/30/12.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PVMapViewController : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *_mapView;

@end
