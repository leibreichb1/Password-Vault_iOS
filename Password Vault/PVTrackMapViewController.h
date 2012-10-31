//
//  PVTrackMapViewController.h
//  Password Vault
//
//  Created by Brian Leibreich on 10/31/12.
//
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface PVTrackMapViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *_mapView;
@property (weak, nonatomic) IBOutlet UIView *_selectView;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
